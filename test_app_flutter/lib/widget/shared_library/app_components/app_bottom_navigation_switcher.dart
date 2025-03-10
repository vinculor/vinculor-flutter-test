import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_app_flutter/emitter/emitter.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_label.dart';

class AppBottomNavigationSwitcherPageConfig<T> {
  final T value;
  final AppLabel label;
  final Widget Function() pageBuilder;

  const AppBottomNavigationSwitcherPageConfig({
    required this.value,
    required this.label,
    required this.pageBuilder,
  });
}

class AppBottomNavigationSwitcherConfig<T> {
  final Emitter<T> emitter;
  final List<AppBottomNavigationSwitcherPageConfig<T>> pages;

  const AppBottomNavigationSwitcherConfig({required this.emitter, required this.pages});

  AppBottomNavigationSwitcherPageConfig<T> get currentPage => pages.firstWhere((page) => page.value == emitter.value);

  int get currentPageIndex => pages.indexOf(currentPage);

  Widget buildCurrentPage() => currentPage.pageBuilder();

  void onIndexChanged(int index) {
    final page = pages[index];
    emitter.value = page.value;
  }

  Widget build() => AppBottomNavigationSwitcher(config: this);
}

class AppBottomNavigationSwitcher extends StatefulWidget {
  final AppBottomNavigationSwitcherConfig config;

  const AppBottomNavigationSwitcher({super.key, required this.config});

  @override
  State<AppBottomNavigationSwitcher> createState() => _AppBottomNavigationSwitcherState();
}

class _AppBottomNavigationSwitcherState extends State<AppBottomNavigationSwitcher> {
  AppBottomNavigationSwitcherConfig get _config => widget.config;
  late StreamSubscription _subscription;

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
    return Scaffold(
        body: _config.buildCurrentPage(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _config.currentPageIndex,
          onTap: (index) => _config.onIndexChanged(index),
          items: _config.pages.map(_navigationBarItem).toList(),
          type: BottomNavigationBarType.fixed,
        ));
  }

  BottomNavigationBarItem _navigationBarItem(AppBottomNavigationSwitcherPageConfig pageConfig) {
    final label = AppLabel(
      iconData: pageConfig.label.iconData,
      color: pageConfig.label.color,
      padding: pageConfig.label.padding,
    );

    return BottomNavigationBarItem(
      icon: label.build(),
      label: pageConfig.label.text,
    );
  }
}
