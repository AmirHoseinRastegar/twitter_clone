import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/feature/auth/view/login_view.dart';
import 'package:twitter_clone/feature/home/view/home_screen.dart';

import 'feature/auth/controller/auth_controller.dart';
import 'theme/theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: AppTheme.theme,
        home: ref.watch(futureSessionProvider).when(data: (user) {
          if (user != null) {
            return const HomeView();
          }
          return const LoginView();
        }, error: (error, str) {
          return ErrorLandingPage(errorMessage: error.toString());
        }, loading: () {
          return const LoadingScreen();
        }));
  }
}
