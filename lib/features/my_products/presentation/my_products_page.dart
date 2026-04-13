import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:localix/data/database.dart';

class MyProductsPage extends StatefulWidget {
  const MyProductsPage({super.key});

  @override
  State<MyProductsPage> createState() => _MyProductsPage();
}

class _MyProductsPage extends State<MyProductsPage> {
  final List<String> sizes = ["Chico", "Mediano", "Grande"];
  final database = AppDatabase();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: "Productos"),
              Tab(text: "Tamaños"),
            ],
          ),
          Expanded(
            child: TabBarView(children: [_productsView(), _SizesView()]),
          ),
        ],
      ),
    );
  }

  Widget _productsView() {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Mis Productos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _openProductModal,
                      icon: const Icon(Icons.add),
                      label: const Text("Nuevo"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(child: _listProducts()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _SizesView() {
    return Expanded(child: Center(child: Text("TAMAÑOS")));
  }

  // ================= LISTA =================
  Widget _listProducts() {
    return StreamBuilder<List<Product>>(
      stream: database.watchProducts(),
      builder: (context, snapshot) {
        final products = snapshot.data ?? [];

        if (products.isEmpty) {
          return const Center(child: Text("No hay productos"));
        }

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (_, i) => _productTile(products[i]),
        );
      },
    );
  }

  // ================= TILE =================
  Widget _productTile(Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.hasSizes
                      ? "Con tamaños"
                      : product.isByGrams
                      ? "Por gramos"
                      : "Precio fijo",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),

            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _openProductModal(product: product),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await database.deleteVariantsByProduct(product.id);
                    await database.deleteProduct(product.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= MODAL =================
  void _openProductModal({Product? product}) {
    final nameController = TextEditingController(text: product?.name ?? "");
    bool hasSizes = product?.hasSizes ?? false;
    bool isByGrams = product?.isByGrams ?? false;
    String simplePrice = "";

    List<Map<String, dynamic>> variants = [
      {"size": "", "price": ""}
    ];

    /*  final priceController = TextEditingController(
      text: product?.price.toString() ?? "",
    );

    String size = product?.size ?? "Chico";*/

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        bool useExisting = false;
        bool hasSizes = false;
        bool isByGrams = false;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product == null ? "Nuevo Producto" : "Editar Producto",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),

                  const SizedBox(height: 16),
                  // Nombre
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Ingrese nombre del producto",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),
                  // switches
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SwitchListTile(
                          value: hasSizes,
                          onChanged: (value) {
                            setModalState(() {
                              hasSizes = value;
                            });
                          },
                          title: const Text(
                            "Tiene tamaños",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: SwitchListTile(
                          value: isByGrams,
                          onChanged: (value) {
                            setModalState(() {
                              isByGrams = value;
                            });
                          },
                          title: const Text(
                            "Venta por gramos",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  if (hasSizes)
                      Column(
                        children: [
                          ...variants.asMap().entries.map((entry) {
                            int i = entry.key;
                            return Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      labelText: "Tamaño",
                                    ),
                                    onChanged: (v) =>
                                        variants[i]["size"] = v,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    keyboardType:
                                        TextInputType.number,
                                    decoration:
                                        const InputDecoration(
                                      labelText: "Precio",
                                    ),
                                    onChanged: (v) =>
                                        variants[i]["price"] = v,
                                  ),
                                ),
                                IconButton(
                                  icon:
                                      const Icon(Icons.delete),
                                  onPressed: () {
                                    setModalState(() {
                                      variants.removeAt(i);
                                    });
                                  },
                                )
                              ],
                            );
                          }),

                          ElevatedButton.icon(
                            onPressed: () {
                              setModalState(() {
                                variants.add(
                                    {"size": "", "price": ""});
                              });
                            },
                            icon: const Icon(Icons.add),
                            label:
                                const Text("Agregar tamaño"),
                          ),
                        ],
                      ),

                    // 🔥 PRECIO SIMPLE
                    if (!hasSizes && !isByGrams)
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Precio",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) => simplePrice = v,
                      ),

                    const SizedBox(height: 20),

                    // GUARDAR
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final name = nameController.text;

                          final productId =
                              await database.insertProduct(
                            ProductsCompanion(
                              name: drift.Value(name),
                              hasSizes:
                                  drift.Value(hasSizes),
                              isByGrams:
                                  drift.Value(isByGrams),
                            ),
                          );

                          // VARIANTES
                          if (hasSizes) {
                            for (var v in variants) {
                              await database.insertVariant(
                                ProductVariantsCompanion(
                                  productId:
                                      drift.Value(productId),
                                  size: drift.Value(v["size"]),
                                  price: drift.Value(
                                    double.tryParse(
                                            v["price"]) ??
                                        0,
                                  ),
                                ),
                              );
                            }
                          } else if (!isByGrams) {
                            // producto simple como variante única
                            await database.insertVariant(
                              ProductVariantsCompanion(
                                productId:
                                    drift.Value(productId),
                                size:
                                    const drift.Value("Único"),
                                price: drift.Value(
                                  double.tryParse(
                                          simplePrice) ??
                                      0,
                                ),
                              ),
                            );
                          }

                          Navigator.pop(context);
                        },
                        child: const Text("Guardar"),
                      ),
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
