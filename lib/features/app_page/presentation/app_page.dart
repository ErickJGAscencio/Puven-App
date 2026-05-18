import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localix/data/database.dart';
import 'package:localix/features/home/presentation/home_page.dart';
import 'package:localix/features/login/presentation/login_page.dart';
import 'package:localix/features/my_products/presentation/my_products_page.dart';
import 'package:localix/features/sales_history/presentation/sales_history_page.dart';
import 'package:localix/features/stadistics/statistics_page.dart';
import 'package:localix/helpers/cash_service.dart';
import 'package:localix/widgets/app_drawer.dart';

enum PuventColors {
  primaryGreen,
  accentBlue,
  warningRed,
  neutralGray,
  primaryGreyText,
  background,
}

extension PuventColorsExtension on PuventColors {
  Color get color {
    switch (this) {
      case PuventColors.primaryGreen:
        return const Color(0xFF00B982);
      case PuventColors.accentBlue:
        return const Color(0xFF2196F3);
      case PuventColors.warningRed:
        return const Color(0xFFF44336);
      case PuventColors.neutralGray:
        return const Color(0xFF9E9E9E);
      case PuventColors.primaryGreyText:
        return const Color(0xFF6C718F);
      case PuventColors.background:
        return const Color(0xffF5F7FA);
    }
  }
}

class AppPage extends StatefulWidget {
  final AppDatabase database;
  const AppPage({super.key, required this.database});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int currentIndex = 1;
  late final AppDatabase database;

  bool isCashOpen = false;
  bool isLoadingCash = true;

  @override
  void initState() {
    super.initState();
    database = widget.database;

    _loadCashSessionState();
  }

  Future<void> _loadCashSessionState() async {
    // Usar el nuevo método de validación que considera múltiples casos
    final validation = await CashService.validateCashSessionState(database);
    final cashOpen = await CashService.isOpen();

    if (validation != null && validation.hasPendingSession) {
      // Mostrar diálogo apropiado según el tipo de sesión pendiente
      final shouldContinue = await _showPendingSessionDialog(validation);

      if (shouldContinue) {
        // Actualizar la última interacción al reanudar
        await CashService.updateLastInteraction(database);
        await database.updateCashSessionType(
          validation.cashSessionId,
          "none"
        );

        setState(() {
          isCashOpen = cashOpen;
        });
        CashService.monitorCashSession(database);
      } else {
        // Cerrar la caja
        await CashService.closeCash(database);
        setState(() {
          isCashOpen = false;
        });
      }
    } else {
      CashService.monitorCashSession(database);
      setState(() {
        isCashOpen = cashOpen;
      });
    }
  }

  void _onSelect(int index) {
    Navigator.pop(context);

    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // El orden en que estén los widgets es el orden en que se definen en AppDrawer
    final pages = [
      LoginPage(),
      HomePage(database: database, isCashOpen: isCashOpen),
      MyProductsPage(database: database),
      StatisticsPage(database: database),
      SalesHistoryPage(database: database),
    ];

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: currentIndex == 0 ? Colors.white : Colors.black87,
        ),
        title: Text(
          "Puven",
          style: TextStyle(
            color: currentIndex == 0 ? Colors.white : Colors.black87,
          ),
        ),
        backgroundColor: currentIndex == 0
            ? PuventColors.primaryGreen.color
            : PuventColors.background.color,
        animateColor: false, //
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (currentIndex == 1)
            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 17),child: ElevatedButton(
              onPressed: () {
                isCashOpen ? _closeCashDialog() : _openCashDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isCashOpen
                    ? Colors.red
                    : PuventColors.primaryGreen.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                isCashOpen ? "Cerrar caja" : "Abrir caja",
                style: const TextStyle(color: Colors.white),
              ),
            ))
        ],
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      drawer: AppDrawer(currentIndex: currentIndex, onItemSelected: _onSelect),
      body: pages[currentIndex],
    );
  }

  void _openCashDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Abrir caja",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: PuventColors.primaryGreen.color,
                      ),
                    ),
                    Icon(
                      Icons.lock_open,
                      color: PuventColors.primaryGreen.color,
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Divider(),

                const SizedBox(height: 10),

                // INPUT
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Monto inicial",
                    prefixIcon: Icon(Icons.attach_money),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // BOTONES
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancelar"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PuventColors.primaryGreen.color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            final initialAmount =
                                double.tryParse(controller.text) ??
                                0; // Obtenemos el monto inicial indicado
                            await CashService.openCash(database, initialAmount);

                            setState(() {
                              isCashOpen = true;
                            });
                          } catch (e) {
                            print("Error al abrir la caja:  $e");
                          }

                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Abrir",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _closeCashDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Cerrar caja",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Icon(Icons.lock, color: Colors.red),
                  ],
                ),

                const SizedBox(height: 10),
                Divider(),

                const SizedBox(height: 10),

                // MENSAJE
                Text(
                  "¿Estás seguro de que quieres cerrar la caja?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 20),

                // BOTONES
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancelar"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          await CashService.closeCash(database);

                          setState(() {
                            isCashOpen = false;
                          });

                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cerrar",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _showPendingSessionDialog(CashSessionValidation validation) {
    final titleMap = {
      'forced': 'App se cerró inesperadamente',
      'another_day': 'Caja abierta desde otro día',
      'inactivity': 'Inactividad detectada',
      'temporal': 'Sesión temporal pendiente',
    };

    final title = titleMap[validation.closeReason] ?? 'Sesión pendiente';
    final color = validation.closeReason == 'forced' ? Colors.red : PuventColors.primaryGreen.color;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                    Icon(
                      validation.closeReason == 'forced'
                          ? Icons.warning_rounded
                          : validation.closeReason == 'another_day'
                              ? Icons.calendar_today
                              : Icons.phone_android,
                      color: color,
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Divider(),

                const SizedBox(height: 10),

                // MENSAJE
                Text(
                  validation.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                  maxLines: 5,
                  softWrap: true,
                ),

                const SizedBox(height: 10),
                Divider(),

                // INFORMACIÓN ADICIONAL
                Text(
                  validation.closeReason == 'forced'
                      ? "Considera que CERRAR, terminará con la sesión actual."
                      : "Considera que CERRAR, terminará con la sesión actual y CONTINUAR, reanudará la sesión.",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  maxLines: 3,
                  softWrap: true,
                ),

                const SizedBox(height: 20),

                // BOTONES
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cerrar Caja"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          "Continuar",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) => value ?? false);
  }

}
