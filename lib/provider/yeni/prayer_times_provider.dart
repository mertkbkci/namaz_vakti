import 'package:flutter/material.dart';
import 'package:namaz_vakti/model/yeni/prayers_time_model.dart';
import 'package:namaz_vakti/services/yeni/prayer_times_service.dart';


class PrayerTimesProvider with ChangeNotifier {
  PrayersTimeModel? prayersTimeModel;
  bool isLoading = false;

  Future<void> loadPrayerTimes({
    required int placeId,
    required String date,
    int days = 1,
  }) async {
    isLoading = true;
    notifyListeners();

    prayersTimeModel = await PrayerService.fetchPrayerTimes(
placeId
     
    );

    isLoading = false;
    notifyListeners();
  }
}
