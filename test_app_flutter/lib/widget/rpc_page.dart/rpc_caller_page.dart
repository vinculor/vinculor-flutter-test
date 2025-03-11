import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:test_app_flutter/widget/controller/app_controller.dart';
import 'package:test_app_flutter/widget/main/app_scaffold.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_action.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_button.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_label.dart';

class RpcCallerPage extends StatefulWidget {
  const RpcCallerPage({super.key});

  @override
  State<RpcCallerPage> createState() => _RpcCallerPageState();
}

class _RpcCallerPageState extends State<RpcCallerPage> {
  late final _appController = GetIt.instance<AppController>();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      titleText: 'RPC Caller',
      body: _body(),
    ).build();
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          AppButton(
            action: AppItemAction(
              label: AppLabel(text: 'Execute RPC Call'),
              onPressed: (context) async {
                await _appController.executeRpcCall();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ).build(),
        ],
      ),
    );
  }
}
