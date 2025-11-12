import 'package:flutter/material.dart';
import 'routing/app_router.dart';
import 'core/theme.dart';

class ArcComicsApp extends StatelessWidget {
  const ArcComicsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Arc Comics',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
