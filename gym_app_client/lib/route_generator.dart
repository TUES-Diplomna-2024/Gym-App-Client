import 'package:flutter/material.dart';
import 'package:gym_app_client/pages/signin_page.dart';
import 'package:gym_app_client/pages/signup_page.dart';
import 'package:gym_app_client/pages/root_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    debugPrint("Route Args: ${args.toString()}");

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const RootPage());
      case "/signin":
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case "/signup":
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String? name) {
    String route = name ?? 'nothing';
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          body: Center(
            child: Text("Error! |$route|"),
          ),
        );
      },
    );
  }
}
