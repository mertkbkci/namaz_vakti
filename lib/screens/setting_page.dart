import 'package:flutter/material.dart';
import 'package:namaz_vakti/services/settings_service.dart';
import 'package:namaz_vakti/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _offset = -5;
  bool _isSilent = false;

  @override
  void initState() {
    super.initState();
    _loadOffset();
    _loadSilent();
  }

  Future<void> _loadSilent() async {
    final value = await SettingsService.getSilentNotification();
    setState(() => _isSilent = value);
  }

  Future<void> _loadOffset() async {
    final value = await SettingsService.getNotificationOffset();
    setState(() => _offset = value);
  }

  Future<void> _updateOffset(int value) async {
    await SettingsService.setNotificationOffset(value);
    setState(() => _offset = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.green,
        centerTitle: true,
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: const Text('Ayarlar', style: TextStyle(color: Colors.white, fontSize: 20)),),
      body: ListView(
        children: [
          const ListTile(
            title: Text('📳 Bildirim Zamanı'),
            subtitle: Text('Namazdan kaç dakika önce/sonra bildirilsin?'),
          ),
          RadioListTile<int>(
            title: const Text('5 dakika önce'),
            value: -5,
            groupValue: _offset,
            onChanged: (value) {
              if (value != null) {
                _updateOffset(value);
              }
            },
          ),
          RadioListTile<int>(
            title: const Text('Tam vaktinde'),
            value: 0,
            groupValue: _offset,
            onChanged: (value) {
              if (value != null) {
                _updateOffset(value);
              }
            },
          ),
          RadioListTile<int>(
            title: const Text('5 dakika sonra'),
            value: 5,
            groupValue: _offset,
            onChanged: (value) {
              if (value != null) {
                _updateOffset(value);
              }
            },
          ),
          SwitchListTile(
            title: const Text("Sessiz Bildirim"),
            subtitle: const Text("Ezan sesi olmadan bildirim gelsin"),
            value: _isSilent,
            onChanged: (val) async {
              await SettingsService.setSilentNotification(val);
              setState(() => _isSilent = val);
            },
          ),
          ListTile(
            title: const Text("Tema Seçimi"),
            subtitle: const Text("Uygulama görünümünü seçin"),
            trailing: Consumer<ThemeProvider>(
              builder: (context, provider, _) {
                return DropdownButton<ThemeMode>(
                  value: provider.themeMode,
                  onChanged: (mode) {
                    if (mode != null) {
                      provider.setThemeMode(mode);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text("Sistem Varsayılanı")),
                    DropdownMenuItem(
                        value: ThemeMode.light, child: Text("Aydınlık")),
                    DropdownMenuItem(
                        value: ThemeMode.dark, child: Text("Karanlık")),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
