import 'package:flutter/material.dart';

class AppRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;

  final Widget child;
  final GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;

  const AppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.refreshIndicatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RefreshIndicator(
          key: refreshIndicatorKey,
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
