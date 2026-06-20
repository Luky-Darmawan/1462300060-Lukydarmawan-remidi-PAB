import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ApiService {
  static const String baseUrl =
      'https://api.spaceflightnewsapi.net/v4/articles/?limit=20';

  /// Mengambil daftar artikel berita dari Spaceflight News API
  Future<List<Article>> fetchArticles() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        return results.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat berita (status ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }
}
