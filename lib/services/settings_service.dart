import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String keyUseManual = 'use_manual_location';
  static const String keyLat = 'manual_latitude';
  static const String keyLng = 'manual_longitude';
  static const String keyUseApi = 'use_api';
  static const String keyApiCity = 'api_city';
  static const String keyNotificationOffset = 'notification_offset';
  static const String keySilentNotification = 'silent_notif';
  static const String keyThemeMode = 'theme_mode';
  static const String keyFavoriteCities = 'favorite_cities';

  static Future<void> setManualLocation(double lat, double lng) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyUseManual, true);
    await prefs.setDouble(keyLat, lat);
    await prefs.setDouble(keyLng, lng);
  }

  static Future<void> clearManualLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyUseManual, false);
  }

  static Future<(bool, double?, double?)> getManualLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final useManual = prefs.getBool(keyUseManual) ?? false;
    final lat = prefs.getDouble(keyLat);
    final lng = prefs.getDouble(keyLng);
    return (useManual, lat, lng);
  }

  static Future<void> setUseApi(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(keyUseApi, value);
}

static Future<bool> getUseApi() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(keyUseApi) ?? true;
}



static Future<void> setApiCity(String city) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(keyApiCity, city);
}

static Future<String> getApiCity() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(keyApiCity) ?? 'Samsun';
}



static Future<void> setNotificationOffset(int minutes) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(keyNotificationOffset, minutes);
}

static Future<int> getNotificationOffset() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(keyNotificationOffset) ?? -5; 
}



static Future<void> setSilentNotification(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(keySilentNotification, value);
}

static Future<bool> getSilentNotification() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(keySilentNotification) ?? false;
}



static Future<void> setThemeMode(ThemeMode mode) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt(keyThemeMode, mode.index);
}

static Future<ThemeMode> getThemeMode() async {
  final prefs = await SharedPreferences.getInstance();
  final index = prefs.getInt(keyThemeMode) ?? ThemeMode.system.index;
  return ThemeMode.values[index];
}



static Future<List<String>> getFavoriteCities() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(keyFavoriteCities) ?? [];
}

static Future<void> addFavoriteCity(String city) async {
  final prefs = await SharedPreferences.getInstance();
  final list = prefs.getStringList(keyFavoriteCities) ?? [];
  if (!list.contains(city)) {
    list.add(city);
    await prefs.setStringList(keyFavoriteCities, list);
  }
}

static Future<void> removeFavoriteCity(String city) async {
  final prefs = await SharedPreferences.getInstance();
  final list = prefs.getStringList(keyFavoriteCities) ?? [];
  list.remove(city);
  await prefs.setStringList(keyFavoriteCities, list);
}


}
