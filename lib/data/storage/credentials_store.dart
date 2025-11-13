import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CredentialsStore {
  static const _storage = FlutterSecureStorage();
  static const _keyBaseUrl = 'komga_base_url';
  static const _keyApiKey = 'komga_api_key';
  static const _keyUsername = 'komga_username';
  static const _keyPassword = 'komga_password';

  Future<String?> getBaseUrl() => _storage.read(key: _keyBaseUrl);
  Future<String?> getApiKey() => _storage.read(key: _keyApiKey);
  Future<String?> getUsername() => _storage.read(key: _keyUsername);
  Future<String?> getPassword() => _storage.read(key: _keyPassword);

  Future<void> setBaseUrl(String? value) async {
    if (value == null || value.isEmpty) {
      await _storage.delete(key: _keyBaseUrl);
    } else {
      await _storage.write(key: _keyBaseUrl, value: value);
    }
  }

  Future<void> setApiKey(String? value) async {
    if (value == null || value.isEmpty) {
      await _storage.delete(key: _keyApiKey);
    } else {
      await _storage.write(key: _keyApiKey, value: value);
    }
  }

  Future<void> setUsername(String? value) async {
    if (value == null || value.isEmpty) {
      await _storage.delete(key: _keyUsername);
    } else {
      await _storage.write(key: _keyUsername, value: value);
    }
  }

  Future<void> setPassword(String? value) async {
    if (value == null || value.isEmpty) {
      await _storage.delete(key: _keyPassword);
    } else {
      await _storage.write(key: _keyPassword, value: value);
    }
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<bool> hasCredentials() async {
    final baseUrl = await getBaseUrl();
    if (baseUrl == null || baseUrl.isEmpty) return false;
    
    final apiKey = await getApiKey();
    if (apiKey != null && apiKey.isNotEmpty) return true;
    
    final username = await getUsername();
    final password = await getPassword();
    return username != null && username.isNotEmpty && 
           password != null && password.isNotEmpty;
  }
}

