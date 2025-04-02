import 'package:home_widget/home_widget.dart';

Future<void> updateNamazWidget({
  required String fajr,
  required String dhuhr,
  required String asr,
  required String maghrib,
  required String isha,
}) async {
  await HomeWidget.saveWidgetData<String>('fajr', fajr);
  await HomeWidget.saveWidgetData<String>('dhuhr', dhuhr);
  await HomeWidget.saveWidgetData<String>('asr', asr);
  await HomeWidget.saveWidgetData<String>('maghrib', maghrib);
  await HomeWidget.saveWidgetData<String>('isha', isha);

  await HomeWidget.updateWidget(
    androidName: 'NamazWidgetProvider',
    iOSName: 'NamazWidget',
  );
  await Future.delayed(const Duration(seconds: 1));
  await HomeWidget.updateWidget(
    androidName: 'NamazWidgetProvider',
  );
}
