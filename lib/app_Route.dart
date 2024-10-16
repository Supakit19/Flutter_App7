import 'package:flutter_application_1/screen/main2.dart';
import 'package:flutter_application_1/screen/main3.1.dart';
import 'package:flutter_application_1/screen/main4.dart';

class AppRouter {
  // Router mapkey

  static const String main1 = 'main1';
  static const String home = 'home';
  static const String main3 = 'main3';

  static get route => {
        main1: (context) => const Main1(),
        home: (context) => const Main(),
        main3: (context) => const Main3(),
      };
}
