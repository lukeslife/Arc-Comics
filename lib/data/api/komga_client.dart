import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/env.dart';

class KomgaClient {
  final Dio _dio;
  KomgaClient._(this._dio);

  /// Create a KomgaClient with explicit credentials
  factory KomgaClient.withCredentials({
    required String baseUrl,
    String? apiKey,
    String? username,
    String? password,
  }) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      followRedirects: true,
      headers: {
        if (apiKey != null && apiKey.isNotEmpty) 'X-API-Key': apiKey,
      },
    ));
    if ((apiKey == null || apiKey.isEmpty) && username != null && password != null) {
      final basic = '$username:$password';
      final token = base64Encode(utf8.encode(basic));
      dio.options.headers['Authorization'] = 'Basic $token';
    }
    return KomgaClient._(dio);
  }

  /// Create a KomgaClient using stored credentials (async)
  static Future<KomgaClient> create() async {
    final baseUrl = await Env.baseUrl;
    final apiKey = await Env.apiKey;
    final username = await Env.username;
    final password = await Env.password;
    
    return KomgaClient.withCredentials(
      baseUrl: baseUrl,
      apiKey: apiKey.isNotEmpty ? apiKey : null,
      username: username.isNotEmpty ? username : null,
      password: password.isNotEmpty ? password : null,
    );
  }

  /// Legacy factory for backward compatibility (uses compile-time constants)
  factory KomgaClient() {
    // This is deprecated - use create() or withCredentials() instead
    final dio = Dio(BaseOptions(
      baseUrl: const String.fromEnvironment('KOMGA_BASE_URL', defaultValue: 'https://demo.komga.org'),
      followRedirects: true,
      headers: {
        if (const String.fromEnvironment('KOMGA_API_KEY', defaultValue: '').isNotEmpty) 
          'X-API-Key': const String.fromEnvironment('KOMGA_API_KEY', defaultValue: ''),
      },
    ));
    final apiKey = const String.fromEnvironment('KOMGA_API_KEY', defaultValue: '');
    if (apiKey.isEmpty) {
      final username = const String.fromEnvironment('KOMGA_USERNAME', defaultValue: 'demo@komga.org');
      final password = const String.fromEnvironment('KOMGA_PASSWORD', defaultValue: 'komga-demo');
      final basic = '$username:$password';
      final token = base64Encode(utf8.encode(basic));
      dio.options.headers['Authorization'] = 'Basic $token';
    }
    return KomgaClient._(dio);
  }

  /// Test connection to the server
  Future<bool> testConnection() async {
    try {
      // Try to fetch user info or series list to verify connection
      await _dio.get('/api/v1/series', queryParameters: {'page': 0, 'size': 1});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> listSeries({int page = 0, int size = 50}) async {
    final res = await _dio.get('/api/v1/series', queryParameters: {'page': page, 'size': size});
    return (res.data['content'] as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> listBooks(String seriesId,
      {int page = 0, int size = 100}) async {
    final res = await _dio.get('/api/v1/series/$seriesId/books',
        queryParameters: {'page': page, 'size': size});
    return (res.data['content'] as List).cast<Map<String, dynamic>>();
  }

  /// Fetch a single page image bytes.
  Future<Response<List<int>>> fetchPageBytes(String bookId, int oneBasedPage) {
    return _dio.get<List<int>>(
      '/api/v1/books/$bookId/pages/$oneBasedPage',
      options: Options(responseType: ResponseType.bytes),
    );
  }

  /// Returns page descriptors list (use length for pageCount)
  Future<List<dynamic>> listPages(String bookId) async {
    final res = await _dio.get('/api/v1/books/$bookId/pages');
    // Some Komga builds return { "pages": [...] }, most return a list directly
    final data = res.data;
    if (data is List) return data;
    if (data is Map && data['pages'] is List) return data['pages'] as List;
    return const [];
  }

  /// Get a single series by ID with full metadata
  Future<Map<String, dynamic>> getSeries(String seriesId) async {
    final res = await _dio.get('/api/v1/series/$seriesId');
    return res.data as Map<String, dynamic>;
  }

  /// Get a single book by ID with full metadata
  Future<Map<String, dynamic>> getBook(String bookId) async {
    final res = await _dio.get('/api/v1/books/$bookId');
    return res.data as Map<String, dynamic>;
  }

  /// Update reading progress for a book
  /// pageNumber is 1-based (Komga uses 1-based indexing)
  Future<void> updateReadingProgress(String bookId, int pageNumber) async {
    try {
      await _dio.put(
        '/api/v1/books/$bookId/read-progress',
        data: {'page': pageNumber},
      );
    } catch (e) {
      // Silently fail if progress sync is not supported
      // This allows the app to work with older Komga versions
    }
  }

  /// Get reading progress for a book
  Future<Map<String, dynamic>?> getReadingProgress(String bookId) async {
    try {
      final res = await _dio.get('/api/v1/books/$bookId/read-progress');
      return res.data as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  /// Fetch thumbnail image bytes for a series
  Future<Response<List<int>>> fetchSeriesThumbnail(String seriesId) async {
    return _dio.get<List<int>>(
      '/api/v1/series/$seriesId/thumbnail',
      options: Options(responseType: ResponseType.bytes),
    );
  }

  /// Fetch thumbnail image bytes for a book
  Future<Response<List<int>>> fetchBookThumbnail(String bookId) async {
    return _dio.get<List<int>>(
      '/api/v1/books/$bookId/thumbnail',
      options: Options(responseType: ResponseType.bytes),
    );
  }
}
