class DuaModel {
  final String text;
  final String reference;

  DuaModel({required this.text, required this.reference});

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(
      text: json['text'],
      reference: json['reference'],
    );
  }
}
