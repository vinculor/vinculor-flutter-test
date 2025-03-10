import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AppLabel {
  final IconData? iconData;
  final String? text;
  final Color? color;
  final EdgeInsets? padding;

  const AppLabel({
    this.iconData,
    this.text,
    this.color,
    this.padding,
  });

  Widget build() => AppLabelWidget(config: this);
}

class AppLabelWidget extends StatefulWidget {
  final AppLabel config;

  const AppLabelWidget({super.key, required this.config});

  @override
  State<AppLabelWidget> createState() => _AppLabelWidgetState();
}

class _AppLabelWidgetState extends State<AppLabelWidget> {
  AppLabel get _config => widget.config;
  int? _count;

  @override
  Widget build(BuildContext context) { 
    return _labelWithBadge();
  }

  Widget _labelWithBadge() {
    final hasCount = _count != null && _count! > 0;

    if (hasCount) {
      return Badge.count(
        count: _count!,
        backgroundColor: _config.color,
        child: _label(),
      );
    } else {
      return _labelWithPadding();
    }
  }

  Widget _labelWithPadding() {
    return Padding(
      padding: _config.padding ?? EdgeInsets.zero,
      child: _label(),
    );
  }

  Widget _label() {
    if (_config.iconData == null && _config.text == null) {
      return SizedBox(width: 24, height: 24);
    }

    if (_config.iconData == null) {
      return Text(_config.text!, style: TextStyle(color: _config.color));
    }

    if (_config.text == null) {
      return Icon(_config.iconData);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_config.iconData, color: _config.color),
          Gap(8),
          Text(_config.text!, style: TextStyle(color: _config.color)),
        ],
      ),
    );
  }
}
