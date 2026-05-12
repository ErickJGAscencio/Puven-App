import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localix/data/database.dart';
import 'app/app.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('es_ES', null);
  
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final db = AppDatabase();
  runApp(MyApp(database: db));
}