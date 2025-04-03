// // import 'dart:async';
// // import 'dart:math';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_compass/flutter_compass.dart';
// // import 'package:geolocator/geolocator.dart';

// // class QiblaPage extends StatefulWidget {
// //   const QiblaPage({super.key});

// //   @override
// //   State<QiblaPage> createState() => _QiblaPageState();
// // }

// // class _QiblaPageState extends State<QiblaPage> {
// //   double? _heading = 0;
// //   Position? _position;
// //   double? _qiblaDirection = 0;
// //   StreamSubscription<CompassEvent>? _compassSubscription;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initCompass();
// //   }

// //   Future<void> _initCompass() async {
// //     _position = await Geolocator.getCurrentPosition();
// //     _qiblaDirection = _calculateQiblaDirection(
// //       _position!.latitude,
// //       _position!.longitude,
// //     );

// //     FlutterCompass.events!.listen((event) {
// //        if (!mounted) return;
// //       setState(() {
// //         _heading = event.heading;
// //       });
// //     });
// //   }

// //   @override
// // void dispose() {
// //   _compassSubscription?.cancel(); 
// //   super.dispose();
// // }

// //   double _calculateQiblaDirection(double lat, double lng) {
// //     const kaabaLat = 21.4225;
// //     const kaabaLng = 39.8262;

// //     final latRad = _degToRad(lat);
// //     final lngRad = _degToRad(lng);
// //     final kaabaLatRad = _degToRad(kaabaLat);
// //     final kaabaLngRad = _degToRad(kaabaLng);

// //     final deltaLng = kaabaLngRad - lngRad;

// //     final x = sin(deltaLng);
// //     final y = cos(latRad) * tan(kaabaLatRad) - sin(latRad) * cos(deltaLng);
// //     final qiblaRad = atan2(x, y);
// //     return (_radToDeg(qiblaRad) + 360) % 360;
// //   }

// //   double _degToRad(double deg) => deg * pi / 180;

// //   double _radToDeg(double rad) => rad * 180 / pi;

// //   @override
// //   Widget build(BuildContext context) {
// //     final rotation = ((_qiblaDirection ?? 0) - (_heading ?? 0)) * (pi / 180);

// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.green,
// //         centerTitle: true,
// //          automaticallyImplyLeading: false,
// //         // leading: IconButton(
// //         //   icon: const Icon(Icons.arrow_back, color: Colors.white),
// //         //   onPressed: () => Navigator.pop(context),
// //         // ),
// //         title: const Text('Kıble Yönü',
// //             style: TextStyle(color: Colors.white, fontSize: 20)),
// //       ),
// //       body: Stack(
// //         children: [
// //           Positioned(
// //             top: 60,

// //             child: CircleAvatar(
// //               radius: 60,
// //               backgroundColor: Colors.white,
// //               child: Image.asset(
// //                 'assets/kaba.png',
// //                 width: 100,
// //                 height: 100,
// //               ),
// //             ),
// //           ),
// //           Center(
// //             child: Transform.rotate(
// //               angle: rotation,
// //               child: Image.asset(
// //                 'assets/qibla_arrow.png',
// //                 width: 200,
// //                 height: 200,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_compass/flutter_compass.dart';
// import 'package:geolocator/geolocator.dart';

// class QiblaPage extends StatefulWidget {
//   const QiblaPage({super.key});

//   @override
//   State<QiblaPage> createState() => _QiblaPageState();
// }

// class _QiblaPageState extends State<QiblaPage> {
//   double? _heading = 0;
//   Position? _position;
//   double? _qiblaDirection = 0;
//   StreamSubscription<CompassEvent>? _compassSubscription;

//   @override
//   void initState() {
//     super.initState();
//     _initCompass();
//   }

//   Future<void> _initCompass() async {
//     _position = await Geolocator.getCurrentPosition();
//     _qiblaDirection = _calculateQiblaDirection(
//       _position!.latitude,
//       _position!.longitude,
//     );

//     _compassSubscription = FlutterCompass.events!.listen((event) {
//       if (!mounted) return;
//       setState(() {
//         _heading = event.heading;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _compassSubscription?.cancel();
//     super.dispose();
//   }

