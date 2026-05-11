import 'package:flutter/material.dart';
import 'package:localix/features/app_page/presentation/app_page.dart';
import 'package:localix/widgets/pill.dart';

class SalesHistoryPage extends StatefulWidget {
  const SalesHistoryPage({super.key});

  @override
  State<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends State<SalesHistoryPage> {
  bool _expandedHoy = false;
  bool _expandedJueves = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PuventColors.background.color,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Historial de Ventas",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Pill(label: "Historial"),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    child: InkWell(
                      child: Row(
                        children: const [
                          Icon(Icons.calendar_month),
                          SizedBox(width: 5),
                          Text("Filtrar"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SearchBar(
                leading: const Icon(Icons.search),
                hintText: "Buscar por # venta, cliente, producto",
              ),
              const SizedBox(height: 10),
                          // 
              SingleChildScrollView(
                child: Column(
                  children: [
                    _buildExpandableCard(
                      title: "Hoy",
                      total: 213.00,
                      expanded: _expandedHoy,
                      onTap: () => setState(() => _expandedHoy = !_expandedHoy),
                      ventas: const ["Venta A", "Venta B"],
                    ),
                    const SizedBox(height: 10),
                    _buildExpandableCard(
                      title: "Jueves, 7 de mayo",
                      total: 350.00,
                      expanded: _expandedJueves,
                      onTap: () =>
                          setState(() => _expandedJueves = !_expandedJueves),
                      ventas: const ["Venta C", "Venta D"],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableCard({
    required String title,
    required double total,
    required bool expanded,
    required VoidCallback onTap,
    required List<String> ventas,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.folder, color: Colors.green),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$${total.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
              trailing: Icon(expanded ? Icons.expand_less : Icons.expand_more),
            ),
            if (expanded)
              Column(
                children: ventas.map((v) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.subdirectory_arrow_right),
                      title: Text(v),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
