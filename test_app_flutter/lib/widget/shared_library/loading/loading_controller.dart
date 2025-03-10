import 'package:flutter/material.dart';

class LoadingController {
  static const String _defaultMessage = 'Loading...';
  static const String _defaultErrorMessage = 'Something went wrong.';

  String message = _defaultMessage;
  String errorMessage = _defaultErrorMessage;
  Future<void> Function()? retryAction;

  final Future<void> Function()? initialAction;
  final String? initialMessage;
  final String? initialErrorMessage;
  final Widget Function(BuildContext context)? buildMethod;

  Function()? setStateCallback;

  bool isLoading = false;
  bool isLoaded = false;
  bool hasError = false;

  LoadingController({
    this.initialAction,
    this.initialMessage,
    this.initialErrorMessage,
    this.buildMethod,
  }) {
    isLoading = initialAction != null;
  }

  Future<void> performInitialAction() async {
    if (initialAction == null) return;

    await performAction(action: initialAction!, message: initialMessage, errorMessage: initialErrorMessage);
  }

  Future<void> performAction({required Future<void> Function() action, String? message, String? errorMessage}) async {
    this.message = message ?? _defaultMessage;
    this.errorMessage = errorMessage ?? _defaultErrorMessage;

    isLoading = true;
    setStateCallback!();

    try {
      await action();
      isLoading = false;
      isLoaded = true;
      hasError = false;
      setStateCallback!();
    } on Error catch (_) {
      retryAction = () => performAction(action: action, message: message, errorMessage: errorMessage);
      isLoading = false;
      isLoaded = false;
      hasError = true;
      setStateCallback!();
    } on Exception catch (_) {
      retryAction = () => performAction(action: action, message: message, errorMessage: errorMessage);
      isLoading = false;
      isLoaded = false;
      hasError = true;
      setStateCallback!();
    }
  }
}
