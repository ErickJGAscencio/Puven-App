import 'package:flutter/material.dart';
import 'package:localix/data/database.dart';
import 'package:localix/features/app_page/presentation/app_page.dart';
import 'package:localix/widgets/pill.dart';

// ===================== MODEL =====================
class ProductFormModel {
  final String id = UniqueKey().toString();
  Product? product;
  String? size;
  double grams;
  bool byGrams;
  double priceByKg;
  double unityPrice;
  int quantity;
  bool? optionBuy;
  double total = 0.0;

  ProductFormModel({
    this.product,
    this.size,
    this.grams = 0.0,
    this.byGrams = false,
    this.priceByKg = 0.0,
    this.unityPrice = 0.0,
    this.quantity = 1,
    this.optionBuy = false,
    this.total = 0.0,
  });
}

class OrderItem {
  final String name;
  final int quantity;
  final double unitPrice;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  double get subtotal => quantity * unitPrice;
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
  final List<String> delivery = [];

  final List<OrderItem> orderItems = [
    // OrderItem(name: "Café", quantity: 2, unitPrice: 25.0),
    // OrderItem(name: "Pan", quantity: 1, unitPrice: 15.0),
  ];
  // Contoladores y focus para cada form
  final Map<String, TextEditingController> gramsControllers = {};
  final Map<String, FocusNode> gramsFocusNodes = {};
  final Map<String, bool> gramsOptionBuy = {};

  final double totalGeneral = 0.0;

  @override
  void initState() {
    super.initState();
    database = widget.database;
    productForms.add(ProductFormModel());
  }

