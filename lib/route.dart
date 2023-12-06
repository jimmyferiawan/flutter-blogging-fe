import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/edit_profile_screen.dart';
import 'package:flutter_application_1/pages/login_screen.dart';
import 'package:flutter_application_1/pages/signup_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _key = GlobalKey<NavigatorState>();

final router = Provider<GoRouter>((ref) {
    return GoRouter(
        navigatorKey: _key,
        initialLocation: '/',
        routes: <RouteBase>[
            GoRoute(
                path: '/',
                builder: (BuildContext context, GoRouterState state) => const LoginScreen(),   
            ),
            GoRoute(
                path: '/profile/edit',
                builder: (context, state) => const EditProfileScreen(),
            ),
            GoRoute(
                path: '/signup',
                builder: (context, state) => const SignupScreen(),
            ),
        ],
        redirect: (context, state) {
            debugPrint("current path: ${state.fullPath}");
            return null;
        },
    );
});