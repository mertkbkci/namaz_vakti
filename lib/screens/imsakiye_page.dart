// import 'package:flutter/material.dart';
// import 'package:namaz_vakti/provider/location/location_provider.dart';
// import 'package:namaz_vakti/provider/yeni/location_provider.dart';

// import 'package:provider/provider.dart';

// class ImsakiyePage extends StatelessWidget {
//   final String country;
//   final String region;
//   final String city;

//   const ImsakiyePage({
//     super.key,
//     required this.country,
//     required this.region,
//     required this.city,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => LocationProvider()
//         ..fetchMonthlyPrayerTimes(country, region, city, DateTime.now().month, DateTime.now().year),
//       child: const _ImsakiyeBody(),
//     );
//   }
// }

// class _ImsakiyeBody extends StatelessWidget {
//   const _ImsakiyeBody();

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<LocationProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('İmsakiye Takvimi'),
//         backgroundColor: Colors.green,
//       ),
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: provider.monthlyPrayerTimes.length,
//               itemBuilder: (context, index) {
//                 final day = provider.monthlyPrayerTimes[index];
//                 return ListTile(
//                   title: Text(day['date']),
//                   subtitle: Text(
//                     'İmsak: ${day['fajr']} | Öğle: ${day['dhuhr']} | İkindi: ${day['asr']} | Akşam: ${day['maghrib']} | Yatsı: ${day['isha']}',
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
