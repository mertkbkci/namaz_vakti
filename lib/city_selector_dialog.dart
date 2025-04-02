
import 'package:flutter/material.dart';
import 'package:namaz_vakti/settings_service.dart';

class CitySelectorDialog extends StatefulWidget {
  const CitySelectorDialog({super.key});

  @override
  State<CitySelectorDialog> createState() => _CitySelectorDialogState();
}

class _CitySelectorDialogState extends State<CitySelectorDialog> {
  final List<String> _allCities = [
    "Adana",
    "Adıyaman",
    "Afyonkarahisar",
    "Ağrı",
    "Aksaray",
    "Amasya",
    "Ankara",
    "Antalya",
    "Ardahan",
    "Artvin",
    "Aydın",
    "Balıkesir",
    "Bartın",
    "Batman",
    "Bayburt",
    "Bilecik",
    "Bingöl",
    "Bitlis",
    "Bolu",
    "Burdur",
    "Bursa",
    "Çanakkale",
    "Çankırı",
    "Çorum",
    "Denizli",
    "Diyarbakır",
    "Düzce",
    "Edirne",
    "Elazığ",
    "Erzincan",
    "Erzurum",
    "Eskişehir",
    "Gaziantep",
    "Giresun",
    "Gümüşhane",
    "Hakkari",
    "Hatay",
    "Iğdır",
    "Isparta",
    "İstanbul",
    "İzmir",
    "Kahramanmaraş",
    "Karabük",
    "Karaman",
    "Kars",
    "Kastamonu",
    "Kayseri",
    "Kırıkkale",
    "Kırklareli",
    "Kırşehir",
    "Kilis",
    "Kocaeli",
    "Konya",
    "Kütahya",
    "Malatya",
    "Manisa",
    "Mardin",
    "Mersin",
    "Muğla",
    "Muş",
    "Nevşehir",
    "Niğde",
    "Ordu",
    "Osmaniye",
    "Rize",
    "Sakarya",
    "Samsun",
    "Siirt",
    "Sinop",
    "Sivas",
    "Şanlıurfa",
    "Şırnak",
    "Tekirdağ",
    "Tokat",
    "Trabzon",
    "Tunceli",
    "Uşak",
    "Van",
    "Yalova",
    "Yozgat",
    "Zonguldak",
  ];
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favs = await SettingsService.getFavoriteCities();
    setState(() {
      _favorites = favs;
    });
  }

  Future<void> _toggleFavorite(String city) async {
    if (_favorites.contains(city)) {
      await SettingsService.removeFavoriteCity(city);
    } else {
      await SettingsService.addFavoriteCity(city);
    }
    _loadFavorites();
  }

  Widget _buildCityTile(String city) {
    final isFav = _favorites.contains(city);
    return ListTile(
      title: Text(city),
      trailing: IconButton(
        icon: Icon(isFav ? Icons.star : Icons.star_border, color: Colors.amber),
        onPressed: () => _toggleFavorite(city),
      ),
      onTap: () => Navigator.pop(context, city),
    );
  }

  @override
  Widget build(BuildContext context) {
    final remaining =
        _allCities.where((city) => !_favorites.contains(city)).toList();

    return AlertDialog(
      title: const Text('Şehir Seç'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            if (_favorites.isNotEmpty) ...[
              const Text("⭐ Favoriler",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              ..._favorites.map(_buildCityTile),
              const SizedBox(height: 16),
            ],
            const Text("📍 Diğer Şehirler",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            ...remaining.map(_buildCityTile),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
      ],
    );
  }
}
