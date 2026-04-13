import 'package:flutter/material.dart';
import 'package:localix/data/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> sizes = ["Chico", "Mediano", "Grande"];
  List<Product> selectedOptions = List.generate(
    5,
    (_) => Product(id: 1, hasSizes: false, name: "Pipo", isByGrams: false),
  );
  final database = AppDatabase();

@override
Widget build(BuildContext context) {
  return DefaultTabController(
    length: 2,
    child: Column(
      children: [
        // TABBAR (sin AppBar)
        const TabBar(
          tabs: [
            Tab(text: "Venta"),
            Tab(text: "Pedidos"),
          ],
        ),

        // CONTENIDO
        Expanded(
          child: TabBarView(
            children: [
              _ventaView(),
              _pedidosView(),
            ],
          ),
        ),
      ],
    ),
  );
}

  // ===================== VENTA =====================
  Widget _ventaView() {
    return Column(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerVenta(),
              const SizedBox(height: 10),
              Expanded(child: _listProductToSell()),
            ],
          ),
        ),
        _actionButtons(),
        _footerSection(),
      ],
    );
  }

  Widget _headerVenta() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: const [
          Text(
            "Venta",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Text(
            "·0000001",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _listProductToSell() {
    return StreamBuilder<List<Product>>(
      stream: database.watchProducts(),
      builder: (context, snapshot) {
        final products = snapshot.data ?? [];

        if (products.isEmpty) {
          return const Center(child: Text("No hay productos"));
        }

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return _tileProductToSell(products[index]);
          },
        );
      },
    );
  }

  Widget _tileProductToSell(Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // FILA SUPERIOR
            Row(
              children: [
                // Dropdown FULL WIDTH
               /* Expanded(
                  child: DropdownButtonFormField<String>(
                    value: product.size,
                    items: sizes
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      database.updateProduct(product.copyWith(size: value));
                    },
                  ),
                ),*/

                const SizedBox(width: 10),

                // DELETE BUTTON
                Material(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      database.deleteProduct(product.id);
                    },
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.delete_forever, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // FILA INFERIOR
            /*
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // CONTADOR
                Row(
                  children: [
                    _qtyButton(
                      icon: Icons.remove,
                      color: Colors.red,
                      onTap: () {
                        database.updateProduct(
                          product.copyWith(quantity: product.quantity + 1),
                        );
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "${product.quantity}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    _qtyButton(
                      icon: Icons.add,
                      color: Colors.green,
                      onTap: () {
                        database.updateProduct(
                          product.copyWith(quantity: product.quantity + 1),
                        );
                      },
                    ),
                  ],
                ),

                // DROPDOWN TAMAÑO
                SizedBox(
                  width: 120,
                  child: DropdownButtonFormField<String>(
                    value: product.size,
                    decoration: const InputDecoration(
                      labelText: "Tamaño",
                      border: OutlineInputBorder(),
                    ),
                    items: sizes
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      database.updateProduct(product.copyWith(size: value));
                    },
                  ),
                ),

                // PRECIO FORMATEADO
                Text(
                  "10.00",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          */
          ],
        ),
      ),
    );
  }

  Widget _qtyButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }

  Widget _actionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Agregar nota"),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                    
                });
              },
              child: const Text("Agregar producto"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: const Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("\$50.00", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Cancelar"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Finalizar Venta"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===================== PEDIDOS =====================
  Widget _pedidosView() {
    return const Center(child: Text("Pedidos"));
  }
}
