import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:namaz_vakti/provider/yeni/location_provider.dart';
import 'package:namaz_vakti/screens/location/location_screen.dart';
import 'package:namaz_vakti/screens/montly_prayer_times.dart';
import 'package:namaz_vakti/storage/storage_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<LocationProvider>(context, listen: false)
        .loadSavedLocation());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocationProvider>(context);

    if (provider.prayersTimeModel == null) {
      return Scaffold(
        body: Center(
          child: Lottie.asset("assets/lottie/loading.json"),
        ),
      );
    }

    final times = provider.prayersTimeModel!.times.entries.first.value;
    final date = provider.prayersTimeModel!.times.keys.first;
    final formattedDate =
        DateFormat.yMMMMEEEEd('tr_TR').format(DateTime.parse(date));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Namaz Vakitleri',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on, color: Colors.white),
            onPressed: () async {
              await StorageService.clearLocation();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => const LocationSelectionPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Colors.white),
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    Center(child: Lottie.asset("assets/lottie/loading.json")),
              );

              try {
                await provider.fetchMonthlyPrayerTimes();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MonthlyPrayerTimesPage(),
                  ),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('İmsakiye yüklenemedi: $e')),
                );
              }
            },
          ),

          // IconButton(
          //     icon: const Icon(Icons.calendar_month,color:Colors.white),
          //     onPressed: () async {
          //       await provider.fetchMonthlyPrayerTimes();
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (_) => const MonthlyPrayerTimesPage(),
          //         ),
          //       );
          //     },
          //   ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (provider.prayersTimeModel != null) ...[
              Text(
                provider.prayersTimeModel!.place.name,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              'Tarih: $formattedDate',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: times.length,
                itemBuilder: (context, index) {
                  final prayerNames = [
                    "İmsak",
                    "Güneş",
                    "Öğle",
                    "İkindi",
                    "Akşam",
                    "Yatsı"
                  ];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.access_time, color: Colors.blue),
                      title: Text(prayerNames[index]),
                      trailing: Text(times[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