//   double _calculateQiblaDirection(double lat, double lng) {
//     const kaabaLat = 21.4225;
//     const kaabaLng = 39.8262;

//     final latRad = _degToRad(lat);
//     final lngRad = _degToRad(lng);
//     final kaabaLatRad = _degToRad(kaabaLat);
//     final kaabaLngRad = _degToRad(kaabaLng);

//     final deltaLng = kaabaLngRad - lngRad;

//     final x = sin(deltaLng);
//     final y = cos(latRad) * tan(kaabaLatRad) - sin(latRad) * cos(deltaLng);
//     final qiblaRad = atan2(x, y);
//     return (_radToDeg(qiblaRad) + 360) % 360;
//   }

//   double _degToRad(double deg) => deg * pi / 180;
//   double _radToDeg(double rad) => rad * 180 / pi;

//   @override
//   Widget build(BuildContext context) {
//     final rotation = ((_qiblaDirection ?? 0) - (_heading ?? 0)) * (pi / 180);
//     final angleDiff = ((_qiblaDirection ?? 0) - (_heading ?? 0)).abs();
//     final isAligned = angleDiff < 10; 

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         centerTitle: true,
//         title: const Text('Kıble Yönü',
//             style: TextStyle(color: Colors.white, fontSize: 20)),
//       ),
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           Positioned(
//             top: 40,
//             child: CircleAvatar(
//               radius: 50,
//               backgroundColor: Colors.white,
//               child: Image.asset(
//                 'assets/kaba.png',
//                 width: 80,
//                 height: 80,
//               ),
//             ),
//           ),
//           Transform.rotate(
//             angle: rotation,
//             child: Image.asset(
//               'assets/qibla_arrow.png',
//               width: 200,
//               height: 200,
//               color: isAligned ? Colors.green : null, 
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vibration/vibration.dart';

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  double? _heading = 0;
  Position? _position;
  double? _qiblaDirection = 0;
  StreamSubscription<CompassEvent>? _compassSubscription;
  bool _vibrated = false;

  @override
  void initState() {
    super.initState();
    _initCompass();
  }

  Future<void> _initCompass() async {
    _position = await Geolocator.getCurrentPosition();
    _qiblaDirection = _calculateQiblaDirection(
      _position!.latitude,
      _position!.longitude,
    );

    _compassSubscription = FlutterCompass.events!.listen((event) async {
      if (!mounted) return;
      final newHeading = event.heading;
      final angleDiff = ((_qiblaDirection ?? 0) - (newHeading ?? 0)).abs();

      if (angleDiff < 10 && !_vibrated) {
        _vibrated = true;
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 500);
        }
      } else if (angleDiff >= 10) {
        _vibrated = false;
      }

      setState(() {
        _heading = newHeading;
      });
    });
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    super.dispose();
  }

  double _calculateQiblaDirection(double lat, double lng) {
    const kaabaLat = 21.4225;
    const kaabaLng = 39.8262;

    final latRad = _degToRad(lat);
    final lngRad = _degToRad(lng);
    final kaabaLatRad = _degToRad(kaabaLat);
    final kaabaLngRad = _degToRad(kaabaLng);

    final deltaLng = kaabaLngRad - lngRad;

    final x = sin(deltaLng);
    final y = cos(latRad) * tan(kaabaLatRad) - sin(latRad) * cos(deltaLng);
    final qiblaRad = atan2(x, y);
    return (_radToDeg(qiblaRad) + 360) % 360;
  }

  double _degToRad(double deg) => deg * pi / 180;
  double _radToDeg(double rad) => rad * 180 / pi;

  @override
  Widget build(BuildContext context) {
    final rotation = ((_qiblaDirection ?? 0) - (_heading ?? 0)) * (pi / 180);
    final angleDiff = ((_qiblaDirection ?? 0) - (_heading ?? 0)).abs();
    final isAligned = angleDiff < 10;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text('Kıble Yönü',
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Image.asset(
                'assets/kaba.png',
                width: 80,
                height: 80,
              ),
            ),
          ),
          const SizedBox(height: 60),
          Center(
            child: Transform.rotate(
              angle: rotation,
              child: Image.asset(
                'assets/qibla_arrow.png',
                width: 200,
                height: 200,
                color: isAligned ? Colors.green : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


