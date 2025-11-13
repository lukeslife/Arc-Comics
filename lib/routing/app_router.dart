import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/library/library_screen.dart';
import '../features/reader/reader_screen.dart';
import '../features/library/series_books_screen.dart';
import '../features/settings/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/library', builder: (_, __) => const LibraryScreen()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    GoRoute(
      path: '/series/:seriesId',
      builder: (_, state) => SeriesBooksScreen(seriesKomgaId: state.pathParameters['seriesId']!),
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
