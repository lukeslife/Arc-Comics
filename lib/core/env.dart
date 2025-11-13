import '../data/storage/credentials_store.dart';

class Env {
  static final _credentialsStore = CredentialsStore();

  /// Load base URL from secure storage, fallback to compile-time constant
  static Future<String> get baseUrl async {
    final stored = await _credentialsStore.getBaseUrl();
    if (stored != null && stored.isNotEmpty) {
      return stored;
    }
    return const String.fromEnvironment('KOMGA_BASE_URL', defaultValue: 'https://demo.komga.org');
  }

  /// Load API key from secure storage, fallback to compile-time constant
  static Future<String> get apiKey async {
    final stored = await _credentialsStore.getApiKey();
    if (stored != null && stored.isNotEmpty) {
      return stored;
    }
    return const String.fromEnvironment('KOMGA_API_KEY', defaultValue: '');
  }

  /// Load username from secure storage, fallback to compile-time constant
  static Future<String> get username async {
    final stored = await _credentialsStore.getUsername();
    if (stored != null && stored.isNotEmpty) {
      return stored;
    }
    return const String.fromEnvironment('KOMGA_USERNAME', defaultValue: 'demo@komga.org');
  }

  /// Load password from secure storage, fallback to compile-time constant
  static Future<String> get password async {
    final stored = await _credentialsStore.getPassword();
    if (stored != null && stored.isNotEmpty) {
      return stored;
    }
    return const String.fromEnvironment('KOMGA_PASSWORD', defaultValue: 'komga-demo');
  }

  static CredentialsStore get credentialsStore => _credentialsStore;
}
