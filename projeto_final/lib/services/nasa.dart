import 'dart:convert';
import 'package:http/http.dart' as http;

class NasaService {
  static const String _apiKey = 'API_KEY';
  static const String _baseUrl = 'https://api.nasa.gov/planetary/apod';

  Future<Map<String, dynamic>> fetchPicture(String date) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?api_key=$_apiKey&date=$date'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }
}