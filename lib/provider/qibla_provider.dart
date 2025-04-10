import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vibration/vibration.dart';

class QiblaProvider with ChangeNotifier {
  double? _heading = 0;
  double? _qiblaDirection = 0;
  bool _vibrated = false;
  StreamSubscription<CompassEvent>? _compassSubscription;
  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  double? get heading => _heading;
  double? get qiblaDirection => _qiblaDirection;

  Future<void> init() async {
    final position = await Geolocator.getCurrentPosition();
    _qiblaDirection = _calculateQiblaDirection(position.latitude, position.longitude);

    _compassSubscription = FlutterCompass.events?.listen((event) async {
      final newHeading = event.heading ?? 0;
      final angleDiff = (_qiblaDirection! - newHeading).abs();

      if (angleDiff < 10 && !_vibrated) {
        _vibrated = true;
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 500);
        }
      } else if (angleDiff >= 10) {
        _vibrated = false;
      }

      _heading = newHeading;
      if (!_isDisposed) {
  notifyListeners();
}

    });
  }
   @override
  void dispose() {
    _isDisposed = true;
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
}
