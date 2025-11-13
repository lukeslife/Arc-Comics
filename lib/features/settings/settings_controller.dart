import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repos/settings_repo.dart';
import '../../domain/models/settings.dart';

final settingsRepoProvider = Provider((_) => SettingsRepo());

final settingsProvider =
    AsyncNotifierProvider<SettingsController, SettingsEntity>(
  SettingsController.new,
);

class SettingsController extends AsyncNotifier<SettingsEntity> {
  @override
  Future<SettingsEntity> build() async {
    return await ref.read(settingsRepoProvider).load();
  }

  // NOTE: this does NOT override anything; it's just our own helper.
  Future<void> updateSettings(void Function(SettingsEntity) mutate) async {
    final current =
        state.value ?? await ref.read(settingsRepoProvider).load();
    mutate(current);
    state = AsyncValue.data(current);
    await ref.read(settingsRepoProvider).save(current);
  }
}
