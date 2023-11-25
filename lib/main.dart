import 'package:flutter/material.dart';
// import 'package:flutter_application_1/pages/login_screen.dart';
import 'package:flutter_application_1/route.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        // const appTitle = 'Login';

        return MaterialApp.router(
            routerConfig: router,
        );

    }
}
