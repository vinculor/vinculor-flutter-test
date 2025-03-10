import 'package:flutter/material.dart';
import 'package:test_app_flutter/emitter/emitter.dart';
import 'package:test_app_flutter/widget/shared_library/app_page/app_page.dart';

class CardSection<T> extends AppPageSection {
  final ReadableEmitter<T?> emitter;
  final List<Widget> Function(T item) tileBuilder;

  CardSection({
    super.include,
    super.padding,
    required this.emitter,
    required this.tileBuilder,
  });

  @override
  Widget build(BuildContext context) => CardSectionWidget<T>(config: this);
}

class CardSectionWidget<T> extends StatefulWidget {
  final CardSection<T> config;

  const CardSectionWidget({super.key, required this.config});

  @override
  State<CardSectionWidget> createState() => _CardSectionWidgetState<T>();
}

class _CardSectionWidgetState<T> extends State<CardSectionWidget<T>> {
  T get data => widget.config.emitter.value!;

  @override
  Widget build(BuildContext context) {
    final tileWidgets = widget.config.tileBuilder(data);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tileWidgets,
      ),
    );
  }
}
