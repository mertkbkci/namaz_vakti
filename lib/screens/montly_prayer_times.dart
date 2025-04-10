// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:namaz_vakti/provider/yeni/location_provider.dart';
// // import 'package:provider/provider.dart';

// // class MonthlyPrayerTimesPage extends StatelessWidget {
// //   const MonthlyPrayerTimesPage({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final provider = Provider.of<LocationProvider>(context);

// //     final model = provider.monthlyPrayersTimeModel;

// //     if (model == null || model.times.isEmpty) {
// //       return const Scaffold(
// //         body: Center(child: Text('İmsakiye verisi bulunamadı')),
// //       );
// //     }

// //     final entries = model.times.entries.toList();

// //     return Scaffold(
// //       appBar: AppBar(
// //         automaticallyImplyLeading: false,
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back),
// //           onPressed: () {
// //             Navigator.pop(context);
// //           },
// //         ),
// //         title: const Text('İmsakiye Takvimi',
// //             style: TextStyle(color: Colors.white, fontSize: 20,
// //                 fontWeight: FontWeight.bold)),
// //         centerTitle: true,
// //         backgroundColor: Colors.blue,
// //       ),
// //       body: ListView.builder(
// //         itemCount: entries.length,
// //         itemBuilder: (context, index) {
// //           final date = entries[index].key;
// //           final times = entries[index].value;
// //           final formattedDate =
// //         DateFormat.yMMMMEEEEd('tr_TR').format(DateTime.parse(date));

// //           final prayerNames = ["İmsak", "Güneş", "Öğle", "İkindi", "Akşam", "Yatsı"];

// //           return Card(
// //             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //             child: ExpansionTile(
// //               title: Text(formattedDate, style: const TextStyle(fontWeight: FontWeight.bold)),
// //               children: List.generate(6, (i) {
// //                 return ListTile(
// //                   title: Text(prayerNames[i]),
// //                   trailing: Text(times[i]),
// //                 );
// //               }),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:namaz_vakti/provider/yeni/location_provider.dart';
// import 'package:provider/provider.dart';

// class MonthlyPrayerTimesPage extends StatelessWidget {
//   const MonthlyPrayerTimesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<LocationProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: const Text('İmsakiye Takvimi'),
//         centerTitle: true,
//       ),
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: provider.monthlyPrayerTimes.length,
//               itemBuilder: (context, index) {
//                 final day = provider.monthlyPrayerTimes[index];
//                 final times = day['times'] as List<dynamic>;

//                 return Card(
//                   margin: const EdgeInsets.all(8),
//                   child: ListTile(
//                     title: Text('📅 ${day['date']}'),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('İmsak: ${times[0]}'),
//                         Text('Güneş: ${times[1]}'),
//                         Text('Öğle: ${times[2]}'),
//                         Text('İkindi: ${times[3]}'),
//                         Text('Akşam: ${times[4]}'),
//                         Text('Yatsı: ${times[5]}'),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:namaz_vakti/provider/yeni/location_provider.dart';
import 'package:provider/provider.dart';

class MonthlyPrayerTimesPage extends StatelessWidget {
  const MonthlyPrayerTimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocationProvider>(context);

    final monthlyTimes = provider.monthlyPrayersTimeModel?.times;

    if (monthlyTimes == null || monthlyTimes.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('İmsakiye verisi bulunamadı')),
      );
    }

    final placeName = provider.monthlyPrayersTimeModel?.place.name ?? "";

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('İmsakiye - Aylık Vakitler',
            style: TextStyle(color: Colors.white, fontSize: 20,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: monthlyTimes.entries.map((entry) {
          final date = entry.key;
          final times = entry.value;
            final formattedDate =
        DateFormat.yMMMMEEEEd('tr_TR').format(DateTime.parse(date));

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text('📅 ${formattedDate} - $placeName', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('İmsak: ${times[0]}'),
                  Text('Güneş: ${times[1]}'),
                  Text('Öğle: ${times[2]}'),
                  Text('İkindi: ${times[3]}'),
                  Text('Akşam: ${times[4]}'),
                  Text('Yatsı: ${times[5]}'),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
