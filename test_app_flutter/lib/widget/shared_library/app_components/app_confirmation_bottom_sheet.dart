import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_action.dart';

Future<void> showAppModalBottomSheet(BuildContext context, AppAction appAction) async {
  await showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isDismissible: false,
    builder: (context) => BottomSheet(
      onClosing: () {},
      builder: (_) => _buildAppModalBottomSheet(context, appAction: appAction),
    ),
  );
}

Widget _buildAppModalBottomSheet(BuildContext context, {required AppAction appAction}) {
  return AppConfirmationBottomSheetContent(appAction: appAction);
}

class AppConfirmationBottomSheetContent extends StatefulWidget {
  final AppAction appAction;

  const AppConfirmationBottomSheetContent({super.key, required this.appAction});

  @override
  State<AppConfirmationBottomSheetContent> createState() => _AppConfirmationBottomSheetContentState();
}

class _AppConfirmationBottomSheetContentState extends State<AppConfirmationBottomSheetContent> with AfterLayoutMixin<AppConfirmationBottomSheetContent> {
  late bool _isLoading = widget.appAction.confirmation == null;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    if (widget.appAction.confirmation == null) {
      _onConfirmedPressed();
    }
  }

  Future<void> _onConfirmedPressed() async {
    setState(() {
      _isLoading = true;
    });

    await _executeAction();

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _executeAction() async {
    await widget.appAction.onPressed();
    await widget.appAction.onCompleted?.call();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return _loadingContent();
  }

  Widget _loadingContent() {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedOpacity(
            opacity: _isLoading ? 1 : 0,
            duration: Duration(milliseconds: 200),
            child: Center(
                child: CircularProgressIndicator(
              strokeWidth: 10,
            )),
          ),
        ),
        AnimatedOpacity(
          opacity: _isLoading ? 0 : 1,
          duration: Duration(milliseconds: 200),
          child: _content(),
        ),
      ],
    );
  }

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.appAction.confirmation?.titleText != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.appAction.confirmation!.titleText, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          if (widget.appAction.confirmation?.subtitleText != null) Gap(8),
          if (widget.appAction.confirmation?.subtitleText != null) Text(widget.appAction.confirmation!.subtitleText!),
          Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              FilledButton(
                onPressed: _onConfirmedPressed,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Text('Yes'),
                ),
              )
            ],
          ),
          Gap(16),
        ],
      ),
    );
  }
}
