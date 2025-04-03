import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:namaz_vakti/screens/dua_page.dart';
import 'package:namaz_vakti/screens/home_screen.dart';
import 'package:namaz_vakti/screens/qibla_page.dart';
import 'package:namaz_vakti/screens/setting_page.dart';


class AppNavbarScreen extends StatelessWidget {
  const AppNavbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Colors.green,
          height: 70,
          child: TabBar(tabs: [
            Tab(icon: Icon(Iconsax.home5, color: Colors.white, size: 30, ),text: "Ana Sayfa",),
            Tab(icon: Icon(Icons.menu_book, color: Colors.white, size: 30),text: "Sözler",),
            Tab(icon: Icon(Icons.explore, color: Colors.white, size: 30),text: "Kıble",),
            Tab(icon: Icon(Iconsax.setting_2, color: Colors.white, size: 30),text: "Ayarlar",),
          ],
          unselectedLabelColor: Colors.white70,
          labelColor: Colors.white,
          indicatorColor: Colors.transparent,
          dividerColor: Colors.transparent,
          ),
        ),
        body: TabBarView(
          children: [
            HomePage(),
            DuaPage(),
            QiblaPage(),
            SettingsPage(),
          ],
        ),
      ),
    );
  }
}
