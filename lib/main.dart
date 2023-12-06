import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/helpers/persistence_storage.dart';
import 'package:flutter_application_1/core/http_services/api_calls.dart';
import 'package:flutter_application_1/dto/auth_dto.dart';
import 'package:flutter_application_1/route.dart';
import 'package:flutter_application_1/store/auth_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    String jwt = await getJwtToken();
    String username = await getUsername();
    bool isSession = jwt != "" && username != "";
    UserDataResp userDataResp = !isSession ? UserDataResp.emptyValue() : await getUserData(jwt, username);
    UserData? userData = userDataResp.error ? null : UserData.fromJson(userDataResp.data);

    runApp(ProviderScope(child: MyApp(isLoggedIn: isSession, userData: userData,)));
}

class MyApp extends ConsumerWidget {
    final bool isLoggedIn;
    final UserData? userData;
    const MyApp({super.key, required this.isLoggedIn, required this.userData});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final appRouter = ref.watch(router);

        if(isLoggedIn && (userData != null)) {
            Future(() {
               ref.read(userDataStateProvider.notifier).setData(userData); 
            });
        }
        
        return MaterialApp.router(
            routerConfig: appRouter,
        );

    }
}
