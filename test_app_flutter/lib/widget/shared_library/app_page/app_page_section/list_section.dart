import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_app_flutter/emitter/emitter.dart';
import 'package:test_app_flutter/extension/widget_iterable_extension.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_button.dart';
import 'package:test_app_flutter/widget/shared_library/app_page/app_page.dart';
import 'package:test_app_flutter/widget/shared_library/common/centered_info.dart';

class EmptyListMessage {
  final String titleText;
  final String subtitleText;
  final double? topPadding;

  const EmptyListMessage({required this.titleText, required this.subtitleText, this.topPadding});
}

class ListItemGroup<T> {
  final bool isActive;
  final String? titleText;
  final bool? showCount;
  final bool Function(T item)? filter;
  final Widget Function(T item) builder;
  final EdgeInsets? padding;
  final bool? useDividers;
  final AppButton? addButton;

  ListItemGroup({
    this.isActive = false,
    this.titleText,
    this.showCount,
    this.filter,
    required this.builder,
    this.padding,
    this.useDividers,
    this.addButton,
  });

  List<T> filterItems(List<T> items) {
    return items.where(filter ?? (_) => true).toList();
  }

  bool shouldShow(List<T> items) {
    final filteredItems = filterItems(items);

    return filteredItems.isNotEmpty || addButton != null;
  }
}


class ListSection<T> extends AppPageSection {
  final ReadableEmitter<List<T>> listEmitter;
  final EmptyListMessage? empty;
  final List<ListItemGroup<T>> itemGroups;
  final double? sectionGapSize;

  ListSection({
    super.include,
    super.padding,
    required this.listEmitter,
    this.empty,
    required this.itemGroups,
    this.sectionGapSize,
  });

  bool showAnySections(List<T> items) {
    return itemGroups.any((s) => s.shouldShow(items));
  }

  @override
  Widget build(BuildContext context) => ListSectionWidget<T>(config: this);
}

class ListSectionWidget<T> extends StatefulWidget {
  final ListSection<T> config;

  const ListSectionWidget({super.key, required this.config});

  @override
  State<ListSectionWidget> createState() => _ListSectionWidgetState<T>();
}

class _ListSectionWidgetState<T> extends State<ListSectionWidget<T>> with TickerProviderStateMixin {
  ListSection<T> get _config => widget.config;

  List<T> get _items => _config.listEmitter.value;

  @override
  void initState() {
    super.initState();
    _emitterSubscription = _config.listEmitter.stream.listen((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _emitterSubscription.cancel();
    super.dispose();
  }

  late StreamSubscription _emitterSubscription;

  @override
  Widget build(BuildContext context) {
    if (_config.showAnySections(_items)) {
      return _sectionsColumn();
    }

    if (_config.empty != null) {
      return _emptyCenteredInfo();
    }

    return SizedBox();
  }

  Widget _emptyCenteredInfo() {
    return Padding(
      padding: EdgeInsets.only(top: _config.empty?.topPadding ?? 0),
      child: CenteredInfo(
        titleText: _config.empty?.titleText ?? 'No Items',
        bodyText: _config.empty?.subtitleText ?? 'There are no items',
      ),
    );
  }

  Widget _sectionsColumn() {
    final shouldShowSections = _config.itemGroups.where((s) => s.shouldShow(_items));

    final shouldAddExtraPadding = (shouldShowSections.any((s) => s.isActive && s.filterItems(_items).isNotEmpty));

    final sectionWidgets = shouldShowSections.map((s) => _sectionColumn(s, shouldAddExtraPadding)).toList();
    final sectionWidgetsWithGaps = _config.sectionGapSize != null ? sectionWidgets.withGaps(_config.sectionGapSize!) : sectionWidgets;

    return Column(
      children: sectionWidgetsWithGaps,
    );
  }

  Widget _sectionColumn(ListItemGroup<T> section, bool shouldAddExtraPadding) {
    final filter = section.filter ?? (_) => true;
    final filteredItems = <T>[];
    for (final item in _config.listEmitter.value) {
      if (filter(item)) {
        filteredItems.add(item);
      }
    }
    final itemWidgets = filteredItems.map(section.builder).toList();

    final column = Column(children: section.useDividers ?? true ? itemWidgets.withDividers() : itemWidgets);

    final card = Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
      child: Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(children: itemWidgets.withDividers()),
        ),
      ),
    );

    final titleText = section.titleText;
    final showCount = section.showCount ?? true;

    final titleRowWidgets = [
      if (titleText != null) Text(section.titleText!, style: Theme.of(context).textTheme.bodyMedium),
      if (titleText != null && showCount) Text('(${filteredItems.length})', style: Theme.of(context).textTheme.bodyMedium),
      if (section.addButton != null) section.addButton!.build(),
    ];

    return Padding(
      padding: section.padding ?? EdgeInsets.zero,
      child: Column(
        children: [
          if (titleRowWidgets.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: titleRowWidgets.withGaps(8),
            ),
          section.isActive ? card : column,
        ],
      ),
    );
  }
}
