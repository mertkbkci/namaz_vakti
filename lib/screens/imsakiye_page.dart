import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:namaz_vakti/model/api_prayer_times_model.dart';
import 'package:namaz_vakti/services/namaz_vakti_api_service.dart';
import 'package:namaz_vakti/services/settings_service.dart';

class ImsakiyePage extends StatefulWidget {
  const ImsakiyePage({super.key});

  @override
  State<ImsakiyePage> createState() => _ImsakiyePageState();
}

class _ImsakiyePageState extends State<ImsakiyePage> {
  DateTime selectedDate = DateTime.now();
  ApiPrayerTimes? prayerTimes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    final city = await SettingsService.getApiCity();
    final api = NamazVaktiApiService();
    final result = await api.fetchPrayerTimes(city, date: selectedDate);
    setState(() {
      prayerTimes = result;
      isLoading = false;
    });
  }

  void _changeDate(int dayOffset) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: dayOffset));
    });
    _loadData();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('tr', 'TR'),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat.yMMMMEEEEd('tr_TR').format(selectedDate);

    return Scaffold(
      appBar: AppBar(title: const Text('İmsakiye')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : prayerTimes == null
              ? const Center(child: Text('Veri alınamadı'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(formatted, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => _changeDate(-1),
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            label: const Text('Tarih Seç'),
                            onPressed: _selectDate,
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () => _changeDate(1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildTimeRow('İmsak', prayerTimes!.fajr),
                      _buildTimeRow('Güneş', prayerTimes!.sunrise),
                      _buildTimeRow('Öğle', prayerTimes!.dhuhr),
                      _buildTimeRow('İkindi', prayerTimes!.asr),
                      _buildTimeRow('Akşam', prayerTimes!.maghrib),
                      _buildTimeRow('Yatsı', prayerTimes!.isha),
                    ],
                  ),
                ),
    );
  }

  Widget _buildTimeRow(String title, DateTime time) {
    return ListTile(
      leading: const Icon(Icons.access_time),
      title: Text(title),
      trailing: Text(DateFormat.Hm().format(time)),
    );
  }
}
