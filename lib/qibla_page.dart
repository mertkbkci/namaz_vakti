import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  double? _heading = 0;
  Position? _position;
  double? _qiblaDirection = 0;

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

    FlutterCompass.events!.listen((event) {
      setState(() {
        _heading = event.heading;
      });
    });
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

    return Scaffold(
      appBar: AppBar(title: const Text('Kıble Yönü')),
      body: Stack(
        children: [

    
          Positioned(
            top: 60,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: Image.asset(
                'assets/kaba.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
          Center(
          child: Transform.rotate(
            angle: rotation,
            child: Image.asset(
              'assets/qibla_arrow.png', 
              width: 200,
              height: 200,
            ),
          ),
        ),
        ],
       
      ),
    );
  }
}

