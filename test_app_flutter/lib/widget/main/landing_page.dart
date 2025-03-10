import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:test_app_flutter/widget/rpc_page.dart/rpc_page.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_bottom_navigation_switcher.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_label.dart';
import 'package:test_app_flutter/widget/controller/app_controller.dart';
import 'package:test_app_flutter/widget/todo_editor/todo_editor_page.dart';
import 'package:test_app_flutter/widget/shared_library/loading/loading_controller.dart';
import 'package:test_app_flutter/widget/shared_library/loading/loading_wrapper.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late final _loadingController = LoadingController(buildMethod: _page, initialAction: _load);
  late final _appController = GetIt.instance<AppController>();

  Future<void> _load() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWrapper(controller: _loadingController);
  }

  Widget _page(BuildContext context) {
    return AppBottomNavigationSwitcherConfig(
      emitter: _appController.appStateEmitter,
      pages: [
        AppBottomNavigationSwitcherPageConfig(
          value: AppState.todoEditor,
          label: AppLabel(text: 'TODO Editor', iconData: Icons.check_box_outlined),
          pageBuilder: () => TodoEditorPage(),
        ),
        AppBottomNavigationSwitcherPageConfig(
          value: AppState.exercise2,
          label: AppLabel(text: 'RPC', iconData: Icons.computer),
          pageBuilder: () => RpcPage(),
        ),
      ],
    ).build();
  }
}
