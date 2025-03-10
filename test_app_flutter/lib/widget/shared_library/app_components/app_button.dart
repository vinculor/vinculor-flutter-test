import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_action.dart';
import 'package:test_app_flutter/widget/shared_library/app_components/app_confirmation_bottom_sheet.dart';

enum AppButtonType { primary, text, elevated, icon }

enum AppDisableMode { disabled, hidden, hiddenPreserveSpace }

class AppButton {
  final AppButtonType type;
  final AppDisableMode disableMode;
  final AppItemAction<BuildContext> action;

  const AppButton({
    this.type = AppButtonType.primary,
    this.disableMode = AppDisableMode.disabled,
    required this.action,
  });

  AppButton copyWith({
    bool Function()? additionalIsEnabled,
  }) {
    return AppButton(
      type: type,
      disableMode: disableMode,
      action: action.copyWith(additionalIsEnabled: additionalIsEnabled),
    );
  }

  AppButtonWidget build() => AppButtonWidget(config: this);
}

class AppButtonWidget extends StatefulWidget {
  final AppButton config;

  const AppButtonWidget({super.key, required this.config});

  @override
  State<AppButtonWidget> createState() => _AppButtonWidgetState();
}

class _AppButtonWidgetState extends State<AppButtonWidget> {
  AppButton get _config => widget.config;

  Future<void> _onPressed() async {
    if (_config.action.isBlocking) {
      await showAppModalBottomSheet(context, _config.action.toAppAction(context));
    } else {
      await _config.action.onPressed(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_config.disableMode) {
      case AppDisableMode.disabled:
        return _button();
      case AppDisableMode.hidden:
        return SizedBox();
      case AppDisableMode.hiddenPreserveSpace:
        return Visibility(
          maintainState: true,
          maintainAnimation: true,
          maintainSize: true,
          child: _button(),
        );
    }
  }

  Widget _button() {
    switch (_config.type) {
      case AppButtonType.primary:
        return FilledButton(
          onPressed: _onPressed,
          onLongPress: _config.action.toAppAction(context).onLongPressed,
          child: _config.action.label.build(),
        );
      case AppButtonType.text:
        return TextButton(
          onPressed: _onPressed,
          onLongPress: _config.action.toAppAction(context).onLongPressed,
          child: _config.action.label.build(),
        );
      case AppButtonType.elevated:
        return ElevatedButton(
          onPressed: _onPressed,
          onLongPress: _config.action.toAppAction(context).onLongPressed,
          child: _config.action.label.build(),
        );
      case AppButtonType.icon:
        return IconButton(
          onPressed: _onPressed,
          icon: _config.action.label.build(),
        );
    }
  }
}
