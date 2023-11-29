import 'package:flutter/material.dart';
// import 'package:flutter_application_1/pages/login_screen.dart';
import 'package:flutter_application_1/route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//     const MyApp({super.key});

//     @override
//     Widget build(BuildContext context) {
//         // const appTitle = 'Login';

//         return MaterialApp.router(
//             routerConfig: router,
//         );

//     }
// }

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends ConsumerWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        // const appTitle = 'Login';
        final appRouter = ref.watch(router);

        return MaterialApp.router(
            routerConfig: appRouter,
        );

    }
}
