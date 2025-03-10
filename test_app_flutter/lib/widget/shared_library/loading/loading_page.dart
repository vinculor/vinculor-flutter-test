import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  final String message;
  final bool isInner;

  const LoadingPage({super.key, required this.message, this.isInner = false});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with AfterLayoutMixin<LoadingPage> {
  bool _isVisible = false;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    _isVisible = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isInner) return _content();

    return Scaffold(body: _content());
  }

  Widget _content() {
    return Center(
      child: AnimatedOpacity(
        opacity: _isVisible ? 1 : 0,
        duration: Duration(milliseconds: 500),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text(widget.message),
          ],
        ),
      ),
    );
  }
}
