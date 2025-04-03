import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:namaz_vakti/model/api_prayer_times_model.dart';


class NamazVaktiApiService {
  // Future<ApiPrayerTimes> fetchPrayerTimes(String city) async {
  //   final url = 'http://api.aladhan.com/v1/timingsByCity?city=$city&country=Turkey&method=13';
  //   final response = await http.get(Uri.parse(url));

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     final timings = data['data']['timings'];
  //     return ApiPrayerTimes.fromJson(timings);
  //   } else {
  //     throw Exception('Namaz vakitleri alınamadı');
  //   }
  // }

Future<ApiPrayerTimes> fetchPrayerTimes(String city, {DateTime? date}) async {
  final formattedDate = date != null
      ? '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}'
      : '';

  final url = Uri.parse(
    'http://api.aladhan.com/v1/timingsByCity?city=$city&country=Turkey&method=13${date != null ? '&date=$formattedDate' : ''}',
  );

  final response = await http.get(url);
  print(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final timings = data['data']['timings'];
    return ApiPrayerTimes.fromJson(timings);
  } else {
    throw Exception('Namaz vakitleri alınamadı');
  }
}




}
