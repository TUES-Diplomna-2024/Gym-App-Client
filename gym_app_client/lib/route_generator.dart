import 'package:flutter/material.dart';
import 'package:gym_app_client/pages/signin_page.dart';
import 'package:gym_app_client/pages/signup_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    debugPrint(args.toString());

    switch (settings.name) {
      case "/signin":
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case "/signup":
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return const Scaffold(
          body: Center(
            child: Text("Error!"),
          ),
        );
      },
    );
  }
}
