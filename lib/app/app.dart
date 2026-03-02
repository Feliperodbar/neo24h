import 'package:flutter/material.dart';

import 'router.dart';

class Neo24hApp extends StatelessWidget {
  const Neo24hApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = appRouter;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Neo24h',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      ),
      routerConfig: router,
    );
  }
}
