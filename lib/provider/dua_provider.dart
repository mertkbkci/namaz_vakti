import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../model/dua_model.dart';

class DuaProvider extends ChangeNotifier {
  List<DuaModel> _duas = [];
  DuaModel? _currentDua;

  List<DuaModel> get duas => _duas;
  DuaModel? get currentDua => _currentDua;

  Future<void> loadDuaList() async {
    final raw = await rootBundle.loadString('assets/dua_list.json');
    final List<dynamic> jsonList = jsonDecode(raw);

    _duas = jsonList.map((e) => DuaModel.fromJson(e)).toList();
    _currentDua = _getRandomDua();
    notifyListeners();
  }

  DuaModel _getRandomDua() {
    final random = Random();
    return _duas[random.nextInt(_duas.length)];
  }

  void nextDua() {
    _currentDua = _getRandomDua();
    notifyListeners();
  }
}
