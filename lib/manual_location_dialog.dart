import 'package:flutter/material.dart';

class ManualLocationDialog extends StatefulWidget {
  const ManualLocationDialog({super.key});

  @override
  State<ManualLocationDialog> createState() => _ManualLocationDialogState();
}

class _ManualLocationDialogState extends State<ManualLocationDialog> {
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Manuel Konum Gir"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _latController,
            decoration: const InputDecoration(labelText: 'Enlem'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _lngController,
            decoration: const InputDecoration(labelText: 'Boylam'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("İptal"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text("Kaydet"),
          onPressed: () {
            final lat = double.tryParse(_latController.text);
            final lng = double.tryParse(_lngController.text);
            if (lat != null && lng != null) {
              Navigator.pop(context, (lat, lng));
            }
          },
        ),
      ],
    );
  }
}
