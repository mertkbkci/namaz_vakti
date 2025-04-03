import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:namaz_vakti/model/api_prayer_times_model.dart';
import 'package:namaz_vakti/widgets/city_selector_dialog.dart';
import 'package:namaz_vakti/screens/dua_page.dart';
import 'package:namaz_vakti/helper/home_widget_helper.dart';
import 'package:namaz_vakti/services/location_service.dart';
import 'package:namaz_vakti/services/namaz_vakti_api_service.dart';
import 'package:namaz_vakti/services/notification_service.dart';
import 'package:namaz_vakti/services/prayer_time_service.dart';
import 'package:namaz_vakti/screens/qibla_page.dart';
import 'package:namaz_vakti/screens/setting_page.dart';
import 'package:namaz_vakti/services/settings_service.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? _currentPosition;
  PrayerTimes? _prayerTimes;
  // ignore: unused_field
  ApiPrayerTimes? _apiPrayerTimes;
  String? selectedCity;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLocation();


  }

 


  Future<void> _loadLocation() async {
    setState(() => _isLoading = true);
    final (useManual, savedLat, savedLng) =
        await SettingsService.getManualLocation();
    final useApi = await SettingsService.getUseApi();

    double lat, lng;

    if (useManual && savedLat != null && savedLng != null) {
      lat = savedLat;
      lng = savedLng;
      _currentPosition = Position(
        latitude: lat,
        longitude: lng,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    } else {
      Position? pos = await LocationService.getCurrentLocation();
      if (pos == null) return;
      _currentPosition = pos;
      lat = pos.latitude;
      lng = pos.longitude;
    }

    if (useApi) {
      try {
        final city = await SettingsService.getApiCity();

        final apiService = NamazVaktiApiService();
        final apiTimes = await apiService.fetchPrayerTimes(city);

        setState(() {
          _apiPrayerTimes = apiTimes;
          _prayerTimes = null;
          selectedCity = city;
        });

        await NotificationService.scheduleNotification(
          id: 1,
          title: 'Namaz Vakti',
          body: 'İmsak vakti yaklaşıyor',
          dateTime: apiTimes.fajr.subtract(const Duration(minutes: 5)),
        );
        await NotificationService.scheduleNotification(
          id: 2,
          title: 'Namaz Vakti',
          body: 'Öğle vakti yaklaşıyor',
          dateTime: apiTimes.dhuhr.subtract(const Duration(minutes: 5)),
        );
        await NotificationService.scheduleNotification(
          id: 3,
          title: 'Namaz Vakti',
          body: 'İkindi vakti yaklaşıyor',
          dateTime: apiTimes.asr.subtract(const Duration(minutes: 5)),
        );
        await NotificationService.scheduleNotification(
          id: 4,
          title: 'Namaz Vakti',
          body: 'Akşam vakti yaklaşıyor',
          dateTime: apiTimes.maghrib.subtract(const Duration(minutes: 5)),
        );
        await NotificationService.scheduleNotification(
          id: 5,
          title: 'Namaz Vakti',
          body: 'Yatsı vakti yaklaşıyor',
          dateTime: apiTimes.isha.subtract(const Duration(minutes: 5)),
        );
        await updateNamazWidget(
          fajr: DateFormat.Hm().format(apiTimes.fajr),
          dhuhr: DateFormat.Hm().format(apiTimes.dhuhr),
          asr: DateFormat.Hm().format(apiTimes.asr),
          maghrib: DateFormat.Hm().format(apiTimes.maghrib),
          isha: DateFormat.Hm().format(apiTimes.isha),
        );
      } catch (e) {
        debugPrint('API hatası: $e');
       
      }
    } else {
      final times = PrayerTimeService.getPrayerTimes(lat, lng);

      setState(() {
        _prayerTimes = times;
        _apiPrayerTimes = null;
      });

      await NotificationService.scheduleNotification(
        id: 1,
        title: 'Namaz Vakti',
        body: 'İmsak vakti yaklaşıyor',
        dateTime: times.fajr.subtract(const Duration(minutes: 5)),
      );
      await NotificationService.scheduleNotification(
        id: 2,
        title: 'Namaz Vakti',
        body: 'Öğle vakti yaklaşıyor',
        dateTime: times.dhuhr.subtract(const Duration(minutes: 5)),
      );
      await NotificationService.scheduleNotification(
        id: 3,
        title: 'Namaz Vakti',
        body: 'İkindi vakti yaklaşıyor',
        dateTime: times.asr.subtract(const Duration(minutes: 5)),
      );
      await NotificationService.scheduleNotification(
        id: 4,
        title: 'Namaz Vakti',
        body: 'Akşam vakti yaklaşıyor',
        dateTime: times.maghrib.subtract(const Duration(minutes: 5)),
      );
      await NotificationService.scheduleNotification(
        id: 5,
        title: 'Namaz Vakti',
        body: 'Yatsı vakti yaklaşıyor',
        dateTime: times.isha.subtract(const Duration(minutes: 5)),
      );
      await updateNamazWidget(
        fajr: DateFormat.Hm().format(times.fajr),
        dhuhr: DateFormat.Hm().format(times.dhuhr),
        asr: DateFormat.Hm().format(times.asr),
        maghrib: DateFormat.Hm().format(times.maghrib),
        isha: DateFormat.Hm().format(times.isha),
      );
    }
    if (_apiPrayerTimes != null) {
      await updateNamazWidget(
        fajr: formatTime(_apiPrayerTimes!.fajr),
        dhuhr: formatTime(_apiPrayerTimes!.dhuhr),
        asr: formatTime(_apiPrayerTimes!.asr),
        maghrib: formatTime(_apiPrayerTimes!.maghrib),
        isha: formatTime(_apiPrayerTimes!.isha),
      );
    } else if (_prayerTimes != null) {
      await updateNamazWidget(
        fajr: formatTime(_prayerTimes!.fajr),
        dhuhr: formatTime(_prayerTimes!.dhuhr),
        asr: formatTime(_prayerTimes!.asr),
        maghrib: formatTime(_prayerTimes!.maghrib),
        isha: formatTime(_prayerTimes!.isha),
      );
    }

    setState(() => _isLoading = false);
  }

  String formatTime(DateTime time) {
    return DateFormat.Hm().format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text('Namaz Vakitleri',
            style: TextStyle(color: Colors.white)),
        // leading: IconButton(
        //   icon: const Icon(Icons.menu_book, color: Colors.white),
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (_) => const DuaPage()),
        //     );
        //   },
        // ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.explore, color: Colors.white),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (_) => const QiblaPage()),
          //     );
          //   },
          // ),
          // IconButton(
          //     onPressed: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => const SettingsPage()));
          //     },
          //     icon: Icon(Icons.settings, color: Colors.white)),
          IconButton(
            icon: const Icon(Icons.location_city, color: Colors.white),
            onPressed: () async {
              final selectedCity = await showDialog<String>(
                context: context,
                builder: (_) => const CitySelectorDialog(),
              );
              if (selectedCity != null) {
                await SettingsService.setApiCity(selectedCity);
                await SettingsService.clearManualLocation();
                _loadLocation();
              }
              // final selectedCity = await showDialog<String>(
              //   context: context,
              //   builder: (_) => const CitySelectorDialog(),
              // );
              // if (selectedCity != null) {
              //   await SettingsService.setApiCity(selectedCity);
              //   await SettingsService.clearManualLocation();
              //   _loadLocation();
              // }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: Lottie.asset("assets/lottie/loading.json"))
          : _currentPosition == null
              ? Center(child: Lottie.asset("assets/lottie/loading.json"))
              : (_apiPrayerTimes != null
                  ? RefreshIndicator(
                    onRefresh: () async {
                      setState(() => _isLoading = true);
                      await _loadLocation();
                    },
                    child: buildPrayerGrid(_apiPrayerTimes!))
                  : (_prayerTimes != null
                      ? RefreshIndicator(
                        onRefresh: () async {
                      setState(() => _isLoading = true);
                      await _loadLocation();
                    },
                        child: buildPrayerGrid(_prayerTimes!))
                      : const Center(
                          child: Text("Namaz vakitleri yüklenemedi")))),
    );
  }

  Widget prayerCard(String title, DateTime time) {
    final icons = {
      'İmsak': Icons.nightlight_round,
      'Güneş': Icons.wb_sunny,
      'Öğle': Icons.sunny,
      'İkindi': Icons.cloud,
      'Akşam': Iconsax.sun_fog5,
      'Yatsı': Icons.brightness_3,
    };

    final icon = icons[title] ?? Icons.access_time;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.green.shade700),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            formatTime(time),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPrayerGrid(dynamic times) {
    final today = DateFormat.yMMMMEEEEd().format(DateTime.now().toLocal());

    final next = getNextPrayerTime(times);
    final countdown = getCountdownText(next);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "🕒 Sonraki namaza: $countdown",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            today,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.green),
              const SizedBox(width: 4),
              Text(
                selectedCity ?? 'Şehir seçilmedi',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
              children: [
                prayerCard('İmsak', times.fajr),
                prayerCard('Güneş', times.sunrise),
                prayerCard('Öğle', times.dhuhr),
                prayerCard('İkindi', times.asr),
                prayerCard('Akşam', times.maghrib),
                prayerCard('Yatsı', times.isha),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DateTime? getNextPrayerTime(dynamic times) {
    final now = DateTime.now();

    final list = [
      times.fajr,
      times.sunrise,
      times.dhuhr,
      times.asr,
      times.maghrib,
      times.isha,
    ];

    return list.firstWhere(
      (time) => time.isAfter(now),
      orElse: () => null,
    );
  }

  String getCountdownText(DateTime? nextTime) {
    if (nextTime == null) return "Tüm vakitler geçti";

    final diff = nextTime.difference(DateTime.now());
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);

    if (diff.isNegative) return "Tüm vakitler geçti";

    if (hours > 0) {
      return "$hours saat $minutes dakika kaldı";
    } else {
      return "$minutes dakika kaldı";
    }
  }
}
