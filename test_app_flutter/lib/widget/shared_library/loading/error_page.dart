import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String message;
  final Function() retryCallback;
  final bool isInner;

  const ErrorPage({super.key, required this.message, required this.retryCallback, required this.isInner});

  @override
  Widget build(BuildContext context) {
    return isInner
        ? _content()
        : Scaffold(
            body: Center(
              child: _content(),
            ),
          );
  }

  Widget _content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message),
        SizedBox(height: 8),
        OutlinedButton(onPressed: retryCallback, child: Text('Retry')),
      ],
    );
  }
}
