

import 'package:flutter/material.dart';
import 'package:namaz_vakti/model/yeni/countries_model.dart';
import 'package:namaz_vakti/model/yeni/prayers_time_model.dart';
import 'package:namaz_vakti/services/notification_service.dart';
import 'package:namaz_vakti/services/yeni/location_service.dart';
import 'package:namaz_vakti/storage/storage_service.dart';



class LocationProvider with ChangeNotifier {
  List<CountriesModel> countries = [];
  List<String> regions = [];
  List<String> cities = [];

  double? selectedLat;
  double? selectedLng;

  

  String? selectedCountry;
  String? selectedRegion;
  String? selectedCity;
  int? placeId;

 Map<String, dynamic>? coordinates;


  bool isLoading = false;
  PrayersTimeModel? prayersTimeModel;

  PrayersTimeModel? monthlyPrayersTimeModel;


Future<void> fetchMonthlyPrayerTimes() async {
    if (selectedLat == null || selectedLng == null) {
      throw Exception('Koordinatlar eksik veya hatalı');
    }

    final today = DateTime.now();
    monthlyPrayersTimeModel = await LocationService.fetchMonthlyPrayerTimes(
      lat: selectedLat!,
      lng: selectedLng!,
      year: today.year,
      month: today.month,
    );

    notifyListeners();
  }

// Future<void> loadSavedLocation() async {
//   final savedLocation = await StorageService.getLocation();
//   if (savedLocation != null) {
//     selectedCountry = savedLocation['country'];
//     selectedRegion = savedLocation['region'];
//     selectedCity = savedLocation['city'];
//     selectedLat = savedLocation['lat'];
//     selectedLng = savedLocation['lng'];
//     notifyListeners();
//   }
// }
 Future<void> loadSavedLocation() async {
    final savedLocation = await StorageService.getLocation();
    if (savedLocation != null) {
      selectedCountry = savedLocation['country'];
      selectedRegion = savedLocation['region'];
      selectedCity = savedLocation['city'];
      selectedLat = savedLocation['lat'];
      selectedLng = savedLocation['lng'];

      await fetchPrayerTimesByCoordinates(selectedLat!, selectedLng!); 
      
      await NotificationService().planPrayerNotifications(prayersTimeModel!);
    }

    notifyListeners();
  }


  Future<void> loadCountries() async {
    isLoading = true;
    notifyListeners();
    countries = await LocationService.fetchCountries();
    isLoading = false;
    notifyListeners();
  }

  Future<void> selectCountry(String country) async {
    selectedCountry = country;
    selectedRegion = null;
    selectedCity = null;
    regions = [];
    cities = [];
    prayersTimeModel = null;

    isLoading = true;
    notifyListeners();
    regions = await LocationService.fetchRegions(country);
    isLoading = false;
    notifyListeners();
  }

  Future<void> selectRegion(String region) async {
    selectedRegion = region;
    selectedCity = null;
    cities = [];
    prayersTimeModel = null;

    isLoading = true;
    notifyListeners();
    cities = await LocationService.fetchCities(selectedCountry!, region);
    isLoading = false;
    notifyListeners();
  }

  
Future<void> selectCity(String city) async {
  selectedCity = city;
  isLoading = true;
  notifyListeners();

  coordinates = await LocationService.fetchCoordinates(selectedCountry!, selectedRegion!, city);
  
  if (coordinates != null) {
    await StorageService.saveLocation(
      country: selectedCountry!,
      region: selectedRegion!,
      city: selectedCity!,
      lat: coordinates!['lat']!,
      lng: coordinates!['lng']!,
    );

    
    prayersTimeModel = await LocationService.fetchPrayerTimesByCoordinates(
      coordinates!['lat']!,
      coordinates!['lng']!,
    );
      await NotificationService().planPrayerNotifications(prayersTimeModel!);
  }


  isLoading = false;
  notifyListeners();
}

Future<void> fetchPrayerTimesByCoordinates(double lat, double lng) async {
  prayersTimeModel = await LocationService.fetchPrayerTimesByCoordinates(lat, lng);
  notifyListeners();
}

// Future<void> selectCity(String city) async {
//   selectedCity = city;
//   isLoading = true;
//   notifyListeners();

//   final coords = await LocationService.fetchCoordinates(selectedCountry!, selectedRegion!, city);
//   final lat = coords['lat'];
//   final lng = coords['lng'];

//   if (lat != null && lng != null) {
//     prayersTimeModel = await LocationService.fetchPrayerTimesByCoordinates(lat, lng);
//   } else {
//     throw Exception('Koordinatlar eksik veya hatalı');
//   }

//   isLoading = false;
//   notifyListeners();
// }









}


