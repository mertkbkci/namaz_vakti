class PrayersTimeModel {
  Place place;
  Map<String, List<String>> times;

  PrayersTimeModel({required this.place, required this.times});

  factory PrayersTimeModel.fromJson(Map<String, dynamic> json) {
    return PrayersTimeModel(
      place: Place.fromJson(json['place']),
      times: Map<String, List<String>>.from(json['times'].map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      )),
    );
  }
}

class Place {
  String country;
  int id;
  String name;
  String countryCode;
  String stateName;
  double latitude;
  double longitude;
  List<String> alternativeNames;

  Place({
    required this.country,
    required this.id,
    required this.name,
    required this.countryCode,
    required this.stateName,
    required this.latitude,
    required this.longitude,
    required this.alternativeNames,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      country: json['country'],
      id: json['id'],
      name: json['name'],
      countryCode: json['countryCode'],
      stateName: json['stateName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      alternativeNames: List<String>.from(json['alternativeNames']),
    );
  }
}
