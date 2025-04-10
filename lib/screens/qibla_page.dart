

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:namaz_vakti/provider/qibla_provider.dart';
import 'package:provider/provider.dart';

class QiblaPage extends StatelessWidget {
  const QiblaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QiblaProvider()..init(),
      child: const _QiblaBody(),
    );
  }
}

class _QiblaBody extends StatelessWidget {
  const _QiblaBody();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QiblaProvider>(context);
    final heading = provider.heading ?? 0;
    final qiblaDir = provider.qiblaDirection ?? 0;
    final rotation = (qiblaDir - heading) * (pi / 180);
    final isAligned = (qiblaDir - heading).abs() < 10;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('Kıble Yönü',
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: Column(
      
        children: [
           SizedBox(height:MediaQuery.of(context).size.height * 0.05),
          Center(
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.blue, width: 1),
              ),
              child: Image.asset('assets/kaba.png', width: 80, height: 80),
            ),
          ),
           SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Center(
            child: Transform.rotate(
              angle: rotation,
              child: Card(
                  shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.blue, width: 1),
              ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 30),
                  child: Image.asset(
                    'assets/qibla_arrow.png',
                    width: 200,
                    height: 200,
                    color: isAligned ? Colors.green : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



