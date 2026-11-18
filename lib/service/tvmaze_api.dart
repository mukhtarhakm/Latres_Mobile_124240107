import 'dart:convert';

import 'package:http/http.dart' as http;

class TvMazeApi {
  Future<List<Map<String, dynamic>>> getShows() async {
    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/shows'))
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }
    return List<Map<String, dynamic>>.from(jsonDecode(response.body) as List);
  }

  Future<Map<String, dynamic>> getShow(int id) async {
    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/shows/$id'))
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }
    return Map<String, dynamic>.from(jsonDecode(response.body) as Map);
  }
}

String showRating(Map<String, dynamic> show) {
  final rating = show['rating'];
  return rating is Map ? rating['average']?.toString() ?? '-' : '-';
}

String plainSummary(String? html) => (html ?? 'Tidak ada ringkasan.')
    .replaceAll(RegExp(r'<[^>]*>'), '')
    .replaceAll('&amp;', '&')
    .replaceAll('&quot;', '"')
    .replaceAll('&#39;', "'")
    .replaceAll('&nbsp;', ' ')
    .trim();
