import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routing/app_router.dart';
import 'core/theme.dart';
import 'features/settings/settings_controller.dart';

class ArcComicsApp extends ConsumerWidget {
  const ArcComicsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    
    return MaterialApp.router(
      title: 'Arc Comics',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settingsAsync.when(
        data: (settings) {
          switch (settings.themeMode) {
            case 0:
              return ThemeMode.light;
            case 1:
              return ThemeMode.dark;
            case 2:
            default:
              return ThemeMode.system;
          }
        },
        loading: () => ThemeMode.system,
        error: (_, __) => ThemeMode.system,
      ),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
