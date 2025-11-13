import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (s) => ListView(
          children: [
            SwitchListTile(
              title: const Text('Wi-Fi only streaming'),
              subtitle: const Text('Block online page loads on cellular'),
              value: s.wifiOnlyStreaming,
              onChanged: (v) => ref.read(settingsProvider.notifier)
                                   .updateSettings((x) => x.wifiOnlyStreaming = v),
            ),
            SwitchListTile(
              title: const Text('Prefetch next page'),
              value: s.prefetchNextPage,
              onChanged: (v) => ref.read(settingsProvider.notifier)
                                   .updateSettings((x) => x.prefetchNextPage = v),
            ),
            ListTile(
              title: const Text('Fit mode'),
              subtitle: const Text('How pages are sized on screen'),
              trailing: SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, label: Text('Contain')),
                  ButtonSegment(value: 1, label: Text('Width')),
                  ButtonSegment(value: 2, label: Text('Height')),
                ],
                selected: {s.fitMode},
                onSelectionChanged: (set) => ref.read(settingsProvider.notifier)
                                                  .updateSettings((x) => x.fitMode = set.first),
              ),
            ),
            SwitchListTile(
              title: const Text('Tap zones to turn pages'),
              value: s.tapZones,
              onChanged: (v) => ref.read(settingsProvider.notifier)
                                   .updateSettings((x) => x.tapZones = v),
            ),
          ],
        ),
      ),
    );
  }
}
