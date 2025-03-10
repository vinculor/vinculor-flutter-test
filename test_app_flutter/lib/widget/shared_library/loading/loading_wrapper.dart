import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:test_app_flutter/widget/shared_library/loading/error_page.dart';
import 'package:test_app_flutter/widget/shared_library/loading/loading_controller.dart';
import 'package:test_app_flutter/widget/shared_library/loading/loading_page.dart';

class LoadingWrapper extends StatefulWidget {
  final LoadingController controller;
  final bool isInner;

  const LoadingWrapper({super.key, required this.controller, this.isInner = false});

  @override
  State<LoadingWrapper> createState() => _LoadingWrapperState();
}

class _LoadingWrapperState extends State<LoadingWrapper> with AfterLayoutMixin<LoadingWrapper> {
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    widget.controller.setStateCallback = () {
      if (mounted) {
        setState(() {});
      }
    };
    return widget.controller.performInitialAction();
  }

  void _retry() {
    widget.controller.retryAction!();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.isLoading) {
      return LoadingPage(message: widget.controller.message, isInner: widget.isInner);
    }

    if (widget.controller.hasError) {
      return ErrorPage(message: widget.controller.errorMessage, retryCallback: _retry, isInner: widget.isInner);
    }

    if (widget.controller.buildMethod != null) {
      return widget.controller.buildMethod!(context);
    } else {
      return SizedBox();
    }
  }
}
