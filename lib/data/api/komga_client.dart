import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/env.dart';

class KomgaClient {
  final Dio _dio;
  KomgaClient._(this._dio);

  factory KomgaClient() {
    final dio = Dio(BaseOptions(
      baseUrl: Env.baseUrl,
      followRedirects: true,
      headers: {
        if (Env.apiKey.isNotEmpty) 'X-API-Key': Env.apiKey,
      },
    ));
    if (Env.apiKey.isEmpty) {
      final basic = '${Env.username}:${Env.password}';
      final token = base64Encode(utf8.encode(basic));
      dio.options.headers['Authorization'] = 'Basic $token';
    }
    return KomgaClient._(dio);
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
}
