import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:namaz_vakti/settings_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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

  if (scheduledTime.isBefore(DateTime.now())) return;

  const androidDetails = AndroidNotificationDetails(
    'prayer_channel',
    'Namaz Vakitleri',
    channelDescription: 'Namaz vakti bildirimleri',
    importance: Importance.max,
    priority: Priority.high,
    sound: RawResourceAndroidNotificationSound('ezan'), 
    playSound: true,
  );

  final silentDetails = const AndroidNotificationDetails(
    'prayer_channel',
    'Namaz Vakitleri',
    channelDescription: 'Namaz vakti bildirimleri',
    importance: Importance.max,
    priority: Priority.high,
    playSound: false,
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
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}


}
