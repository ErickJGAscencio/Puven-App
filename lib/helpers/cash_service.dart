import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:localix/data/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:localix/data/tables/cash_sesion.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CashService {
  static const _isOpenKey = "cash_open";
  static const _initialKey = "cash_initial";
  static Timer? _cashMonitorTimer;
  static final ValueNotifier<CashSessionValidation?> pendingSessionNotifier =
      ValueNotifier<CashSessionValidation?>(null);

  static Future<void> notifyPendingSessionState(AppDatabase database) async {
    pendingSessionNotifier.value = await validateCashSessionState(database);
  }

  // Funcion para abrir la caja para empezar a registrar ventas.
  static Future<void> openCash(
    AppDatabase database,
    double openingAmount,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isOpenKey, true);
    //await prefs.setDouble(_initialKey, openingAmount);

    await database.insertCashSession(
      CashSessionsCompanion(
        lastInteraction: drift.Value(DateTime.now()),
        openedAt: drift.Value(DateTime.now()),
        openedBy: drift.Value("USUARIO"),
        openingAmount: drift.Value(openingAmount),
      ),
    );

    monitorCashSession(database); // Iniciamos el monitor solo cuando hay una caja abierta
  }

  static Future<void> closeCash(AppDatabase database) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isOpenKey, false);
    await prefs.remove(_initialKey);

    final cashSession = await database.getCashSessionOpened();
    final orders = await database.getOrdersByDay(DateTime.now());

    if (cashSession != null) {
      // expectedCash = solo las ventas (sin monto inicial)
      // closingAmount = monto inicial + ventas

      double totalSales = 0.0;
      for (Order order in orders) {
        totalSales += order.totalAmount;
      }

      // El monto esperado es solo las ventas
      double expectedCash = totalSales;

      // El monto final es el monto inicial + todas las ventas
      double closingAmount = cashSession.openingAmount + totalSales;

      await database.closeCashSession(
        cashSession.cashSesionId, // id de la sesión
        "Erick", // TODO: Obtener el usuario actual del contexto/autenticación
        closingAmount, // Monto final total (inicial + ventas)
        expectedCash, // Solo las ventas, sin monto inicial
        "closed", // Cambiar el estado de la caja a cerrado
        "normal", // Tipo de cierre normal
      );
    }

    _cashMonitorTimer?.cancel();
    _cashMonitorTimer = null;
  }

  static Future<bool> isOpen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isOpenKey) ?? false;
  }

  /// Actualiza la última interacción con la caja
  /// Debe llamarse cada vez que hay actividad del usuario
  static Future<void> updateLastInteraction(AppDatabase database) async {
    final cashSession = await database.getCashSessionOpened();
    if (cashSession != null) {
      await database.updateLastInteraction(cashSession.cashSesionId);
    }
  }

  /// Marca la sesión como "temporal" cuando detecta inactividad > 30 minutos
  static Future<void> markAsTemporalInactivity(AppDatabase database) async {
    final cashSession = await database.getCashSessionOpened();
    if (cashSession != null) {
      await database.updateCashSessionType(
        cashSession.cashSesionId,
        "temporal",
      );
    }
  }

  /// Valida el estado de la caja considerando múltiples casos:
  /// 1. Si está abierta desde otro día
  /// 2. Si tiene inactividad > 30 min
  /// 3. Si fue cerrada inesperadamente (tipo "forced")
  /// Retorna información sobre el estado para mostrar el diálogo apropiado
  static Future<CashSessionValidation?> validateCashSessionState(
    AppDatabase database,
  ) async {
    final cashSession = await database.getLatestOpenCashSession();

    if (cashSession == null) {
      return null; // No hay caja abierta
    }

    final now = DateTime.now();
    final daysDifference = now.difference(cashSession.openedAt).inDays;

    // Caso: Cierre forzoso (crash de app)
    if (cashSession.closeReason == "forced") {
      return CashSessionValidation(
        cashSessionId: cashSession.cashSesionId,
        hasPendingSession: true,
        closeReason: CloseReason.forced,
        message:
            "La aplicación se cerró inesperadamente. La caja está abierta desde ${_formatDateTime(cashSession.openedAt)}",
        canResume: true,
      );
    }

    // Caso: Caja abierta desde otro día
    if (cashSession.closeReason == CloseReason.dayClosed.name) {
      return CashSessionValidation(
        cashSessionId: cashSession.cashSesionId,
        hasPendingSession: true,
        closeReason: CloseReason.dayClosed,
        message:
            "La caja está abierta desde ${_formatDateTime(cashSession.openedAt)} (hace $daysDifference día(s))",
        canResume: true,
      );
    }

    // Caso: Inactividad > 30 minutos
    if (cashSession.closeReason == CloseReason.inactivity.name) {
      return CashSessionValidation(
        cashSessionId: cashSession.cashSesionId,
        hasPendingSession: true,
        closeReason: CloseReason.inactivity,
        message:
            "Inactividad detectada por más de 30 minutos. Bloqueamos el Punto de Venta por seguridad.",
        canResume: true,
      );
    }

    // Caso: Sesión normal
    // if (cashSession.closeReason == "temporal") {
    //   return CashSessionValidation(
    //     cashSessionId: cashSession.cashSesionId,
    //     hasPendingSession: true,
    //     closeReason: "temporal",
    //     message: "Hay una sesión temporal pendiente",
    //     canResume: true,
    //   );
    // }

    return null; // Todo normal
  }

  static Future<double> getInitialAmount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_initialKey) ?? 0;
  }

  static Future<String> generateFolio() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    final dateKey = "${now.year}${now.month}${now.day}";
    final lastDate = prefs.getString("folio_date");

    int counter = 1;

    if (lastDate == dateKey) {
      counter = (prefs.getInt("folio_counter") ?? 0) + 1;
    }

    await prefs.setString("folio_date", dateKey);
    await prefs.setInt("folio_counter", counter);

    return "${now.year.toString().substring(2)}"
        "${now.month.toString().padLeft(2, '0')}"
        "${now.day.toString().padLeft(2, '0')}-"
        "${counter.toString().padLeft(3, '0')}";
  }

  static Future<void> markForcedClosure(AppDatabase database) async {
    final session = await database.getCashSessionOpened();
    if (session != null) {
      await (database.update(
        database.cashSessions,
      )..where((tbl) => tbl.cashSesionId.equals(session.cashSesionId))).write(
        CashSessionsCompanion(
          closeReason: drift.Value('forced'),
          closedAt: drift.Value(DateTime.now()),
        ),
      );
    }
  }

  /// Formatea una fecha para mostrar al usuario
  /// Ejemplo: "22 de mayo de 2026 a las 14:30"
  static String _formatDateTime(DateTime date) {
    final monthNames = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return "${date.day} de ${monthNames[date.month - 1]} de ${date.year} a las $hour:$minute";
  }

  static void monitorCashSession(AppDatabase database){
    Timer.periodic(const Duration(minutes: 5), (timer) async  {
      final session = await database.getCashSessionOpened();
      if(session!= null){
        final now = DateTime.now();
        final diff = now.difference(session.lastInteraction);

        if(diff.inMinutes >= 30 && diff.inHours < 24){
          await database.updateCashSessionType(
            session.cashSesionId,
            CloseReason.inactivity.name,
          );
          await notifyPendingSessionState(database);
        } else if(diff.inHours >= 24){
          await database.updateCashSessionType(
            session.cashSesionId,
            CloseReason.dayClosed.name,
          );
          await notifyPendingSessionState(database);
        } else {
          pendingSessionNotifier.value = null;
        }
      }else{
        pendingSessionNotifier.value = null;
        timer.cancel(); // Detiene el monitoreo si no hay caja abierta
      }
    });
  }
}

/// Clase para encapsular la validación de estado de sesión de caja
class CashSessionValidation {
  final int cashSessionId;
  final bool hasPendingSession;
  final CloseReason closeReason; // CloseReason enum values
  final String message;
  final bool canResume;

  CashSessionValidation({
    required this.cashSessionId,
    required this.hasPendingSession,
    required this.closeReason,
    required this.message,
    required this.canResume,
  });
}
