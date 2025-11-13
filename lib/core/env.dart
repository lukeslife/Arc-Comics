class Env {
  /// e.g. https://demo.komga.org
  static const String baseUrl = String.fromEnvironment('KOMGA_BASE_URL', defaultValue: 'https://demo.komga.org');

  /// If you use API key auth, set this and leave username/password empty.
  static const String apiKey = String.fromEnvironment('KOMGA_API_KEY', defaultValue: '');

  /// For Basic auth (demo uses user/pass)
  static const String username = String.fromEnvironment('KOMGA_USERNAME', defaultValue: 'demo@komga.org');
  static const String password = String.fromEnvironment('KOMGA_PASSWORD', defaultValue: 'komga-demo');
}
