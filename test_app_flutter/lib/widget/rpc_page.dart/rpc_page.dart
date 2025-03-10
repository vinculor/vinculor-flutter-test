import 'package:flutter/material.dart';
import 'package:test_app_flutter/widget/main/app_scaffold.dart';
import 'package:test_app_flutter/widget/rpc_page.dart/rpc_caller_page.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_action.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_button.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_label.dart';

class RpcPage extends StatefulWidget {
  const RpcPage({super.key});

  @override
  State<RpcPage> createState() => _RpcPageState();
}

class _RpcPageState extends State<RpcPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      titleText: 'RPC',
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
              label: AppLabel(text: 'Open RPC Caller'),
              onPressed: (_) async {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => RpcCallerPage()));
              },
              isBlocking: false,
            ),
          ).build(),
        ],
      ),
    );
  }
}
