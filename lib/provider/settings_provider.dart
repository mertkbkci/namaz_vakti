import 'package:flutter/material.dart';
import 'package:namaz_vakti/services/settings_service.dart';

class SettingsProvider with ChangeNotifier {
  int _notificationOffset = 0;
  bool _isSilent = false;

  int get notificationOffset => _notificationOffset;
  bool get isSilent => _isSilent;

  Future<void> loadSettings() async {
    _notificationOffset = await SettingsService.getNotificationOffset();
    _isSilent = await SettingsService.getSilentNotification();
    notifyListeners();
  }

  Future<void> setOffset(int offset) async {
    _notificationOffset = offset;
    await SettingsService.setNotificationOffset(offset);
    notifyListeners();
  }

  Future<void> setSilent(bool silent) async {
    _isSilent = silent;
    await SettingsService.setSilentNotification(silent);
    notifyListeners();
  }
}
