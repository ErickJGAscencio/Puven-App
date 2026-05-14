import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localix/data/database.dart';
import 'package:localix/helpers/cash_service.dart';
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

  final database = AppDatabase();

  //Capturamos error de flutter (UI)
  FlutterError.onError = (FlutterErrorDetails details) async {
    await CashService.markForcedClosure(database);
    print('Error capturado: ${details.exception}');
  };

  // Captura errores fuera del framework (asincrónicos)
  PlatformDispatcher.instance.onError = (error, stack) {
    CashService.markForcedClosure(database);
    print('Error global: $error');
    return true; // evita que el error cierre la app inmediatamente
  };

  runApp(MyApp(database: database));
}