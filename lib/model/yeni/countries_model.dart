class CountriesModel {
  final String code;
  final String name;

  CountriesModel({
    required this.code,
    required this.name,
  });

  factory CountriesModel.fromJson(Map<String, dynamic> json) {
    return CountriesModel(
      code: json['code'],
      name: json['name'],
    );
  }
}
