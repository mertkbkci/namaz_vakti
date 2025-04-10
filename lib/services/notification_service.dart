import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:namaz_vakti/model/yeni/prayers_time_model.dart';
import 'package:namaz_vakti/services/settings_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidInit,
    );

    await _notificationsPlugin.initialize(initSettings);
    tz.initializeTimeZones();
     await requestNotificationPermission();
  }

   static Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }



Future<void> planPrayerNotifications(PrayersTimeModel prayersTimeModel) async {
  final times = prayersTimeModel.times.entries.first.value; // Bugün için vakitler
  final date = DateTime.now(); // Bugünün tarihi

  final prayerNames = ["İmsak", "Güneş", "Öğle", "İkindi", "Akşam", "Yatsı"];

  for (int i = 0; i < times.length; i++) {
    final timeParts = times[i].split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    final scheduledDateTime = DateTime(date.year, date.month, date.day, hour, minute);

    await NotificationService.scheduleNotification(
      id: i + 1,
      title: 'Namaz Vakti',
      body: '${prayerNames[i]} vakti geldi!',
      dateTime: scheduledDateTime,
    );
  }
}
 
static Future<void> scheduleNotification({
  required int id,
  required String title,
  required String body,
  required DateTime dateTime,
}) async {
  final offset = await SettingsService.getNotificationOffset();
  final isSilent = await SettingsService.getSilentNotification();
  final scheduledTime = dateTime.add(Duration(minutes: offset));
debugPrint("📅 Planlanan bildirim zamanı: $scheduledTime");
  if (scheduledTime.isBefore(DateTime.now())) return;

  const androidDetails = AndroidNotificationDetails(
    'prayer_channel',
    'Namaz Vakitleri',
    channelDescription: 'Namaz vakti bildirimleri',
    importance: Importance.max,
    priority: Priority.high,
    sound: RawResourceAndroidNotificationSound('ezan'), 
    playSound: true,
     icon: 'kaba',
  );

  final silentDetails = const AndroidNotificationDetails(
    'prayer_channel',
    'Namaz Vakitleri',
    channelDescription: 'Namaz vakti bildirimleri',
    importance: Importance.max,
    priority: Priority.high,
    playSound: false,
     icon: 'kaba',
  );

  await _notificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    tz.TZDateTime.from(scheduledTime, tz.local),
    NotificationDetails(
      android: isSilent ? silentDetails : androidDetails,
    ),
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}
static Future<void> showTestNotification() async {
  await _notificationsPlugin.zonedSchedule(
    10,
    'Test Bildirimi',
    '5 saniye sonra gösterilecek',
    tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'test_channel',
        'Test Kanalı',
        importance: Importance.max,
        priority: Priority.high,
          icon: 'kaba',
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}


}
