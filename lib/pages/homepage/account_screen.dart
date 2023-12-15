import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/scrollable_screen.dart';
import 'package:flutter_application_1/core/helpers/month_mapper.dart';
import 'package:flutter_application_1/core/helpers/persistence_storage.dart';
import 'package:flutter_application_1/core/http_services/api_calls.dart';
import 'package:flutter_application_1/dto/auth_dto.dart';
import 'package:flutter_application_1/store/auth_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountScreen extends ConsumerWidget {
    const AccountScreen({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final accountData = ref.watch(userDataStateProvider)!;
        
        return RefreshIndicator(
            onRefresh: () async{
                UserDataResp userDataResp = await getUserData(await getJwtToken(), await getUsername());
                UserData accountData = UserData.fromJson(userDataResp.data);
                ref.read(userDataStateProvider.notifier).setData(accountData);
            },
            child: ScrollableScreen(
                children: Column(
                    children: <Widget>[
                        ProfileComponent(accountData: accountData, logoutFunction: () async{
                            debugPrint("logout");
                            await clearSession();
                            ref.read(userDataStateProvider.notifier).setData(null);
                        },)
                    ],
                )
            ), 
        );
    }
}

class ProfileComponent extends StatelessWidget {
    const ProfileComponent({
        super.key,
        required this.accountData,
        required this.logoutFunction,
    });

    final UserData accountData;
    final VoidCallback? logoutFunction;

    @override
    Widget build(BuildContext context){
        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
                const SizedBox(height: 12,),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("Username: ${accountData.username}"),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("Nama: ${accountData.firstName}"),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("Email: ${accountData.email}"),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("No. Hp: (+62) ${accountData.mobile}"),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("Intro: ${accountData.intro}"),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("Tgl. Lahir: ${datePrettier(accountData.birthdate!)}"),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text("Profile: ${accountData.profile}"),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                            Expanded(
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: Colors.blue
                                        )
                                    ),
                                    onPressed: () { 
                                        context.push("/profile/edit");
                                    }, 
                                    child: Text(
                                        "Edit Profile", 
                                        style: TextStyle(color: Colors.blue[800]),
                                    )
                                ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: Colors.red
                                        ),
                                        foregroundColor: Colors.red.shade100
                                    ),
                                    onPressed: logoutFunction, 
                                    child: Text(
                                        "Logout", 
                                        style: TextStyle(color: Colors.red[600]),
                                    )
                                )
                            )
                        ],
                    )
                ),
                const SizedBox(height: 12,),
            ],
        );
    }
}