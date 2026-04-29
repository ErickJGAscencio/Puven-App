import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localix/data/database.dart';
import 'package:localix/features/home/presentation/home_page.dart';
import 'package:localix/features/my_products/presentation/my_products_page.dart';
import 'package:localix/helpers/cash_service.dart';
import 'package:localix/widgets/app_drawer.dart';

enum PuventColors {
  primaryGreen,
  accentBlue,
  warningRed,
  neutralGray,
  primaryGreyText,
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

    _loadCashState();
  }

  Future<void> _loadCashState() async {
    final open = await CashService.isOpen();
    setState(() {
      isCashOpen = open;
    });
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
      HomePage(database: database, isCashOpen: isCashOpen),
      HomePage(database: database, isCashOpen: isCashOpen),
      MyProductsPage(database: database),
    ];

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text("Puven"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          ElevatedButton(
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
          ),
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
                          final amount = double.tryParse(controller.text) ?? 0;

                          await CashService.openCash(amount);

                          setState(() {
                            isCashOpen = true;
                          });

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
                          await CashService.closeCash();

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
}
