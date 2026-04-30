import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:localix/data/database.dart';
import 'package:localix/data/tables/orders.dart';
import 'package:localix/features/app_page/presentation/app_page.dart';
import 'package:localix/helpers/cash_service.dart';
import 'package:localix/widgets/pill.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ===================== MODEL =====================
class ProductFormModel {
  final String id = UniqueKey().toString();
  Product? product;
  int? size;
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
  final int variantId;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.variantId,
  });

  double get subtotal => quantity * unitPrice;
}

// ===================== UI =====================
class HomePage extends StatefulWidget {
  final AppDatabase database;
  final bool isCashOpen;
  const HomePage({super.key, required this.database, required this.isCashOpen});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AppDatabase database;
  final List<ProductFormModel> productForms = [];
  final List<String> orders = [];

  String selectedStatusFilter = "PENDING";
  String selectedSort = "OLDER";

  List<OrderItem> orderItems = [
    // OrderItem(name: "Café", quantity: 2, unitPrice: 25.0),
    // OrderItem(name: "Pan", quantity: 1, unitPrice: 15.0),
  ];
  // Contoladores y focus para cada form
  final Map<String, TextEditingController> gramsControllers = {};
  final Map<String, FocusNode> gramsFocusNodes = {};
  final Map<String, bool> gramsOptionBuy = {};

  final double totalGeneral = 0.0;

  String folio = "0";

