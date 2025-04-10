import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';



import 'package:namaz_vakti/provider/qibla_provider.dart';
import 'package:namaz_vakti/provider/settings_provider.dart';
import 'package:namaz_vakti/provider/yeni/location_provider.dart';
import 'package:namaz_vakti/provider/yeni/prayer_times_provider.dart';
import 'package:namaz_vakti/screens/app_navbar_screen.dart';

import 'package:namaz_vakti/screens/location/location_screen.dart';
import 'package:namaz_vakti/services/notification_service.dart';
import 'package:namaz_vakti/provider/theme_provider.dart';
import 'package:namaz_vakti/storage/storage_service.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();


  Intl.defaultLocale = 'tr_TR';
  await initializeDateFormatting('tr_TR', null);

  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

    final savedLocation = await StorageService.getLocation();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: themeProvider,
        ),
        ChangeNotifierProvider(create: (_) => PrayerTimesProvider()),
       ChangeNotifierProvider(
      create: (context) => QiblaProvider()..init(),),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
     
        ChangeNotifierProvider(
          create: (_) => LocationProvider()..loadCountries()..loadSavedLocation(),
         
            
        ),


      ],
      child:  MyApp(savedLocation: savedLocation),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Map<String, dynamic>? savedLocation;
  const MyApp({super.key, this.savedLocation});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      locale: const Locale('tr', 'TR'),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('en', 'US'),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: themeProvider.themeMode,
      home: savedLocation == null
            ? const LocationSelectionPage()
            : const AppNavbarScreen(),
      
    
    );
  }
}
