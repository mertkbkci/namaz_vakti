import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/dua_model.dart';

class DuaPage extends StatefulWidget {
  const DuaPage({super.key});

  @override
  State<DuaPage> createState() => _DuaPageState();
}

class _DuaPageState extends State<DuaPage> {
  List<DuaModel> _duas = [];
  DuaModel? _currentDua;

  @override
  void initState() {
    super.initState();
    _loadDuaList();
  }

  Future<void> _loadDuaList() async {
    final raw = await rootBundle.loadString('assets/dua_list.json');
    final List<dynamic> jsonList = jsonDecode(raw);

    setState(() {
      _duas = jsonList.map((e) => DuaModel.fromJson(e)).toList();
      _currentDua = _getRandomDua();
    });
  }

  DuaModel _getRandomDua() {
    final random = Random();
    return _duas[random.nextInt(_duas.length)];
  }

  void _nextDua() {
    setState(() {
      _currentDua = _getRandomDua();
    });
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
        title: const Text("Günün Duası",
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: _currentDua == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.menu_book, size: 64, color: Colors.green),
                  const SizedBox(height: 20),
                  Text(
                    '"${_currentDua!.text}"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentDua!.reference,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _nextDua,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Sonraki Dua"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
