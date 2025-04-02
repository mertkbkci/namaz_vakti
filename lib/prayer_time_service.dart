
import 'package:adhan/adhan.dart';

class PrayerTimeService {
  static PrayerTimes getPrayerTimes(double lat, double lng) {
    final coordinates = Coordinates(lat, lng);

    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.hanafi;

    final now = DateTime.now();
    final dateComponents = DateComponents(now.year, now.month, now.day);

    final prayerTimes = PrayerTimes(coordinates, dateComponents, params);

    return prayerTimes;
  }
}
