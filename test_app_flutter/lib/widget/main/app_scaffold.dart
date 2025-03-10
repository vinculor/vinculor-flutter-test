import 'package:flutter/material.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_action.dart';
import 'package:test_app_flutter/widget/shared_library/shared/shared_app_scaffold.dart';

class AppScaffold implements ScaffoldAdapter {
  final String? titleText;
  final bool? showAppBar;
  final AppItemAction<BuildContext>? floatingAction;
  final bool? useRefreshIndicator;
  final Widget? body;

  AppScaffold({
    this.titleText,
    this.showAppBar,
    this.floatingAction,
    this.useRefreshIndicator,
    this.body,
  });

  static AppScaffold admin({
    required String titleText,
    AppItemAction<BuildContext>? floatingAction,
    Future<void> Function()? onReload,
    bool? showBackground,
  }) {
    return AppScaffold(
      titleText: titleText,
      floatingAction: floatingAction,
    );
  }

  @override
  SharedAppScaffold toSharedAppScaffold() {
    return SharedAppScaffold(
      appBar: showAppBar ?? true
          ? SharedAppScaffoldAppBar(
              titleText: titleText,
            )
          : null,
      body: body,
      floatingAction: floatingAction,
      useRefreshIndicator: useRefreshIndicator,
    );
  }

  SharedAppScaffoldWidget build({Widget? body}) {
    return toSharedAppScaffold().build(body: body);
  }
}