  @override
  void dispose() {
    // Liberar recursos
    gramsControllers.values.forEach((c) => c.dispose());
    gramsFocusNodes.values.forEach((f) => f.dispose());
    super.dispose();
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
                Tab(icon: Icon(Icons.point_of_sale)),
                Tab(icon: Icon(Icons.list_alt)),
              ],
            ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Pill(
                    color: PuventColors.primaryGreen.color,
                    label: "Punto de Venta",
                  ),
                  _headerVenta(),
                  Expanded(
                    child: productForms.isEmpty
                        ? Center(
                            child: Text(
                              "Agrege '+' un producto por a la lista",
                              style: TextStyle(
                                color: PuventColors.primaryGreyText.color,
                              ),
                            ),
                          )
                        : _buildFormList(products),
                  ),
                ],
              ),
            ),
            _footerSection(),
          ],
        );
      },
    );
  }

  Widget _headerVenta() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Venta",
                    style: TextStyle(
                      fontSize: 18,
                      color: PuventColors.primaryGreyText.color,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "·0000001",
                    style: TextStyle(
                      fontSize: 18,
                      color: PuventColors.primaryGreyText.color,
                    ),
                  ),
                ],
              ),
              Text(
                "Productos",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: PuventColors.primaryGreyText.color,
                ),
              ),
            ],
          ),
          const SizedBox(width: 80),
          InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              // Validar que haya al menos un formulario
              if (productForms.isNotEmpty) {
                final lastForm = productForms.last;

                // Si el último formulario no tiene producto, no crear otro
                if (lastForm.product == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Primero selecciona un producto antes de agregar otro.",
                      ),
                    ),
                  );
                  return;
                }
              }

              setState(() {
                productForms.add(ProductFormModel());
              });
            },
            splashColor: Colors.white24,
            highlightColor: Colors.white10,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                    "Producto",
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
    );
  }

  Widget _buildFormList(List<Product> products) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: ListView.builder(
        itemCount: productForms.length,
        itemBuilder: (context, index) {
          return _buildForm(index, products);
        },
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
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Colors.green, width: 1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(
                "\$${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  if (productForms.isNotEmpty) {
                    final lastForm = productForms.last;
                    if (lastForm.product == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Para continuar debe seleccionar un producto.",
                          ),
                        ),
                      );
                      return;
                    }else if(total == 0.0){
                     ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Para continuar el total general no puede ser \$0.0",
                          ),
                        ),
                      );
                      return;
                    }else{
                      _continueSell();
                    }
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Para continuar debe haber un producto en la lista.",
                          ),
                        ),
                      );
                      return;
                  }
                },
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: PuventColors.primaryGreen.color,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: PuventColors.primaryGreen.color.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Text(
                    "Continuar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
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
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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

                        form.grams = 0;
                        form.quantity = 1;
                        form.unityPrice = 0;
                        form.priceByKg = 0;
                        form.total = 0;

                        gramsControllers[form.id]?.clear();
                      });
                      if (!p.hasSizes && !p.isByGrams) {
                        _loadUnityPrice(form);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      final id = productForms[index].id;
                      gramsControllers.remove(id)?.dispose();
                      gramsFocusNodes.remove(id)?.dispose();
                      gramsOptionBuy.remove(id);
                      productForms.removeAt(index);
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 5),

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

                    return _buildGrams(form, index);
                    // return Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Expanded(flex: 2, child: _buildGrams(form, index)),
                    //     const SizedBox(width: 10),
                    //     Expanded(flex: 1, child: _switchGrams()),
                    //   ],
                    // );
                  },
                ),
            ],

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (form.product != null)
                  Expanded(
                    child: Text(
                      "\$${form.total.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 24,
                        color: PuventColors.primaryGreen.color,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),

                const SizedBox(width: 10),
                if (form.product != null && !form.byGrams)
                  _quantityControl(form),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadUnityPrice(ProductFormModel form) async {
    final variants = await database.getVariantsByProduct(form.product!.id);

    final uniqueVariant = variants.firstWhere(
      (v) => v.size.toUpperCase() == "UNICO",
      orElse: () => variants.first,
    );

    setState(() {
      form.unityPrice = uniqueVariant.price ?? 0.0;
      form.total = _calculateItemTotal(form);
    });
  }

  Widget _buildSizes(ProductFormModel form) {
    return StreamBuilder<List<ProductVariant>>(
      stream: database.watchVariants(form.product!.id),
      builder: (context, snapshot) {
        final variants = snapshot.data ?? [];

        // // Solo limpiar si el producto cambió o el valor ya no existe
        // if (form.size != null &&
        //     form.product != null &&
        //     !variants.any((v) => v.size == form.size)) {
        //   // Evita limpiar si el producto es el mismo y el valor sigue siendo válido
        //   form.size = null;
        //   form.unityPrice = 0.0;
        // }

        return DropdownButtonFormField<String>(
          value: variants.any((v) => v.size == form.size) ? form.size : null,
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
              form.total = _calculateItemTotal(form);
            });
          },
        );
      },
    );
  }

  Widget _buildGrams(ProductFormModel form, int index) {
    final id = form.id;
    //creamos crontrola y focus si no existen
    gramsControllers.putIfAbsent(
      id,
      () => TextEditingController(text: form.grams.toString()),
    );
    gramsFocusNodes.putIfAbsent(id, () => FocusNode());

    gramsOptionBuy.putIfAbsent(id, () => false);

    final controller = gramsControllers[id]!;
    final focusNode = gramsFocusNodes[id]!;
    final optionBuy = gramsOptionBuy[id]!;

    // Limpiamos field por si hay ceros al activar focues
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        controller.text = _cleanZeros(controller.text);
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: optionBuy ? "Pesos" : "Gramos",
                ),
                onChanged: (v) {
                  setState(() {
                    form.grams = formatGrams(v);
                    form.total = _calculateItemTotal(form);
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: _switchGrams(optionBuy, id, form)),
          ],
        ),
        const SizedBox(height: 5),
        if (!optionBuy)
          Wrap(
            spacing: 8, // espacio horizontal entre botones
            runSpacing: 8, // espacio vertical entre filas
            alignment: WrapAlignment.center,
            children: [250, 500, 1000].map((g) {
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    form.grams = g.toDouble();
                    controller.text = g.toString();
                    controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length),
                    );
                  });
                  form.total = _calculateItemTotal(form);
                },
                child: Text(g == 1000 ? "1 kg" : "$g g"),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _switchGrams(bool optionBuy, String id, ProductFormModel form) {
    return Row(
      children: [
        Icon(Icons.scale, color: PuventColors.accentBlue.color),
        Switch(
          value: optionBuy,
          activeTrackColor: PuventColors.primaryGreen.color,
          activeThumbColor: Colors.white,
          onChanged: (val) {
            setState(() {
              gramsOptionBuy[id] = val;
              form.optionBuy = val;
              form.grams = 0;
              form.total = 0;
              gramsControllers[id]?.clear();
            });
          },
        ),
        Icon(Icons.attach_money, color: PuventColors.accentBlue.color),
      ],
    );
  }

  String _cleanZeros(String value) {
    if (value.startsWith("0.") || value.isEmpty) return value;
    return value.replaceFirst(RegExp(r'^0+'), '');
  }

  double formatGrams(String grams) {
    grams = grams.trim();
    if (grams.isEmpty) return 0;
    return double.tryParse(grams) ?? 0;
  }

  Widget _quantityControl(ProductFormModel form) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Botón restar
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              setState(() {
                if (form.quantity > 1) form.quantity--;
                form.total = _calculateItemTotal(form);
              });
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.remove, size: 18, color: Colors.black),
            ),
          ),

          const SizedBox(width: 12),

          // Texto cantidad
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              "${form.quantity}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),

          const SizedBox(width: 12),

          // Botón sumar
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              setState(() {
                form.quantity++;
                form.total = _calculateItemTotal(form);
              });
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: PuventColors.primaryGreen.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== LOGIC =====================
  double _calculateItemTotal(ProductFormModel form) {
    if (form.product == null) return 0;

    if (form.byGrams) {
      return form.optionBuy == true
          ? form.grams
          : form.grams * (form.priceByKg / 1000);
    }

    return form.unityPrice * form.quantity;
  }

  void _continueSell() {
    showDialog(
      context: context,
      builder: (context) {
        final total = orderItems.fold<double>(
          0,
          (sum, item) => sum + item.subtotal,
        );

        return AlertDialog(
          title: const Text("Resumen de venta"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ...orderItems.map(
                (item) => Text(
                  "${item.quantity} x ${item.name} - \$${item.subtotal.toStringAsFixed(2)}",
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Total: \$${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  // ===================== PEDIDOS =====================
  Widget _pedidosView() {
    return StreamBuilder<List<Product>>(
      stream: database.watchProducts(),
      builder: (context, snapshot) {
        final products = snapshot.data ?? [];

        return Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Pill(
                    color: PuventColors.primaryGreen.color,
                    label: "Lista de Pedidos",
                  ),
                  Expanded(
                    child: delivery.isEmpty
                        ? Center(
                            child: Text(
                              "Aún no hay pedidos en cola",
                              style: TextStyle(
                                color: PuventColors.primaryGreyText.color,
                              ),
                            ),
                          )
                        : _buildFormList(products),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
