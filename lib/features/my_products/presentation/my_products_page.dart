import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:localix/data/database.dart';
import 'package:localix/features/app_page/presentation/app_page.dart';
import 'package:localix/widgets/pill.dart';

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

class VariantForm {
  int? sizeId;
  String price;

  VariantForm({this.sizeId, this.price = ""});
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
          Divider(color: Colors.grey.shade300, height: 1),
          Container(
            color: Colors.white,
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: PuventColors.primaryGreen.color,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              tabs: [
                Tab(
                  text: "Productos",
                  icon: Icon(Icons.inventory)),
                Tab(
                  text: "Tamaños",
                  icon: Icon(Icons.straighten)),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(children: [_productsView(), _sizesView()]),
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
                    Pill(
                      color: PuventColors.primaryGreen.color,
                      label: "Inventario",
                    ),
                    // ElevatedButton.icon(
                    //   onPressed: _openProductModal,
                    //   icon: const Icon(Icons.add),
                    //   label: const Text("Nuevo"),
                    // ),
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        _openProductModal();
                      },
                      splashColor: Colors.white24,
                      highlightColor: Colors.white10,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: PuventColors.primaryGreen.color,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.add, color: Colors.white, size: 20),
                            SizedBox(width: 6),
                            Text(
                              "Nuevo",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _sizesView() {
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
                    Pill(
                      color: PuventColors.primaryGreen.color,
                      label: "Tamaños",
                    ),

                    // ElevatedButton.icon(
                    //   onPressed: _openSizeModal,
                    //   icon: const Icon(Icons.add),
                    //   label: const Text("Nuevo"),
                    // ),
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        _openSizeModal();
                      },
                      splashColor: Colors.white24,
                      highlightColor: Colors.white10,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: PuventColors.primaryGreen.color,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.add, color: Colors.white, size: 20),
                            SizedBox(width: 6),
                            Text(
                              "Nuevo",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  // ================= LISTAS =================
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

  Widget _listSizes() {
    return StreamBuilder<List<ProductSize>>(
      stream: database.watchSizes(),
      builder: (context, snapshot) {
        final sizes = snapshot.data ?? [];

        final filteredSized = sizes
            .where((s) => (s.name.toUpperCase() != "UNICO"))
            .toList();

        if (filteredSized.isEmpty) {
          return const Center(child: Text("No hay tamaños"));
        }

        return ListView.builder(
          itemCount: filteredSized.length,
          itemBuilder: (_, i) => _productSizeTile(filteredSized[i]),
        );
      },
    );
  }

  // ================= TILE =================
  Widget _productTile(Product product) {
    return Card(
      color: Colors.white,
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
                    fontWeight: FontWeight.w500,
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
                  onPressed: () =>
                      _openProductModal(product: product, edit: true),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await database.deleteVariantsByProduct(product.productId);
                    await database.deleteProduct(product.productId);
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
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
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
                    fontWeight: FontWeight.w500,
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
                    await database.deleteSize(sizes.productSizeId);
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
  void _openProductModal({Product? product, bool? edit}) async {
    final nameController = TextEditingController(text: product?.name ?? "");

    final pricePerKgController = TextEditingController();
    final simplePriceController = TextEditingController();
    bool hasSizes = product?.hasSizes ?? false;
    bool isByGrams = product?.isByGrams ?? false;
    String simplePrice = "";

    List<VariantForm> variants = [VariantForm()];

    final isEditing = edit;
    final uniqueSizeId = await database.getUniqueSizeId();

    if (product != null && hasSizes) {
      //CArgar vlas variantes
      final existingVariants = await database.getVariantsByProduct(
        product.productId,
      );

      /// final filteredData = existingVariants
      //  .where((v) => v.productSizeId != uniqueSizeId)
      //.toList();

      variants = existingVariants
          .map(
            (v) => VariantForm(
              sizeId: v.productSizeId,
              price: v.price?.toString() ?? "",
            ),
          )
          .toList();
    } else if (product != null && isByGrams) {
      //Precio por kilo
      final existingVariants = await database.getVariantsByProduct(
        product.productId,
      );
      if (existingVariants.isNotEmpty) {
        pricePerKgController.text = existingVariants.first.pricePerKg
            .toString();
      }
    } else if (product != null) {
      // Precio fijo
      final existingVariant = await database.getVariantsByProduct(
        product.productId,
      );
      if (existingVariant.isNotEmpty) {
        simplePrice = existingVariant.first.price.toString();
        simplePriceController.text = existingVariant.first.price.toString();
      }
    }

    final sizesStream = database.watchSizes();

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
            final filteredSizes = sizes
                .where((e) => (e.name.toUpperCase() != "UNICO"))
                .toList();

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
                                activeTrackColor:
                                    PuventColors.primaryGreen.color,
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
                                activeTrackColor:
                                    PuventColors.primaryGreen.color,
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

                        // Gramos
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

                        // Tamaños
                        if (hasSizes)
                          if (sizes.isEmpty)
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(text: "No hay "),
                                  TextSpan(
                                    text: "Tamaños ",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: "registrados."),
                                ],
                              ),
                            )
                          else
                            Column(
                              children: [
                                ...variants.asMap().entries.map((entry) {
                                  int i = entry.key;
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: DropdownMenu<int>(
                                          initialSelection: variants[i].sizeId,
                                          onSelected: (v) {
                                            setModalState(() {
                                              variants[i].sizeId = v;
                                            });
                                          },
                                          dropdownMenuEntries: filteredSizes
                                              .map(
                                                (s) => DropdownMenuEntry<int>(
                                                  value: s.productSizeId,
                                                  label: s.name,
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          initialValue: variants[i].price
                                              .toString(),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            labelText: "Precio",
                                          ),
                                          onChanged: (v) =>
                                              variants[i].price = v,
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
                                      variants.add(VariantForm());
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
                          TextFormField(
                            controller: isByGrams
                                ? pricePerKgController
                                : simplePriceController,
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
                                  if (v.sizeId == null) {
                                    throw Exception("Selecciona un tamaño");
                                  }

                                  await database.insertVariant(
                                    ProductVariantsCompanion(
                                      productId: drift.Value(productId),
                                      productSizeId: drift.Value(v.sizeId!),
                                      price: drift.Value(
                                        double.tryParse(v.price) ?? 0,
                                      ),
                                    ),
                                  );
                                }
                              } else if (isByGrams) {
                                final uniqueSizeId = await database
                                    .getUniqueSizeId();
                                await database.insertVariant(
                                  ProductVariantsCompanion(
                                    productId: drift.Value(productId),
                                    productSizeId: drift.Value(
                                      uniqueSizeId,
                                    ), //aquí se asigno lode gramos
                                    pricePerKg: drift.Value(
                                      double.tryParse(
                                            pricePerKgController.text,
                                          ) ??
                                          0,
                                    ),
                                  ),
                                );
                              } else {
                                // producto simple como variante única
                                await database.insertVariant(
                                  ProductVariantsCompanion(
                                    productId: drift.Value(productId),
                                    productSizeId: drift.Value(uniqueSizeId), //Cambiar esto por el valor real
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
                  const SizedBox(height: 15),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                      children: [
                        TextSpan(text: "Se recomienda que el  "),
                        TextSpan(
                          text: "Nombre ",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "sea en singular."),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
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
