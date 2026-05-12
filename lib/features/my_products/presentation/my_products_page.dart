import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:localix/data/database.dart';
import 'package:localix/features/app_page/presentation/app_page.dart';
import 'package:localix/widgets/pill.dart';

class VariantForm {
  int? sizeId;
  String price;

  VariantForm({this.sizeId, this.price = ""});
}

class MyProductsPage extends StatefulWidget {
  final AppDatabase database;
  const MyProductsPage({super.key, required this.database});

  @override
  State<MyProductsPage> createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage>
    with TickerProviderStateMixin {
  late final AppDatabase database;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    database = widget.database;
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        color: PuventColors.background.color,
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TabBar(
                  controller: _tabController,
                  key: ValueKey("tabs"),
                  splashBorderRadius: BorderRadius.circular(30),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: PuventColors.primaryGreen.color,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black54,
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: "Productos"),
                    Tab(text: "Tamaños"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_productsView(), _sizesView()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= PRODUCTS =================

  Widget _productsView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Text(
            "Mis Productos",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Pill(color: PuventColors.primaryGreen.color, label: "Inventario"),
              _addButton(() => _openProductModal()),
            ],
          ),

          const SizedBox(height: 12),

          Expanded(child: _listProducts()),
        ],
      ),
    );
  }

  Widget _sizesView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tamaños",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Pill(color: PuventColors.primaryGreen.color, label: "Gestión"),
              _addButton(() => _openSizeModal()),
            ],
          ),

          const SizedBox(height: 12),

          Expanded(child: _listSizes()),
        ],
      ),
    );
  }

  Widget _addButton(VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: PuventColors.primaryGreen.color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Row(
          children: [
            Icon(Icons.add, color: Colors.white, size: 20),
            SizedBox(width: 6),
            Text(
              "Nuevo",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= LISTAS =================

  Widget _listProducts() {
    return StreamBuilder<List<Product>>(
      stream: database.watchProducts(),
      builder: (_, snapshot) {
        final products = snapshot.data ?? [];

        if (products.isEmpty) {
          return _emptyState("No hay productos", Icons.inventory);
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
      builder: (_, snapshot) {
        final sizes = snapshot.data ?? [];

        final filtered = sizes
            .where((s) => s.name.toUpperCase() != "UNICO")
            .toList();

        if (filtered.isEmpty) {
          return _emptyState("No hay tamaños", Icons.straighten);
        }

        return ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (_, i) => _sizeTile(filtered[i]),
        );
      },
    );
  }

  Widget _emptyState(String text, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black38, size: 55),
          Text(text, style: TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  // ================= TILE =================

  Widget _productTile(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          /// ICONO
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: PuventColors.primaryGreen.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2,
              color: PuventColors.primaryGreen.color,
            ),
          ),

          const SizedBox(width: 12),

          /// INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  product.hasSizes
                      ? "Con tamaños"
                      : product.isByGrams
                      ? "Por gramos"
                      : "Precio fijo",
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ),

          /// ACTIONS
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black54),
                onPressed: () => _openProductModal(product: product),
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
    );
  }

  Widget _sizeTile(ProductSize size) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: PuventColors.primaryGreen.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.straighten,
              color: PuventColors.primaryGreen.color,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              size.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black54),
                onPressed: () => _openSizeModal(size: size),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await database.deleteSize(size.productSizeId);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // ================= MODAL =================
  void _openProductModal({Product? product}) async {
    final nameController = TextEditingController(text: product?.name ?? "");

    final pricePerKgController = TextEditingController();
    final simplePriceController = TextEditingController();

    bool hasSizes = product?.hasSizes ?? false;
    bool isByGrams = product?.isByGrams ?? false;

    List<VariantForm> variants = [VariantForm()];

    final uniqueSizeId = await database.getUniqueSizeId();

    String? errorMessage;

    //  Cargar datos si es edición
    if (product != null && hasSizes) {
      final existingVariants = await database.getVariantsByProduct(
        product.productId,
      );

      variants = existingVariants
          .map(
            (v) => VariantForm(
              sizeId: v.productSizeId,
              price: v.price?.toString() ?? "",
            ),
          )
          .toList();
    } else if (product != null && isByGrams) {
      final existingVariants = await database.getVariantsByProduct(
        product.productId,
      );

      if (existingVariants.isNotEmpty) {
        pricePerKgController.text =
            existingVariants.first.pricePerKg?.toString() ?? "";
      }
    } else if (product != null) {
      final existingVariant = await database.getVariantsByProduct(
        product.productId,
      );

      if (existingVariant.isNotEmpty) {
        simplePriceController.text =
            existingVariant.first.price?.toString() ?? "";
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
                .where((e) => e.name.toUpperCase() != "UNICO")
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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product == null
                                  ? "Añadir Nuevo Producto"
                                  : "Editar Producto",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(child: Icon(Icons.info_outline_rounded)),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Nombre
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Nombre del producto",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onChanged: (_) {
                            setModalState(() {
                              errorMessage = null;
                            });
                          },
                        ),
                        if (errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                        const SizedBox(height: 10),

                        // Switches
                        Row(
                          children: [
                            Expanded(
                              child: SwitchListTile(
                                value: hasSizes,
                                onChanged: isByGrams
                                    ? null
                                    : (v) => setModalState(() => hasSizes = v),
                                title: const Text("Tamaños"),
                                activeThumbColor: Colors.white,
                                activeTrackColor:
                                    PuventColors.primaryGreen.color,
                              ),
                            ),
                            Expanded(
                              child: SwitchListTile(
                                value: isByGrams,
                                onChanged: hasSizes
                                    ? null
                                    : (v) => setModalState(() => isByGrams = v),
                                title: const Text("Gramaje"),
                                activeThumbColor: Colors.white,
                                activeTrackColor:
                                    PuventColors.primaryGreen.color,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // ⚖️ GRAMOS
                        if (isByGrams)
                          TextFormField(
                            controller: pricePerKgController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Precio por Kg",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),

                        // TAMAÑOS
                        if (hasSizes)
                          Column(
                            children: [
                              ...variants.asMap().entries.map((entry) {
                                int i = entry.key;

                                if (filteredSizes.isEmpty) {
                                  return Center(
                                    child: RichText(
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
                                    ),
                                  );
                                }

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
                                        initialValue: variants[i].price,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: "Precio",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                        ),

                                        onChanged: (v) => variants[i].price = v,
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
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                onPressed: () {
                                  if (filteredSizes.isEmpty) {
                                    _tabController.index =
                                        1; // 1 representa la posicion del tab "Tamaños"
                                    Navigator.pop(context);
                                    return;
                                  }
                                  setModalState(() {
                                    variants.add(VariantForm());
                                  });
                                },
                                icon: const Icon(Icons.add),
                                label: filteredSizes.isEmpty
                                    ? Text("Crear Tamaños")
                                    : Text("Agregar tamaño"),
                              ),
                            ],
                          ),

                        // PRECIO SIMPLE
                        if (!hasSizes && !isByGrams)
                          TextFormField(
                            controller: simplePriceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Precio",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),

                            onChanged: (_) {
                              setModalState(() {
                                errorMessage = null;
                              });
                            },
                          ),
                        if (errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                        const SizedBox(height: 20),

                        // GUARDAR
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              final name = nameController.text.trim();
                              final isEditing = product != null;

                              int productId;
                              if (name.isEmpty ||
                                  simplePriceController.text.trim() == "") {
                                setModalState(() {
                                  errorMessage =
                                      "No es posible dejar campos en blanco";
                                });
                                return;
                              }

                              if (!isEditing) {
                                // CREAR
                                productId = await database.insertProduct(
                                  ProductsCompanion(
                                    name: drift.Value(name),
                                    hasSizes: drift.Value(hasSizes),
                                    isByGrams: drift.Value(isByGrams),
                                  ),
                                );
                              } else {
                                // EDITAR
                                productId = product.productId;

                                await database.updateProduct(
                                  Product(
                                    productId: productId,
                                    name: name,
                                    hasSizes: hasSizes,
                                    isByGrams: isByGrams,
                                  ),
                                );

                                // limpiar variantes anteriores
                                await database.deleteVariantsByProduct(
                                  productId,
                                );
                              }

                              // INSERTAR VARIANTES
                              if (hasSizes) {
                                for (var v in variants) {
                                  if (v.sizeId == null) continue;

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
                                await database.insertVariant(
                                  ProductVariantsCompanion(
                                    productId: drift.Value(productId),
                                    productSizeId: drift.Value(uniqueSizeId),
                                    pricePerKg: drift.Value(
                                      double.tryParse(
                                            pricePerKgController.text,
                                          ) ??
                                          0,
                                    ),
                                  ),
                                );
                              } else {
                                await database.insertVariant(
                                  ProductVariantsCompanion(
                                    productId: drift.Value(productId),
                                    productSizeId: drift.Value(uniqueSizeId),
                                    price: drift.Value(
                                      double.tryParse(
                                            simplePriceController.text,
                                          ) ??
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
                    decoration: InputDecoration(
                      labelText: "Ingrese nombre del tamaño",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
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
                        final isEditing = size != null;

                        if (name.isEmpty) {
                          Navigator.pop(context);
                          _showError("No es posible guardar un campo vacío");
                          return;
                        }

                        if (isEditing) {
                          await database.updateSize(
                            ProductSize(
                              productSizeId: size.productSizeId,
                              name: name,
                            ),
                          );
                        } else {
                          await database.insertSize(
                            ProductSizesCompanion(name: drift.Value(name)),
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

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
