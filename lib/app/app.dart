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
    // if (state == AppLifecycleState.detached || state == AppLifecycleState.inactive) {
    //   await CashService.markForcedClosure(database);
    // }
    switch (state) {
      case AppLifecycleState.resumed:
        // La app vuelve al primer plano
        debugPrint("App reanudada");
        await CashService.notifyPendingSessionState(database);
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        //  App en segundo plano o vista de apps recientes
        debugPrint("App en segundo plano, no marcar forced");
        break;

      case AppLifecycleState.detached:
        // App realmente cerrada (proceso terminado)
        if (await CashService.isOpen()) {
          await CashService.markForcedClosure(database);
          debugPrint("App cerrada completamente, marcado como forced");
        }
        break;
      case AppLifecycleState.hidden:
        // App oculta (en Android, cuando se muestra la vista de apps recientes)
        debugPrint("App oculta, no marcar forced");
        break;
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
