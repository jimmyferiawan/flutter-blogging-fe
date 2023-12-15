import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/homepage/account_screen.dart';
import 'package:flutter_application_1/pages/homepage/login_screen.dart';
import 'package:flutter_application_1/store/auth_store.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Indexcreen extends ConsumerWidget {
    const Indexcreen({super.key});

    @override
    Widget build(BuildContext context, ref) {
        final isLogin = ref.watch(userDataStateProvider);

        return Scaffold(
            appBar: AppBar(
                title: Text(isLogin == null ? "Login" : "Account"),
            ),
            // body: const _MyCustomForm(),
            body: isLogin == null ? const LoginForm() : const AccountScreen(),
        );
    }
}