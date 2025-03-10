import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CenteredInfo extends StatelessWidget {
  final String titleText;
  final String bodyText;

  const CenteredInfo({
    super.key,
    required this.titleText,
    required this.bodyText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64),
        child: Column(children: [
          Text(
            titleText,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8)),
          ),
          Gap(16),
          Text(
            bodyText,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
          ),
        ]),
      ),
    );
  }
}
