import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../library/library_screen.dart';
import 'widgets/continue_reading_module.dart';
import 'widgets/recently_added_module.dart';
import 'widgets/publisher_shelves_module.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arc Comics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.library_books),
            onPressed: () => context.push('/library'),
            tooltip: 'Library',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContinueReadingModule(),
            RecentlyAddedModule(),
            PublisherShelvesModule(),
          ],
        ),
      ),
    );
  }
}

