import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/helpers/persistence_storage.dart';
import 'package:flutter_application_1/route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    String jwt = await getJwtToken();
    String username = await getUsername();
    bool isSession = jwt != "" && username != "";

    runApp(ProviderScope(child: MyApp(isLoggedIn: isSession)));
}

class MyApp extends ConsumerWidget {
    final bool isLoggedIn;
    const MyApp({super.key, required this.isLoggedIn});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final appRouter = ref.watch(router);

        if(isLoggedIn) {
            appRouter.go("/profile");
        }
        
        return MaterialApp.router(
            routerConfig: appRouter,
        );

    }
}
