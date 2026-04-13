import 'package:flutter/material.dart';
import 'package:localix/data/database.dart';

// ===================== MODEL =====================
class ProductFormModel {
  Product? product;
  String? size;
  double grams;
  bool byGrams;
  double priceByKg;
  double unityPrice;
  int quantity;

  ProductFormModel({
    this.product,
    this.size,
    this.grams = 0.0,
    this.byGrams = false,
    this.priceByKg = 0.0,
    this.unityPrice = 0.0,
    this.quantity = 1,
  });
}

// ===================== UI =====================
class HomePage extends StatefulWidget {
  final AppDatabase database;
  const HomePage({super.key, required this.database});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AppDatabase database;
  final List<ProductFormModel> productForms = [];

  @override
  void initState() {
    super.initState();
    database = widget.database;
    productForms.add(ProductFormModel());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Punto de Venta"),
              Tab(text: "Pedidos"),
            ],
          ),
          Expanded(child: TabBarView(children: [_ventaView(), _pedidosView()])),
        ],
      ),
    );
  }

  // ===================== VENTA =====================
  Widget _ventaView() {
    return StreamBuilder<List<Product>>(
      stream: database.watchProducts(),
      builder: (context, snapshot) {
        final products = snapshot.data ?? [];

        return Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  _headerVenta(),
                  Expanded(
                    child: products.isEmpty
                        ? const Center(child: Text("No hay productos"))
                        : _buildFormList(products),
                  ),
                ],
              ),
            ),
            _actionButtons(),
            _footerSection(),
          ],
        );
      },
    );
  }

  Widget _headerVenta() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Text("Venta", style: TextStyle(fontSize: 18)),
          SizedBox(width: 8),
          Text("·0000001", style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildFormList(List<Product> products) {
    return ListView.builder(
      itemCount: productForms.length,
      itemBuilder: (context, index) {
        return _buildForm(index, products);
      },
    );
  }

  Widget _actionButtons() {
    return Padding(
      padding: const EdgeInsets.all(10),
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
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  productForms.add(ProductFormModel());
                });
              },
              icon: const Icon(Icons.add),
              label: const Text("Añadir producto"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerSection() {
    final total = productForms.fold(
      0.0,
      (sum, form) => sum + _calculateItemTotal(form),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total"),
              Text("\$${total.toStringAsFixed(2)}"),
            ],
          ),
        ],
      ),
    );
  }

  // ===================== FORM =====================
  Widget _buildForm(int index, List<Product> products) {
    final form = productForms[index];

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<Product>(
                    value: form.product,
                    hint: const Text("Seleccionar producto"),
                    items: products.map((p) {
                      return DropdownMenuItem(value: p, child: Text(p.name));
                    }).toList(),
                    onChanged: (p) {
                      if (p == null) return;

                      setState(() {
                        form.product = p;
                        form.size = null;
                        form.byGrams = p.isByGrams;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      if (productForms.length > 1) {
                        productForms.removeAt(index);
                      }
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            if (form.product != null) ...[
              if (form.product!.hasSizes)
                _buildSizes(form)
              else if (form.byGrams)
                StreamBuilder<List<ProductVariant>>(
                  stream: database.watchVariants(form.product!.id),
                  builder: (context, snapshot) {
                    final variants = snapshot.data ?? [];
                    if (variants.isNotEmpty) {
                      // Asigna el precio por kilo de la variante GRAMOS
                      final gramsVariant = variants.firstWhere(
                        (v) => v.size.toUpperCase() == "GRAMOS",
                        orElse: () => variants.first,
                      );
                      form.priceByKg = gramsVariant.pricePerKg ?? 0.0;
                    }

                    return _buildGrams(form);
                  },
                ),
            ],

            const SizedBox(height: 10),

            if (form.product != null && !form.byGrams) _quantityControl(form),

            const SizedBox(height: 10),

            if (form.product != null)
              Text(
                "\$${_calculateItemTotal(form).toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizes(ProductFormModel form) {
    return StreamBuilder<List<ProductVariant>>(
      stream: database.watchVariants(form.product!.id),
      builder: (context, snapshot) {
        final variants = snapshot.data ?? [];

        return DropdownButtonFormField<String>(
          value: form.size,
          hint: const Text("Seleccionar tamaño"),
          items: variants.map((v) {
            return DropdownMenuItem(
              value: v.size,
              child: Text("${v.size} - \$${v.price}"),
            );
          }).toList(),
          onChanged: (v) {
            final variant = variants.firstWhere((element) => element.size == v);

            setState(() {
              form.size = v;
              form.unityPrice = variant.price!;
            });
          },
        );
      },
    );
  }

  Widget _buildGrams(ProductFormModel form) {
    final gramsController = TextEditingController(text: form.grams.toString());

    return Column(
      children: [
        TextField(
          controller: gramsController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Gramos"),
          onChanged: (v) {
            setState(() {
              form.grams = double.tryParse(v) ?? 0;
            });
          },
        ),

        // BOTONES PRE-ESTABLECIDOS
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [250, 500, 1000].map((g) {
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  form.grams = g.toDouble();
                  gramsController.text = g.toString(); // actualiza el input
                });
                _calculateItemTotal(form);
              },
              child: Text(g == 1000 ? "1 kg" : "$g g"),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _quantityControl(ProductFormModel form) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              if (form.quantity > 1) form.quantity--;
            });
          },
          icon: const Icon(Icons.remove),
        ),
        Text("${form.quantity}", style: const TextStyle(fontSize: 18)),
        IconButton(
          onPressed: () {
            setState(() {
              form.quantity++;
            });
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  // ===================== LOGIC =====================
  double _calculateItemTotal(ProductFormModel form) {
    if (form.product == null) return 0;

    if (form.byGrams) {
      return (form.grams * (form.priceByKg / 1000));
    }
    return form.unityPrice * form.quantity;
  }

  // ===================== PEDIDOS =====================
  Widget _pedidosView() {
    return const Center(child: Text("Pedidos"));
  }
}
