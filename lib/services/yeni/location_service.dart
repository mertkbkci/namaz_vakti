

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:namaz_vakti/model/yeni/countries_model.dart';
import 'package:namaz_vakti/model/yeni/prayers_time_model.dart';

class LocationService {
  static const String _baseUrl = "https://vakit.vercel.app/api";

  static Future<List<CountriesModel>> fetchCountries() async {
    final response = await http.get(Uri.parse("$_baseUrl/countries"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => CountriesModel.fromJson(item)).toList();
    } else {
      throw Exception('Ülkeler yüklenemedi');
    }
  }

  static Future<List<String>> fetchRegions(String country) async {
    final response = await http.get(Uri.parse("$_baseUrl/regions?country=$country"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Bölgeler yüklenemedi');
    }
  }

  static Future<List<String>> fetchCities(String country, String region) async {
    final response = await http.get(Uri.parse("$_baseUrl/cities?country=$country&region=$region"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Şehirler yüklenemedi');
    }
  }
static Future<Map<String, dynamic>> fetchCoordinates(String country, String region, String city) async {
  final url = Uri.parse('https://vakit.vercel.app/api/coordinates?country=$country&region=$region&city=$city');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print('Coordinate API Response: $data');

    if (data['latitude'] == null || data['longitude'] == null) {
      throw Exception('Koordinatlar eksik');
    }

    return {
      'lat': double.parse(data['latitude'].toString()),
      'lng': double.parse(data['longitude'].toString()),
    };
  } else {
    throw Exception('Koordinatlar alınamadı');
  }
}




  static Future<int> fetchPlaceId(String country, String region, String city) async {
    final coords = await fetchCoordinates(country, region, city);
    final lat = coords['lat'];
    final lng = coords['lng'];

    final url = Uri.parse("$_baseUrl/place?lat=$lat&lng=$lng");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['id'];
    } else {
      throw Exception('Place ID alınamadı');
    }
  }

static Future<PrayersTimeModel> fetchPrayerTimesByCoordinates(double lat, double lng) async {
  final now = DateTime.now();
  final formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  
  final url = Uri.parse(
    "https://vakit.vercel.app/api/timesForGPS?lat=$lat&lng=$lng&date=$formattedDate&days=1&timezoneOffset=180&calculationMethod=Turkey&lang=tr",
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return PrayersTimeModel.fromJson(data);
  } else {
    throw Exception('Namaz vakitleri alınamadı');
  }
}

static Future<PrayersTimeModel> fetchMonthlyPrayerTimes({
  required double lat,
  required double lng,
  required int year,
  required int month,
}) async {
  final String formattedDate = "$year-${month.toString().padLeft(2, '0')}-01";
  final url = Uri.parse(
      'https://vakit.vercel.app/api/timesForGPS?lat=$lat&lng=$lng&date=$formattedDate&days=30&timezoneOffset=180&calculationMethod=Turkey&lang=tr');

  final response = await http.get(url);
  print('Monthly Prayer URL: $url');
  print('Monthly Prayer Response: ${response.body}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return PrayersTimeModel.fromJson(data);
  } else {
    throw Exception('İmsakiye verisi alınamadı');
  }
}





}

