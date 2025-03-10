import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:test_app_flutter/emitter/emitter.dart';
import 'package:test_app_flutter/extension/widget_iterable_extension.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_action.dart';
import 'package:test_app_flutter/widget/shared_library/loading/loading_controller.dart';
import 'package:test_app_flutter/widget/shared_library/loading/loading_wrapper.dart';
import 'package:test_app_flutter/widget/shared_library/shared/shared_app_scaffold.dart';

abstract class AppPageSection {
  final bool Function()? include;
  final EdgeInsets? padding;
  late AppPage appPage;

  AppPageSection({this.include, this.padding});

  void initState() {}
  Widget build(BuildContext context);
}

class AppPage<T> {
  final ScaffoldAdapter scaffold;

  final ReadableEmitter<T>? loadingEmitter;
  final AppAction? floatingAction;
  final Future<void> Function()? onInit;
  final Future<void> Function()? onDispose;
  final Future<void> Function(T item)? afterLoad;
  final Future<void> Function()? afterLayout;

  final List<AppPageSection> sections;
  final double? sectionGapSize;
  final EdgeInsets? padding;

  Function()? onRefresh;
  Function()? onReload;

  AppPage({
    required this.scaffold,
    this.loadingEmitter,
    this.floatingAction,
    this.onInit,
    this.onDispose,
    this.afterLoad,
    this.afterLayout,
    this.sections = const [],
    this.sectionGapSize,
    this.padding,
  });

  void refreshWidget() {
    onRefresh?.call();
  }

  void reloadWidget() {
    onReload?.call();
  }

  Widget build() => AppPageWidget(config: this);
}

class AppPageWidget<T> extends StatefulWidget {
  final AppPage<T> config;

  const AppPageWidget({super.key, required this.config});

  @override
  State<AppPageWidget> createState() => _AppPageWidgetState<T>();
}

class _AppPageWidgetState<T> extends State<AppPageWidget<T>> with TickerProviderStateMixin {
  late final _loadingController = LoadingController(buildMethod: _page, initialAction: _load);

  AppPage<T> get _config => widget.config;

  StreamSubscription? _emitterSubscription;

  @override
  void initState() {
    super.initState();

    for (final section in _config.sections) {
      section.appPage = _config;
      section.initState();
    }

    if (_config.loadingEmitter != null) {
      _emitterSubscription = _config.loadingEmitter!.stream.listen((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
    _config.onInit?.call();

    _config.onRefresh = () {
      if (mounted) {
        setState(() {});
      }
    };

    _config.onReload = () {
      _load(useCache: false);
    };
  }

  @override
  void dispose() {
    _config.onDispose?.call();
    if (_emitterSubscription != null) {
      _emitterSubscription!.cancel();
    }
    super.dispose();
  }

  Future<void> _load({bool useCache = true}) async {
    if (_config.loadingEmitter != null) {
      final item = _config.loadingEmitter!.value;

      await _config.afterLoad?.call(item);
    }

    if (mounted) {
      setState(() {});
    }

    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      _config.afterLayout?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWrapper(controller: _loadingController);
  }

  Widget _page(BuildContext context) {
    final sharedScaffold = _config.scaffold.toSharedAppScaffold();
    sharedScaffold.onReload = () async => _load(useCache: false);

    return SharedAppScaffoldWidget(
      config: sharedScaffold,
      body: _body(),
    );
  }

  Widget _body() {
    final includedSections = _config.sections.where((s) => s.include?.call() ?? true);
    final sectionWidgetsWithGaps = includedSections.map(_section).withGaps(_config.sectionGapSize ?? 0);
    final sectionsColumn = _config.sections.length == 1 ? sectionWidgetsWithGaps.first : Column(children: sectionWidgetsWithGaps);

    if (_config.padding == null) {
      return sectionsColumn;
    }

    return Padding(
      padding: _config.padding!,
      child: sectionsColumn,
    );
  }

  Widget _section(AppPageSection section) {
    if (section.padding == null) {
      return section.build(context);
    }
    return Padding(
      padding: section.padding!,
      child: section.build(context),
    );
  }
}
