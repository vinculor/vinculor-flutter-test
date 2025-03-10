import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_app_flutter/emitter/emitter.dart';

class AppPageSwitcherPageConfig<T> {
  final T page;
  final Widget Function() builder;

  const AppPageSwitcherPageConfig({required this.page, required this.builder});
}

class AppPageSwitcherConfig<T> {
  final ReadableEmitter<T> emitter;
  final List<AppPageSwitcherPageConfig<T>> pages;

  const AppPageSwitcherConfig({required this.emitter, required this.pages});

  Widget Function() get currentBuilder => pages.firstWhere((page) => page.page == emitter.value).builder;

  Widget buildCurrentPage() => currentBuilder();

  Widget build() => AppPageSwitcher<T>(config: this);
}

class AppPageSwitcher<T> extends StatefulWidget {
  final AppPageSwitcherConfig<T> config;

  const AppPageSwitcher({super.key, required this.config});

  @override
  State<AppPageSwitcher<T>> createState() => _AppPageSwitcherState<T>();
}

class _AppPageSwitcherState<T> extends State<AppPageSwitcher<T>> {
  late StreamSubscription<T> _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = widget.config.emitter.stream.listen((_) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return widget.config.buildCurrentPage();
  }
}
