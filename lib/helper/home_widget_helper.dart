import 'package:home_widget/home_widget.dart';

Future<void> updateNamazWidget({
  required List<String> times,
}) async {
  if (times.length < 6) {
    // Eğer eksik veri varsa
    return;
  }

  await HomeWidget.saveWidgetData<String>('fajr', times[0]);
  await HomeWidget.saveWidgetData<String>('sunrise', times[1]);
  await HomeWidget.saveWidgetData<String>('dhuhr', times[2]);
  await HomeWidget.saveWidgetData<String>('asr', times[3]);
  await HomeWidget.saveWidgetData<String>('maghrib', times[4]);
  await HomeWidget.saveWidgetData<String>('isha', times[5]);

  await HomeWidget.updateWidget(
    androidName: 'NamazWidgetProvider',
    iOSName: 'NamazWidget',
  );
}
