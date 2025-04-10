
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:namaz_vakti/provider/yeni/location_provider.dart';
import 'package:namaz_vakti/screens/app_navbar_screen.dart';


import 'package:provider/provider.dart';

class LocationSelectionPage extends StatelessWidget {
  const LocationSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konum Seçimi', style: TextStyle(color: Colors.white)),
      
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: provider.isLoading
          ?  Center(child: Lottie.asset("assets/lottie/loading.json"))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const Text("Ülke Seçin:", style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: provider.selectedCountry,
                    hint: const Text("Ülke seçin"),
                    items: provider.countries.map((e) => DropdownMenuItem(
                      value: e.name,
                      child: Text(e.name),
                    )).toList(),
                    onChanged: (value) async {
                      if (value != null) {
                        await provider.selectCountry(value);
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  const Text("Bölge Seçin:", style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: provider.selectedRegion,
                    hint: const Text("Bölge seçin"),
                    items: provider.regions.map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    )).toList(),
                    onChanged: (value) async {
                      if (value != null) {
                        await provider.selectRegion(value);
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  const Text("Şehir Seçin:", style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: provider.selectedCity,
                    hint: const Text("Şehir seçin"),
                    items: provider.cities.map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    )).toList(),
                    onChanged: (value) async {
                      if (value != null) {
                        await provider.selectCity(value);
                      }
                    },
                  ),
                  const SizedBox(height: 30),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: provider.selectedCity == null
                        ? null
                        : () {
                            Navigator.pushReplacement(context, 
                              MaterialPageRoute(
                                builder: (_) => const AppNavbarScreen(),
                              ),
                            );
                          },
                    icon: const Icon(Icons.check, size: 24, color: Colors.white),
                    label: const Text('Onayla ve Devam Et',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}


