import 'package:localix/data/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:shared_preferences/shared_preferences.dart';

class CashService {
  static const _isOpenKey = "cash_open";
  static const _initialKey = "cash_initial";

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
    final difference = now.difference(cashSession.lastInteraction);
    final daysDifference = now.difference(cashSession.openedAt).inDays;

    // Caso: Cierre forzoso (crash de app)
    if (cashSession.type == "forced") {
      return CashSessionValidation(
        hasPendingSession: true,
        type: "forced",
        message:
            "La aplicación se cerró inesperadamente. La caja está abierta desde ${_formatDateTime(cashSession.openedAt)}",
        canResume: true,
      );
    }

    // Caso: Caja abierta desde otro día
    if (daysDifference > 0) {
      return CashSessionValidation(
        hasPendingSession: true,
        type: "another_day",
        message:
            "La caja está abierta desde ${_formatDateTime(cashSession.openedAt)} (hace $daysDifference día(s))",
        canResume: true,
      );
    }

    // Caso: Inactividad > 30 minutos
    if (difference.inMinutes >= 30 && cashSession.type != "temporal") {
      return CashSessionValidation(
        hasPendingSession: true,
        type: "inactivity",
        message:
            "Inactividad detectada por más de 30 minutos. Bloqueamos el Punto de Venta por seguridad.",
        canResume: true,
      );
    }

    // Caso: Sesión normal
    if (cashSession.type == "temporal") {
      return CashSessionValidation(
        hasPendingSession: true,
        type: "temporal",
        message: "Hay una sesión temporal pendiente",
        canResume: true,
      );
    }

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
          type: drift.Value('forzoso'),
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
}

/// Clase para encapsular la validación de estado de sesión de caja
class CashSessionValidation {
  final bool hasPendingSession;
  final String type; // "forced", "another_day", "inactivity", "temporal"
  final String message;
  final bool canResume;

  CashSessionValidation({
    required this.hasPendingSession,
    required this.type,
    required this.message,
    required this.canResume,
  });
}
