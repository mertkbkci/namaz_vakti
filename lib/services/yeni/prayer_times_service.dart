// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:namaz_vakti/model/yeni/prayers_time_model.dart';


// class PrayerTimesService {
//   static const String _baseUrl = "https://vakit.vercel.app/api";

//   static Future<PrayersTimeModel> fetchPrayerTimes({
//     required int placeId,
//     required String date,
//     int days = 1,
//     int timezoneOffset = 180, // Türkiye için 180 (UTC+3)
//     String calculationMethod = "Turkey",
//   }) async {
//     final url = Uri.parse(
//       "$_baseUrl/timesForPlace?id=$placeId&date=$date&days=$days&timezoneOffset=$timezoneOffset&calculationMethod=$calculationMethod",
//     );

//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return PrayersTimeModel.fromJson(data);
//     } else {
//       throw Exception('Namaz vakitleri alınamadı');
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:namaz_vakti/model/yeni/prayers_time_model.dart';

class PrayerService {
  static const String _baseUrl = "https://vakit.vercel.app/api";

  static Future<PrayersTimeModel> fetchPrayerTimes(int placeId, ) async {
    final now = DateTime.now();
    final formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final url = Uri.parse("$_baseUrl/timesForPlace?id=$placeId&date=$formattedDate&days=1&timezoneOffset=180&calculationMethod=Turkey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PrayersTimeModel.fromJson(data);
    } else {
      throw Exception('Namaz vakitleri alınamadı');
    }
  }
}

