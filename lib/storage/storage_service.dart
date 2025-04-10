import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveLocation({
    required String country,
    required String region,
    required String city,
    required double lat,
    required double lng,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('country', country);
    await prefs.setString('region', region);
    await prefs.setString('city', city);
    await prefs.setDouble('lat', lat);
    await prefs.setDouble('lng', lng);
  }

  static Future<Map<String, dynamic>?> getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final country = prefs.getString('country');
    final region = prefs.getString('region');
    final city = prefs.getString('city');
    final lat = prefs.getDouble('lat');
    final lng = prefs.getDouble('lng');

    if (country != null && region != null && city != null && lat != null && lng != null) {
      return {
        'country': country,
        'region': region,
        'city': city,
        'lat': lat,
        'lng': lng,
      };
    } else {
      return null;
    }
  }

 

  static Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('country');
    await prefs.remove('region');
    await prefs.remove('city');
    await prefs.remove('lat');
    await prefs.remove('lng');
  }
}
