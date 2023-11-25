import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/edit_profile_screen.dart';
import 'package:flutter_application_1/pages/login_screen.dart';
import 'package:flutter_application_1/pages/profile_screen.dart';
import 'package:flutter_application_1/pages/signup_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
    initialLocation: '/',
    
    routes: <RouteBase>[
        GoRoute(
            path: '/',
            builder: (BuildContext context, GoRouterState state) => const LoginScreen(),   
        ),
        GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
            routes: <RouteBase> [
                GoRoute(
                    path: "edit",
                    builder: (context, state) => const EditProfileScreen(),
                ),
            ]
        ),
        GoRoute(
            path: '/signup',
            builder: (context, state) => const SignupScreen(),
        ),
    ]
);