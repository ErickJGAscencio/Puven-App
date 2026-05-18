import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localix/data/database.dart';
import 'package:localix/features/app_page/presentation/app_page.dart';
import 'package:localix/helpers/cash_service.dart';

class MyApp extends StatefulWidget {
  final AppDatabase database;
  const MyApp({super.key, required this.database});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late AppDatabase database;

  @override
  void initState() {
    super.initState();
    database = widget.database;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // Detecta cuando la app se suspende o se cierra
    if (state == AppLifecycleState.detached || state == AppLifecycleState.inactive) {
      await CashService.markForcedClosure(database);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Punto de Venta',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: AppPage(database: database),
    );
  }
}
