import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_Route.dart';

var initialRoute;

void main() async {
  initialRoute = AppRouter.home;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: AppRouter.route,
    );
  }
}
