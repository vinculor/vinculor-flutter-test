import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

extension WidgetListExtension<T extends Widget> on Iterable<T> {
  List<Widget> separateWith({required Widget Function() separatorBuilder}) {
    if (isEmpty) {
      return [];
    }

    final result = <Widget>[];

    for (final widget in this) {
      result.add(widget);
      result.add(separatorBuilder());
    }
    result.removeLast();
    return result;
  }

  List<Widget> withDividers() {
    return this.separateWith(separatorBuilder: () => Divider(height: 1));
  }

  List<Widget> withGaps([double size = 8]) {
    return this.separateWith(separatorBuilder: () => Gap(size));
  }
}
