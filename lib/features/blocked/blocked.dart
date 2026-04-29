import 'package:flutter/material.dart';
// ===================== UI =====================
class Blocked extends StatefulWidget {
  final bool isCashOpen;
  const Blocked({super.key, required this.isCashOpen});

  @override
  State<Blocked> createState() => _BlockedState();
}

class _BlockedState extends State<Blocked> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock, size: 50, color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            "La caja está cerrada",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Text(
            "Abre la caja para comenzar a vender",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
