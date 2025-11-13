import 'package:isar/isar.dart';
part 'settings.g.dart';

@collection
class SettingsEntity {
  // Single row, always id = 0
  Id id = 0;

  /// If true, only stream pages when on Wi-Fi; offline or cached pages still show.
  bool wifiOnlyStreaming;

  /// Prefetch next page while reading.
  bool prefetchNextPage;

  /// 0 = fit-contain, 1 = fit-width, 2 = fit-height
  int fitMode;

  /// Tap left/right edge to turn pages.
  bool tapZones;

  /// Theme mode: 0 = light, 1 = dark, 2 = system
  int themeMode;

  SettingsEntity({
    this.wifiOnlyStreaming = true,
    this.prefetchNextPage = true,
    this.fitMode = 1, // default: fit-width feels best for comics
    this.tapZones = true,
    this.themeMode = 2, // default: system
  });
}
