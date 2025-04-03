class ApiPrayerTimes {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;

  ApiPrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory ApiPrayerTimes.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    DateTime parseTime(String timeStr) {
      final parts = timeStr.split(':');
      return DateTime(now.year, now.month, now.day,
          int.parse(parts[0]), int.parse(parts[1]));
    }

    return ApiPrayerTimes(
      fajr: parseTime(json['Fajr']),
      sunrise: parseTime(json['Sunrise']),
      dhuhr: parseTime(json['Dhuhr']),
      asr: parseTime(json['Asr']),
      maghrib: parseTime(json['Maghrib']),
      isha: parseTime(json['Isha']),
    );
  }
}
