import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:gym_app_client/db_api/services/token_service.dart';
import 'package:gym_app_client/route_generator.dart';

class CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = CustomHttpOverrides();

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (FlutterErrorDetails errorDetails) {
      debugPrint("An exception occurred: ${errorDetails.exception.toString()}");
    };

    await GlobalConfiguration().loadFromAsset("app_settings");

    runApp(const MyApp());
  }, (error, stackTrace) {
    debugPrint("An error occurred ${error.toString()}");
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> _getInitialRoute() async {
    final isCurrUserLoggedIn = await TokenService().isCurrUserLoggedIn();
    return isCurrUserLoggedIn ? "/" : "/welcome";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blue),
            onGenerateRoute: RouteGenerator.generateRoute,
            initialRoute: snapshot.data ?? "/welcome",
          );
        }
      },
    );
  }
}
