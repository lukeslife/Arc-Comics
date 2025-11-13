import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/home/home_screen.dart';
import '../features/library/library_screen.dart';
import '../features/reader/reader_screen.dart';
import '../features/library/series_detail_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/downloads/downloads_screen.dart';
import '../features/library/search_screen.dart';
import '../data/storage/credentials_store.dart';

final _credentialsStore = CredentialsStore();

final appRouter = GoRouter(
  initialLocation: '/onboarding',
  redirect: (context, state) async {
    final hasCredentials = await _credentialsStore.hasCredentials();
    final isOnboarding = state.uri.path == '/onboarding';
    
    if (!hasCredentials && !isOnboarding) {
      return '/onboarding';
    }
    
    // Redirect from /library to /home if credentials exist
    if (hasCredentials && state.uri.path == '/library') {
      return '/home';
    }
    
    return null;
  },
  routes: [
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/library', builder: (_, __) => const LibraryScreen()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    GoRoute(path: '/downloads', builder: (_, __) => const DownloadsScreen()),
    GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
    GoRoute(
      path: '/series/:seriesId',
      builder: (_, state) => SeriesDetailScreen(seriesKomgaId: state.pathParameters['seriesId']!),
    ),
    GoRoute(
      path: '/reader/:bookId',
      builder: (_, state) {
        final bookId = state.pathParameters['bookId']!;
        final count = int.tryParse(state.uri.queryParameters['count'] ?? '');
        final title = state.uri.queryParameters['title'];
        return ReaderScreen(
          bookKomgaId: bookId,
          initialPageCount: count,
          title: title ?? 'Reader',
        );
      },
    ),
  ],
);