  @override
  void initState() {
    super.initState();
    database = widget.database;
    productForms.add(ProductFormModel());
    _loadFolio();
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
    return Stack(
      children: [
        DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Divider(color: Colors.grey.shade300, height: 1),
              Container(
                color: Colors.white,
                child: TabBar(
                  key: ValueKey("tabs"),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: PuventColors.primaryGreen.color,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: [
                    Tab(text: "Punto", icon: Icon(Icons.point_of_sale)),
                    Tab(text: "Pedidos", icon: Icon(Icons.list_alt)),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(children: [_ventaView(), _pedidosView()]),
              ),
            ],
          ),
        ),
        if (!widget.isCashOpen)
          Container(
            color: Colors.black.withOpacity(0.6),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock, size: 50, color: Colors.red),
                    SizedBox(height: 10),
                    Text(
                      "Caja cerrada",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Debes abrir la caja para usar el sistema",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ===================== VENTA =====================
  Widget _ventaView() {
    return StreamBuilder<List<Product>>(
      stream: database.watchProducts(),
      builder: (context, snapshot) {
        /* if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }*/

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
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

  Future<void> _loadFolio() async {
    final newFolio = await CashService.generateFolio();

    setState(() {
      folio = newFolio;
    });
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
                    folio,
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
              if (productForms.isNotEmpty) {
                final firstForm = productForms.first;

                // No hay producto
                if (firstForm.product == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Primero selecciona un producto."),
                    ),
                  );
                  return;
                }

                // Producto sin total válido
                if (firstForm.total.abs() < 0.0001) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("El total del producto no puede ser \$0.0"),
                    ),
                  );
                  return;
                }
              }

              // Todo bien → agregar nuevo arriba
              setState(() {
                productForms.insert(0, ProductFormModel());
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

  // ===================== LISTAS =====================
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

  Widget _buildOrdersList(List<Order> orders) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(order, index);
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
                    ProductFormModel firstForm = productForms.first;
                    if (firstForm.product == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Para continuar debe seleccionar un producto.",
                          ),
                        ),
                      );
                      return;
                    } else if (firstForm.total.abs() < 0.0001) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "El total del producto no puede ser \$0.0",
                          ),
                        ),
                      );
                      return;
                    } else if (total.abs() < 0.0001) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Para continuar el total general no puede ser \$0.0",
                          ),
                        ),
                      );
                      return;
                    } else {
                      _continueSell();
                    }
                  } else {
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
                    onChanged: (p) async {
                      if (p == null) return;

                      final variants = await database.getVariantsByProduct(
                        p.productId,
                      );

                      setState(() {
                        form.product = p;
                        form.byGrams = p.isByGrams;

                        form.grams = 0;
                        form.quantity = 1;
                        form.unityPrice = 0;
                        form.priceByKg = 0;
                        form.total = 0;

                        if (!p.hasSizes) {
                          form.size = variants.first.productSizeId;
                        }
                      });

                      gramsControllers[form.id]?.clear();
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
                  stream: database.watchVariants(form.product!.productId),
                  builder: (context, snapshot) {
                    final variants = snapshot.data ?? [];
                    if (variants.isNotEmpty) {
                      // Asigna el precio por kilo de la variante GRAMOS
                      final gramsVariant = variants.firstWhere(
                        (v) => v.productSizeId == 1,
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

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pendiente":
        return Colors.orange;
      case "En preparación":
        return Colors.blue;
      case "Listo":
        return Colors.green;
      case "Entregado":
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  Widget _buildOrderCard(Order order, int index) {
    final isFirstPending =
        selectedStatusFilter == "PENDING" &&
        order.processStatus == "Pendiente" &&
        index == 0;

    final displayStatus = isFirstPending
        ? "En preparación"
        : order.processStatus;

    return InkWell(
      onTap: () {
        _changeProgressStatus(order);
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Orden #${order.folio}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(displayStatus),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      displayStatus,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                "Fecha: ${order.createdAt}",
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total"),
                  Text(
                    "\$${order.totalAmount.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: PuventColors.primaryGreen.color,
                    ),
                  ),
                ],
              ),

              if (order.paymentMethod != null)
                Text("Pago: ${order.paymentMethod}"),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadUnityPrice(ProductFormModel form) async {
    final variants = await database.getVariantsByProduct(
      form.product!.productId,
    );

    final uniqueVariant = variants.firstWhere(
      (v) => v.productSizeId == 1,
      orElse: () => variants.first,
    );

    setState(() {
      form.unityPrice = uniqueVariant.price ?? 0.0;
      form.total = _calculateItemTotal(form);
    });
  }

  Widget _buildSizes(ProductFormModel form) {
    return StreamBuilder<List<(ProductVariant, ProductSize)>>(
      stream: database.watchVariantsWithSize(form.product!.productId),
      builder: (context, snapshot) {
        final data = snapshot.data ?? [];

        // // Solo limpiar si el producto cambió o el valor ya no existe
        // if (form.size != null &&
        //     form.product != null &&
        //     !data.any((v) => v.size == form.size)) {
        //   // Evita limpiar si el producto es el mismo y el valor sigue siendo válido
        //   form.size = null;
        //   form.unityPrice = 0.0;
        // }

        return DropdownButtonFormField<int>(
          //value: data.any((v) => v.size == int.parse(form.size!)) ? form.size : null,
          value: form.size,
          hint: const Text("Seleccionar tamaño"),
          items: data.map((v) {
            final variant = v.$1;
            final size = v.$2;

            return DropdownMenuItem(
              value: variant.productSizeId,
              child: Text("${size.name} - \$${variant.price}"),
            );
          }).toList(),
          onChanged: (v) {
            final variant = data.firstWhere(
              (element) => element.$1.productSizeId == v,
            );

            setState(() {
              form.size = v;
              form.unityPrice = variant.$1.price!;
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

  void _openPaymentDialog(List<OrderItem> items, double total) {
    final paidController = TextEditingController();
    double change = 0;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                constraints: const BoxConstraints(maxHeight: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Cobrar",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: PuventColors.primaryGreen.color,
                          ),
                        ),
                        Icon(
                          Icons.receipt_long,
                          color: PuventColors.primaryGreen.color,
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Divider(),

                    Text(
                      "Total \$${total.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: PuventColors.primaryGreen.color,
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextField(
                      controller: paidController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Recibido"),
                      onChanged: (value) {
                        final paid = double.tryParse(value) ?? 0;
                        setState(() {
                          change = paid - total;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Cambio: \$${change.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: change < 0 ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Divider(),
                    // Botones
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
                            ),
                            onPressed: change < 0
                                ? null
                                : () async {
                                    await _saveOrder(
                                      items,
                                      total,
                                      paidController.text,
                                    );
                                    Navigator.pop(context);
                                  },
                            child: const Text(
                              "Confirmar",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
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
      },
    );
  }

  Future<void> _saveOrder(
    List<OrderItem> items,
    double total,
    String paidText,
  ) async {
    final paid = double.tryParse(paidText) ?? 0;
    final change = paid - total;

    //  Insertar orden
    final orderId = await database
        .into(database.orders)
        .insert(
          OrdersCompanion.insert(
            folio: folio,
            totalAmount: total,
            paymentMethod: drift.Value("Efectivo"),
            processStatus: drift.Value("Pendiente"),
          ),
        );

    // Insertar items
    for (var item in items) {
      await database
          .into(database.orderItems)
          .insert(
            OrderItemsCompanion.insert(
              orderId: orderId,
              variantId: drift.Value(item.variantId), // importante
              unitPrice: item.unitPrice,
              subtotal: item.subtotal,
            ),
          );
    }

    //  3. Limpiar carrito
    setState(() {
      productForms.clear();
    });

    //setState(() {}); // Para forzar el rebuild

    // DefaultTabController.of(context).animateTo(1);
    // generar siguiente folio
    await _loadFolio();
  }

  void _continueSell() {
    showDialog(
      context: context,
      builder: (context) {
        final orderItems = productForms.map((p) {
          return OrderItem(
            variantId: p.size!,
            name: p.product!.name,
            quantity: p.quantity,
            unitPrice: p.unityPrice == 0 ? p.total : p.unityPrice,
          );
        }).toList();

        final total = orderItems.fold<double>(
          0,
          (sum, item) => sum + item.subtotal,
        );

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxHeight: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Resumen",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: PuventColors.primaryGreen.color,
                      ),
                    ),
                    Icon(
                      Icons.receipt_long,
                      color: PuventColors.primaryGreen.color,
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Divider(),

                // Lista de productos
                Expanded(
                  child: ListView.separated(
                    itemCount: orderItems.length,
                    separatorBuilder: (_, __) => Divider(),
                    itemBuilder: (context, index) {
                      final item = orderItems[index];

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Nombre + cantidad
                          Expanded(
                            child: Text(
                              "${item.quantity} x ${item.name}",
                              style: const TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Subtotal
                          Text(
                            "\$${item.subtotal.toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                Divider(),

                //  Total destacado
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\$${total.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: PuventColors.primaryGreen.color,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Botones
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
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _openPaymentDialog(orderItems, total);
                        },
                        child: const Text(
                          "Cobrar",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
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

  void _changeProgressStatus(Order order) async {
    final details = await database.getOrderDetails(order.orderId);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxHeight: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Orden ${order.processStatus}",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: PuventColors.primaryGreen.color,
                      ),
                    ),
                    Icon(
                      Icons.receipt_long,
                      color: PuventColors.primaryGreen.color,
                    ),
                  ],
                ),
                Text(
                  "Orden ${order.orderId}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: PuventColors.primaryGreen.color,
                  ),
                ),
                const SizedBox(height: 10),
                Divider(),

                Text(
                  "Detalles",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: PuventColors.primaryGreen.color,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: details.isEmpty
                      ? const Text("Sin productos")
                      : ListView.builder(
                          itemCount: details.length,
                          itemBuilder: (_, i) {
                            final item = details[i].$1;
                            final product = details[i].$2;
                            final size = details[i].$3;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "x${item.quantity} -${product.name} ${size.name == "UNICO" ? "" : size.name}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "\$${item.subtotal.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
                const SizedBox(height: 10),

                Divider(),

                const SizedBox(height: 15),

                // Botones
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
                        ),
                        onPressed: () {
                          _changeStatus(order);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Entregado",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
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

  Future<void> _changeStatus(Order order) async {
    await (database.update(
      database.orders,
    )..where((tbl) => tbl.orderId.equals(order.orderId))).write(
      OrdersCompanion(
        processStatus: const drift.Value("Entregado"),
        deliveredAt: drift.Value(DateTime.now()),
      ),
    );
  }

  List<Order> filterOrders(List<Order> orders) {
    List<Order> result = List.from(orders);

    // FILTRAR (por estado)
    if (selectedStatusFilter == "PENDING") {
      result = result.where((o) => o.processStatus == "Pendiente").toList();
    }

    if (selectedStatusFilter == "DELIVERED") {
      result = result.where((o) => o.processStatus == "Entregado").toList();

      result.sort((a, b) {
        final aDate = a.deliveredAt ?? DateTime(0);
        final bDate = b.deliveredAt ?? DateTime(0);
        return bDate.compareTo(aDate); // más reciente, desde arriba hacia abajo
      });
    }

    // ORDENAMOS
    if (selectedSort == "NEWER" && selectedStatusFilter == "DELIVERED") {
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (selectedSort == "OLDER") {
      result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    return result;
  }

  // ===================== PEDIDOS =====================
  Widget _pedidosView() {
    return StreamBuilder<List<Order>>(
      stream: database.watchOrders(),
      builder: (context, snapshot) {
        final orders = snapshot.data ?? [];
        final filteredOrders = filterOrders(orders);

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
                  _headerPedidos(),
                  Expanded(
                    child: filteredOrders.isEmpty
                        ? Center(
                            child: Text(
                              "Aún no hay pedidos en cola",
                              style: TextStyle(
                                color: PuventColors.primaryGreyText.color,
                              ),
                            ),
                          )
                        : _buildOrdersList(filteredOrders),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _headerPedidos() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _filterButton(
              icon: Icons.history,
              label: "Todos",
              isSelected: selectedStatusFilter == "ALL",
              onTap: () => setState(() => selectedStatusFilter = "ALL"),
            ),
            _filterButton(
              icon: Icons.sell,
              label: "Pendientes",
              isSelected: selectedStatusFilter == "PENDING",
              onTap: () => setState(() => selectedStatusFilter = "PENDING"),
            ),
            _filterButton(
              icon: Icons.sell,
              label: "Entregados",
              isSelected: selectedStatusFilter == "DELIVERED",
              onTap: () => setState(() => selectedStatusFilter = "DELIVERED"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? PuventColors.primaryGreen.color
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
