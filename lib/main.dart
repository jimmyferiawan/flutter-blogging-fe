import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/http_services/api_calls.dart';
import 'package:flutter_application_1/dto/auth_dto.dart';
import 'package:flutter_application_1/pages/splash_screen.dart';
import 'package:flutter_application_1/route.dart';
import 'package:flutter_application_1/store/auth_store.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatefulHookConsumerWidget {
    const MainApp({super.key});

    @override
    ConsumerState<ConsumerStatefulWidget> createState() => _MainAppState();
}
class _MainAppState extends ConsumerState<MainApp> {
    late Future<UserData?> _userDataResp;

    @override
    void initState() {
        super.initState();
        _userDataResp = initUserAccount();
    }

    @override
    Widget build(BuildContext context) {
        final appRouter = ref.watch(router);
        
        return FutureBuilder(
            future: _userDataResp, 
            builder: (context, snapshot) {
                // debugPrint(snapshot.data.toString());
                if(snapshot.hasData) {
                    Future(() => ref.read(userDataStateProvider.notifier).setData(snapshot.data));
                    return MaterialApp.router(routerConfig: appRouter);
                } else if(snapshot.hasError) {
                    return MaterialApp.router(routerConfig: appRouter);
                }
                
                return const SplashScreen();
            },
        );
    }
}