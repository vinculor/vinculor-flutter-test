import 'package:flutter/material.dart';
import 'package:test_app_flutter/widget/shared_library/app_page/app_page.dart';

class CustomSection extends AppPageSection {
  final Widget Function() builder;

  CustomSection({
    super.include,
    super.padding,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) => builder();
}
