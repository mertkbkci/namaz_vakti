

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/dua_model.dart';
import '../provider/dua_provider.dart';
import 'package:lottie/lottie.dart';

class DuaPage extends StatelessWidget {
  const DuaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DuaProvider()..loadDuaList(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text("Günün Duası",
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        body: Consumer<DuaProvider>(
          builder: (context, provider, _) {
            if (provider.currentDua == null) {
              return  Center(child: Lottie.asset("assets/lottie/loading.json"));
            }

            final DuaModel dua = provider.currentDua!;

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.menu_book, size: 64, color: Colors.blue,),
                  const SizedBox(height: 20),
                  Text(
                    '"${dua.text}"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    dua.reference,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => provider.nextDua(),
                    icon: const Icon(Icons.refresh),
                    label: const Text("Sonraki Dua"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

