import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:localix/data/database.dart';

class MyProductsPage extends StatefulWidget {
  final AppDatabase database;
  const MyProductsPage({super.key, required this.database});

  @override
  State<MyProductsPage> createState() => _MyProductsPage();
}

enum ColorLabel {
  blue('Blue', Colors.blue),
  pink('Pink', Colors.pink),
  green('Green', Colors.green),
  yellow('Orange', Colors.orange),
  grey('Grey', Colors.grey);

  const ColorLabel(this.label, this.color);
  final String label;
  final Color color;
}

class _MyProductsPage extends State<MyProductsPage> {
  late final AppDatabase database;
  late Future<List<ProductSize>> sizesFuture;

  @override
  void initState() {
    super.initState();
    database = widget.database;
    sizesFuture = database.getAllSizes();
  }

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
                      "Tamaños Disponibles",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _openSizeModal,
                      icon: const Icon(Icons.add),
                      label: const Text("Nuevo"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(child: _listSizes()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= LISTA =================
  Widget _listProducts() {
    return StreamBuilder<List<Product>>(
      stream: database.watchProducts(),
      builder: (context, snapshot) {
        final products = snapshot.data ?? [];

        print(products);

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

  Widget _listSizes() {
    return StreamBuilder<List<ProductSize>>(
      stream: database.watchSizes(),
      builder: (context, snapshot) {
        final sizes = snapshot.data ?? [];

        if (sizes.isEmpty) {
          return const Center(child: Text("No hay tamaños"));
        }

        return ListView.builder(
          itemCount: sizes.length,
          itemBuilder: (_, i) => _productSizeTile(sizes[i]),
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

  Widget _productSizeTile(ProductSize sizes) {
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
                  sizes.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _openSizeModal(size: sizes),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await database.deleteVariantsByProduct(sizes.id);
                    await database.deleteProduct(sizes.id);
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
    final pricePerKgController = TextEditingController();
    bool hasSizes = product?.hasSizes ?? false;
    bool isByGrams = product?.isByGrams ?? false;
    String simplePrice = "";

    List<Map<String, dynamic>> variants = [
      {"size": "", "price": ""},
    ];
    final sizesStream = database.watchSizes();
    /*  final priceController = TextEditingController(
      text: product?.price.toString() ?? "",
    );

    String size = product?.size ?? "Chico";*/

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StreamBuilder<List<ProductSize>>(
          stream: sizesStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final sizes = snapshot.data ?? [];
            return StatefulBuilder(
              builder: (context, setModalState) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          product == null
                              ? "Añadir Nuevo Producto"
                              : "Editar Producto",
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
                                onChanged: isByGrams
                                    ? null
                                    : (value) {
                                        setModalState(() {
                                          hasSizes = value;
                                        });
                                      },
                                title: const Text(
                                  "Tamaños",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: SwitchListTile(
                                value: isByGrams,
                                onChanged: hasSizes
                                    ? null
                                    : (value) {
                                        setModalState(() {
                                          isByGrams = value;
                                        });
                                      },
                                title: const Text(
                                  "Gramaje",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        if (isByGrams)
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                              children: [
                                TextSpan(
                                  text: "El precio final se calcula en ",
                                ),
                                TextSpan(
                                  text: "Punto de Venta.",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        if (hasSizes)
                          Column(
                            children: [
                              ...variants.asMap().entries.map((entry) {
                                int i = entry.key;
                                return Row(
                                  children: [
                                    Expanded(
                                      child: DropdownMenu<String>(
                                        initialSelection: variants[i]["size"],
                                        onSelected: (v) =>
                                            variants[i]["size"] = v ?? "",
                                        dropdownMenuEntries: sizes
                                            .map(
                                              (s) => DropdownMenuEntry(
                                                value: s.name,
                                                label: s.name,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: "Precio",
                                        ),
                                        onChanged: (v) =>
                                            variants[i]["price"] = v,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setModalState(() {
                                          variants.removeAt(i);
                                        });
                                      },
                                    ),
                                  ],
                                );
                              }),

                              ElevatedButton.icon(
                                onPressed: () {
                                  setModalState(() {
                                    variants.add({"size": "", "price": ""});
                                  });
                                },
                                icon: const Icon(Icons.add),
                                label: const Text("Agregar tamaño"),
                              ),
                            ],
                          ),

                        const SizedBox(height: 10),
                        // PRECIO SIMPLE
                        if (!hasSizes)
                          TextField(
                            controller: pricePerKgController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: isByGrams
                                  ? "Ingrese precio por Kilo"
                                  : "Precio",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (v) => simplePrice = v,
                          ),

                        const SizedBox(height: 20),

                        // GUARDAR
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(),
                            onPressed: () async {
                              final name = nameController.text;

                              final productId = await database.insertProduct(
                                ProductsCompanion(
                                  name: drift.Value(name),
                                  hasSizes: drift.Value(hasSizes),
                                  isByGrams: drift.Value(isByGrams),
                                ),
                              );

                              // VARIANTES
                              if (hasSizes) {
                                for (var v in variants) {
                                  await database.insertVariant(
                                    ProductVariantsCompanion(
                                      productId: drift.Value(productId),
                                      size: drift.Value(v["size"]),
                                      price: drift.Value(
                                        double.tryParse(v["price"]) ?? 0,
                                      ),
                                    ),
                                  );
                                }
                              } else if (isByGrams) {
                                await database.insertVariant(
                                  ProductVariantsCompanion(
                                    productId: drift.Value(productId),
                                    size: const drift.Value("GRAMOS"),
                                    pricePerKg: drift.Value(double.tryParse(pricePerKgController.text) ?? 0),
                                  ),
                                );
                              } else {
                                // producto simple como variante única
                                await database.insertVariant(
                                  ProductVariantsCompanion(
                                    productId: drift.Value(productId),
                                    size: const drift.Value("UNICO"),
                                    price: drift.Value(
                                      double.tryParse(simplePrice) ?? 0,
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
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _openSizeModal({ProductSize? size}) {
    final nameController = TextEditingController(text: size?.name ?? "");

    /*  final priceController = TextEditingController(
      text: product?.price.toString() ?? "",
    );

    String size = product?.size ?? "Chico";*/

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
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
                    size == null ? "Añadir Nuevo Tamaño" : "Editar Tamaño",
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
                      labelText: "Ingrese nombre del tamaño",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const SizedBox(height: 20),

                  // GUARDAR
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final name = nameController.text;

                        await database.insertSize(
                          ProductSizesCompanion(name: drift.Value(name)),
                        );
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
