import 'package:flutter/material.dart';
import 'package:namaz_vakti/settings_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadTheme() async {
    final mode = await SettingsService.getThemeMode();
    _themeMode = mode;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await SettingsService.setThemeMode(mode);
    notifyListeners();
  }
}
