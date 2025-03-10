import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:test_app_flutter/widget/controller/app_controller.dart';
import 'package:test_app_flutter/widget/main/landing_page.dart';

void main() {
  final getIt = GetIt.instance;
  getIt.registerSingleton(AppController());

  runApp(const VinculorTestApp());
}

class VinculorTestApp extends StatelessWidget {
  const VinculorTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vinculor Flutter Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: LandingPage(),
    );
  }
}
