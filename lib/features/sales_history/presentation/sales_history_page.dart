import 'package:flutter/material.dart';
import 'package:localix/features/app_page/presentation/app_page.dart';
import 'package:localix/widgets/pill.dart';

class SalesHistoryPage extends StatefulWidget {
  const SalesHistoryPage({super.key});

  @override
  State<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends State<SalesHistoryPage> {
  final List<Map<String, dynamic>> sales = [
    {
      "id": 1,
      "date": "11 Mayo 2026 - 10:45 AM",
      "total": 320.00,
      "expanded": false,
      "products": [
        {"name": "Hamburguesa Doble", "qty": 2, "total": 180.00},
        {"name": "Papas Grandes", "qty": 1, "total": 70.00},
        {"name": "Coca Cola", "qty": 2, "total": 70.00},
      ],
    },
    {
      "id": 2,
      "date": "10 Mayo 2026 - 08:20 PM",
      "total": 145.00,
      "expanded": false,
      "products": [
        {"name": "Pizza Personal", "qty": 1, "total": 145.00},
      ],
    },
  ];

  String _searchValue = "";

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

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Pill(
                      icon: Icons.receipt_long,
                      label: "Historial",
                    ),

                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      _openFilterModal();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.tune, size: 18),

                          SizedBox(width: 6),

                          Text(
                            "Filtrar",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SearchBar(
                elevation: const WidgetStatePropertyAll(1),
                leading: const Icon(Icons.search),
                hintText: "Buscar venta o producto",
                backgroundColor: const WidgetStatePropertyAll(Colors.white),
                onTapOutside: (_) {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) {
                  setState(() {
                    _searchValue = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: sales.length,
                  itemBuilder: (context, index) {
                    final sale = sales[index];

                    return _buildSaleCard(
                      sale: sale,
                      onTap: () {
                        setState(() {
                          sale["expanded"] = !sale["expanded"];
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaleCard({
    required Map<String, dynamic> sale,
    required VoidCallback onTap,
  }) {
    final bool expanded = sale["expanded"];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          /// HEADER VENTA
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.receipt_long, color: PuventColors.primaryGreen.color),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sale["date"],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "${sale["products"].length} productos",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "\$${sale["total"].toStringAsFixed(2)}",
                        style: TextStyle(
                          color: PuventColors.primaryGreen.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Icon(
                        expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// PRODUCTOS
          if (expanded)
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Column(
                children: List.generate(sale["products"].length, (i) {
                  final product = sale["products"][i];

                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.fastfood,
                            color: Colors.orange,
                            size: 18,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product["name"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                "Cantidad: ${product["qty"]}",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Text(
                          "\$${product["total"].toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  void _openFilterModal() {
  String selectedFilter = "Hoy";

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {

          final filters = [
            "Hoy",
            "Ayer",
            "7 días",
            "30 días",
            "Personalizado",
          ];

          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HANDLE
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// TITLE
                const Text(
                  "Filtrar historial",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Selecciona un rango de fechas para visualizar las ventas.",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 20),

                /// FILTER OPTIONS
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: filters.map((filter) {

                    final bool isSelected =
                        selectedFilter == filter;

                    return GestureDetector(
                      onTap: () {
                        setModalState(() {
                          selectedFilter = filter;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? PuventColors.primaryGreen.color
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isSelected
                                ? PuventColors.primaryGreen.color
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                /// CUSTOM DATE RANGE
                if (selectedFilter == "Personalizado")
                  Column(
                    children: [

                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Fecha inicio",
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onTap: () async {

                          /// OPEN DATE PICKER
                        },
                      ),

                      const SizedBox(height: 14),

                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Fecha fin",
                          prefixIcon: const Icon(Icons.calendar_month),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onTap: () async {
                          /// OPEN DATE PICKER
                        },
                      ),
                    ],
                  ),

                const SizedBox(height: 28),

                /// BUTTONS
                Row(
                  children: [

                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text("Cancelar"),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {

                          /// APPLY FILTERS

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PuventColors.primaryGreen.color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text("Aplicar"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
              ],
            ),
          );
        },
      );
    },
  );
}
}
