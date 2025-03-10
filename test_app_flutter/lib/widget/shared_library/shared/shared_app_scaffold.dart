import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_action.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_button.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_confirmation_bottom_sheet.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_refresh_indicator.dart';

class SharedAppScaffoldBackground {
  final double minWidth;
  final double verticalOffset;
  final double? opacity;
  final Widget child;

  const SharedAppScaffoldBackground({
    this.minWidth = 0,
    this.verticalOffset = 0,
    this.opacity,
    required this.child,
  });

  double imageWidth(double maxWidth) => maxWidth >= minWidth ? maxWidth : minWidth;
}

class SharedAppScaffoldAppBar {
  final String? titleText;
  final Widget Function()? titleBuilder;
  final List<AppButton> topRightIcons;
  final bool? showBackButton;

  SharedAppScaffoldAppBar({
    this.titleText,
    this.titleBuilder,
    this.topRightIcons = const [],
    this.showBackButton,
  });
}

abstract class ScaffoldAdapter {
  SharedAppScaffold toSharedAppScaffold();
}

class SharedAppScaffold {
  final SharedAppScaffoldAppBar? appBar;
  final Widget? body;
  final bool? useRefreshIndicator;
  Future<void> Function()? onReload;
  final AppItemAction<BuildContext>? floatingAction;

  final SharedAppScaffoldBackground? topBackground;
  final SharedAppScaffoldBackground? bottomBackground;

  final Widget Function(BuildContext context)? logoBuilder;
  final List<String> featureDiscoveryNames;

  SharedAppScaffold({
    this.appBar,
    this.body,
    this.useRefreshIndicator,
    this.onReload,
    this.floatingAction,
    this.topBackground,
    this.bottomBackground,
    this.logoBuilder,
    this.featureDiscoveryNames = const [],
  });

  SharedAppScaffoldWidget build({Widget? body, Function()? onReload}) {
    final missingBody = Center(child: Text('Missing Body'));
    final scaffoldBody = body ?? this.body ?? missingBody;
    return SharedAppScaffoldWidget(config: this, body: scaffoldBody);
  }
}

class SharedAppScaffoldWidget extends StatefulWidget {
  final SharedAppScaffold config;
  final Widget body;

  const SharedAppScaffoldWidget({super.key, required this.config, required this.body});

  @override
  State<SharedAppScaffoldWidget> createState() => _SharedAppScaffoldWidgetState();
}

class _SharedAppScaffoldWidgetState extends State<SharedAppScaffoldWidget> {
  SharedAppScaffold get _config => widget.config;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      floatingActionButton: _floatingActionButton(true),
      body: _body(),
    );
  }

  Widget _body() {
    Widget child = LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          if (_config.topBackground != null)
            _background(
              _config.topBackground!,
              VerticalDirection.up,
              constraints.maxWidth,
            ),
          if (_config.bottomBackground != null)
            _background(
              _config.bottomBackground!,
              VerticalDirection.down,
              constraints.maxWidth,
            ),
          widget.body,
        ],
      );
    });
    if (_config.useRefreshIndicator ?? true) {
      child = AppRefreshIndicator(
        onRefresh: () async => _config.onReload?.call(),
        child: child,
      );
    }
    return child;
  }

  Widget _background(SharedAppScaffoldBackground background, final VerticalDirection verticalDirection, double maxWidth) {
    final imageWidth = background.imageWidth(maxWidth);

    return Positioned(
      top: verticalDirection == VerticalDirection.up ? background.verticalOffset : null,
      bottom: verticalDirection == VerticalDirection.down ? background.verticalOffset : null,
      left: maxWidth >= background.minWidth ? 0 : (maxWidth - background.minWidth) / 2,
      child: SizedBox(
        width: imageWidth,
        child: Align(
          alignment: Alignment.topCenter,
          child: Opacity(opacity: background.opacity ?? 1, child: background.child),
        ),
      ),
    );
  }

  AppBar? _appBar() {
    if (_config.appBar == null) {
      return null;
    }

    final topRightIcons = _config.appBar?.topRightIcons ?? [];

    return AppBar(
      title: _title(),
      centerTitle: true,
      actions: topRightIcons.map((i) => i.build()).toList(),
      automaticallyImplyLeading: (_config.appBar!.showBackButton ?? true),
    );
  }

  Widget? _title() {
    if (_config.appBar?.titleText != null) {
      return Text(
        _config.appBar!.titleText!,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.outline),
      );
    } else if (_config.appBar!.titleBuilder != null) {
      return _config.appBar!.titleBuilder!();
    } else {
      return null;
    }
  }

  Widget? _floatingActionButton(bool isOnline) {
    if (_config.floatingAction == null || !_config.floatingAction!.isEnabledValue || !isOnline) {
      return null;
    }

    final button = FloatingActionButton.extended(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.primary,
      onPressed: _onFloatingActionPressed,
      label: Text(_config.floatingAction!.label.text ?? 'Missing Label'),
    );

    return button;
  }

  Future<void> _onFloatingActionPressed() async {
    if (_config.floatingAction!.isBlocking) {
      await showAppModalBottomSheet(context, _config.floatingAction!.toAppAction(context));
    } else {
      await _config.floatingAction!.toAppAction(context).onPressed();
    }
  }
}
