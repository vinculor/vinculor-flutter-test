import 'package:test_app_flutter/widget/shared_library/app_components/app_label.dart';

class AppActionConfirmation {
  final String titleText;
  final String? subtitleText;

  const AppActionConfirmation({
    required this.titleText,
    this.subtitleText,
  });
}

abstract class AppActionBase {
  final AppLabel label;
  final AppActionConfirmation? confirmation;
  final bool Function()? isEnabled;
  final bool isBlocking;

  bool get isEnabledValue => isEnabled?.call() ?? true;

  const AppActionBase({
    required this.label,
    this.confirmation,
    this.isEnabled,
    this.isBlocking = true,
  });
}

class AppAction extends AppActionBase {
  final Future<void> Function() onPressed;
  final Future<void> Function()? onLongPressed;
  final Future<void> Function()? onCompleted;

  const AppAction({
    required super.label,
    required this.onPressed,
    this.onLongPressed,
    super.confirmation,
    super.isEnabled,
    super.isBlocking = true,
    this.onCompleted,
  });

  AppAction copyWith({
    bool Function()? additionalIsEnabled,
    Future<void> Function()? additionalOnCompleted,
  }) {
    return AppAction(
        label: label,
        confirmation: confirmation,
        isEnabled: () => (additionalIsEnabled?.call() ?? true) && (isEnabled?.call() ?? true),
        onPressed: onPressed,
        onLongPressed: onLongPressed,
        onCompleted: () async {
          await onCompleted?.call();
          await additionalOnCompleted?.call();
        },
        isBlocking: isBlocking);
  }
}

class AppItemAction<T> extends AppActionBase {
  final Future<void> Function(T item) onPressed;
  final Future<void> Function(T item)? onLongPressed;
  final Future<void> Function(T item)? onCompleted;

  const AppItemAction({
    required super.label,
    required this.onPressed,
    this.onLongPressed,
    super.confirmation,
    super.isEnabled,
    super.isBlocking = true,
    this.onCompleted,
  });

  AppItemAction<T> copyWith({
    bool Function()? additionalIsEnabled,
    Future<void> Function()? additionalOnCompleted,
  }) {
    return AppItemAction<T>(
      label: label,
      confirmation: confirmation,
      isEnabled: () => (additionalIsEnabled?.call() ?? true) && (isEnabled?.call() ?? true),
      onPressed: onPressed,
      onLongPressed: onLongPressed,
      onCompleted: onCompleted,
      isBlocking: isBlocking,
    );
  }

  AppAction toAppAction(T item) => AppAction(
        label: label,
        confirmation: confirmation,
        isEnabled: isEnabled,
        onPressed: () => onPressed(item),
        onLongPressed: onLongPressed != null ? () => onLongPressed!(item) : null,
        onCompleted: onCompleted != null ? () => onCompleted!(item) : null,
      );
}
