import 'package:flutter/material.dart';
import 'package:localix/data/database.dart';
import 'package:localix/features/app_page/presentation/app_page.dart';

class MyApp extends StatelessWidget {
  final AppDatabase database;
  const MyApp({super.key, required this.database});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Punto de Venta',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: AppPage(database: database),
    );
  }
}