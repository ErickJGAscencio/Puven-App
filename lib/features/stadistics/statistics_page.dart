import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:localix/data/database.dart';
import 'package:localix/data/tables/orders.dart';
import 'package:localix/features/app_page/presentation/app_page.dart';
import 'package:localix/widgets/pill.dart';

enum ChartRange { day, week, month }

enum ChartFilter { gen, top, dis, his }

class StatisticsPage extends StatefulWidget {
  final AppDatabase database;
  const StatisticsPage({super.key, required this.database});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with TickerProviderStateMixin {
  late final AppDatabase database;
  List<Color> gradientColors = [PuventColors.primaryGreen.color, Colors.blue];
  final ScrollController _scrollController = ScrollController();

  ChartRange range = ChartRange.day;
  late TabController rangeTabController;
  late TabController viewTabController;

  int touchedIndex = -1;
  late dynamic dataIndexStartChart = {"finded": false, "index": 0.0};

  List<Order> totalOrders = [];
  List<OrderItemSummary> productsSold = [];

  double totalSales = 0.0;

  //Daily
  late final int day;
  late final int daysInMonth;
  late final DateTime weekStart;
  late final DateTime weekEnd;

  @override
  void initState() {
    super.initState();
    database = widget.database;

    // Inicializamos el tab y los datos de la tabla
    rangeTabController = TabController(length: 3, vsync: this, initialIndex: 0);
    viewTabController = TabController(length: 3, vsync: this, initialIndex: 0);
    range = ChartRange.day;

    // Convierte el timestamp a DateTime
    DateTime now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Día actual
    day = now.day;

    // Semana actual (lunes a domingo)
    weekStart = today.subtract(Duration(days: now.weekday - 1));
    weekEnd = weekStart.add(const Duration(days: 6));

    // Mes actual
    daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    _loadTotalSales();
    _loadTotalOrders();
    _loadSalesByProduct();

    // Inicializa la posición del scroll (por ejemplo, al final)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (dataIndexStartChart["finded"]) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollController.animateTo(
            dataIndexStartChart["index"],
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        });
      }

      // O para una posición específica:
      // _scrollController.jumpTo(200.0);
      // para animarlo:
      // _scrollController.animateTo(200.0,
      //     duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    rangeTabController.dispose();
    viewTabController.dispose();
    super.dispose();
  }

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
              /// Header
              Text(
                "Estadísticas",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),

              Pill(label: "Gráficas"),
              const SizedBox(height: 16),

              // Filtros
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TabBar(
                    controller: rangeTabController,
                    onTap: (value) {
                      setState(() {
                        switch (value) {
                          case 0:
                            range = ChartRange.day;
                            break;
                          case 1:
                            range = ChartRange.week;
                            break;
                          case 2:
                            range = ChartRange.month;
                            break;
                        }
                      });
                      _loadTotalSales();
                      _loadTotalOrders();
                      _loadSalesByProduct();
                    },
                    splashBorderRadius: BorderRadius.circular(30),
                    indicator: BoxDecoration(
                      color: PuventColors.primaryGreen.color,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black54,
                    unselectedLabelStyle: TextStyle(fontSize: 12),
                    tabs: const [
                      Tab(text: "Día"),
                      Tab(text: "Semana"),
                      Tab(text: "Mes"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TabBar(
                        controller: viewTabController,
                        onTap: (value) {
                          setState(() {
                            touchedIndex = value;
                          });
                          _loadTotalSales();
                          _loadTotalOrders();
                        },
                        splashBorderRadius: BorderRadius.circular(30),
                        indicator: BoxDecoration(
                          color: PuventColors.primaryGreen.color,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black54,
                        unselectedLabelStyle: const TextStyle(fontSize: 12),
                        tabs: const [
                          Tab(text: "Ingresos"),
                          Tab(text: "Ventas"),
                          Tab(text: "Reparto"),
                          //Tab(text: "Histórico"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: TabBarView(
                          controller: viewTabController,
                          children: [
                            _buildGeneralView(),
                            _buildVentasView(),
                            _buildRepartoView(),
                           // _buildHistoricoView(),
                          ],
                        ),
                      ),
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

  // ================= LOGIC =================
  Future<void> _loadTotalSales() async {
    final now = DateTime.now();
    double ventasTotales;

    switch (range) {
      case ChartRange.day:
        ventasTotales = await database.getTotalByDay(now);
        break;
      case ChartRange.week:
        ventasTotales = await database.getTotalByRange(
          weekStart,
          weekEnd.add(const Duration(days: 1)),
        );
        break;
      case ChartRange.month:
        ventasTotales = await database.getTotalByMonth(now.year, now.month);
        break;
    }

    if (!mounted) return;
    setState(() {
      totalSales = ventasTotales;
    });
  }

  Future<void> _loadTotalOrders() async {
    final now = DateTime.now();
    List<Order> ttlOrders;

    switch (range) {
      case ChartRange.day:
        ttlOrders = await database.getOrdersByDay(now);
        break;
      case ChartRange.week:
        ttlOrders = await database.getOrdersBetween(
          weekStart,
          weekEnd.add(const Duration(days: 1)),
        );
        break;
      case ChartRange.month:
        ttlOrders = await database.getOrdersByMonth(now.year, now.month);
        break;
    }
    if (!mounted) return;
    setState(() {
      totalOrders = ttlOrders;
    });
  }

  Future<void> _loadSalesByProduct() async {
    final now = DateTime.now();
    List<OrderItemSummary> ttlProducts;

    switch (range) {
      case ChartRange.day:
        ttlProducts = await database.getProductsSoldByDay(now);
        break;
      case ChartRange.week:
        // ttlProducts = await database.getOrdersBetween(
        //   weekStart,
        //   weekEnd.add(const Duration(days: 1)),
        // );
        ttlProducts = await database.getProductsSoldByBetween(
          weekStart,
          weekEnd.add(const Duration(days: 1)),
        );

        break;
      case ChartRange.month:
        // ttlProducts = await database.getOrdersByMonth(now.year, now.month);
        ttlProducts = await database.getProductsSoldByMonth(
          now.year,
          now.month,
        );

        break;
    }
    if (!mounted) return;
    setState(() {
      productsSold = ttlProducts;
    });
  }

  //================VIEWS==================//
  Widget _buildGeneralView() {
    return StreamBuilder<List<Product>>(
      stream: database.watchProducts(),
      builder: (context, snapshot) {
        final products = snapshot.data ?? [];
        final productsAmount = products.length;

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _mainSalesCard(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _kpi(
                      Icons.shopping_cart,
                      "${totalOrders.length}",
                      "Pedidos",
                    ),
                  ),
                  //  const SizedBox(width: 10),
                  //  Expanded(child: _kpi(Icons.receipt_long, "124", "Tickets")),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _kpi(
                      Icons.inventory,
                      "$productsAmount",
                      "Productos",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _flowChartCard(),
              const SizedBox(height: 20),
              _card(context, [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Los 3 más vendidos",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        //cambiar el tap
                        setState(() {
                          viewTabController.index = 1;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: PuventColors.primaryGreen.color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Ver todos",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                productsSold.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: _emptyState(
                          title: "No hubo ventas $currentRangeLabel",
                          subtitle:
                              "Los productos más vendidos aparecerán aquí",
                          icon: Icons.inventory_2_outlined,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: productsSold.length >= 3
                            ? 3
                            : productsSold.length,
                        itemBuilder: (context, index) {
                          final item = productsSold[index];
                          return _cardDetailSale(context, item, index);
                        },
                      ),
              ]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVentasView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _mainProductSaleCard(),
          const SizedBox(height: 20),
          _card(context, [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Todos los productos",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
                //Switch(value: true, onChanged: null),
              ],
            ),
            if (productsSold.isEmpty)
              _emptyState(
                title: "No hay productos vendidos",
                subtitle: "Los productos aparecerán aquí automáticamente",
                icon: Icons.inventory_2_outlined,
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: productsSold.length,
                itemBuilder: (context, index) {
                  final item = productsSold[index];
                  return _cardDetailSale(context, item, index, showDetails: true);
                },
              ),
          ]),
        ],
      ),
    );
  }

  Widget _buildRepartoView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _cakeChartCard(),
          const SizedBox(height: 20),
          _card(context, [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Detalles por producto",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
              ],
            ),
            //     _cardDetailSale(context, [], showDetails: true),
          ]),
        ],
      ),
    );
  }

  Widget _buildHistoricoView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _mainHistorySaleCard(),
          const SizedBox(height: 20),
          _barsChartCard(),
          const SizedBox(height: 20),
          _card(context, [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Desgloze por hora",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
              ],
            ),
            _cardDetailHistory(context, []),
          ]),
        ],
      ),
    );
  }

  String get currentRangeLabel {
    switch (range) {
      case ChartRange.day:
        return "hoy";
      case ChartRange.week:
        return "esta semana";
      case ChartRange.month:
        return "este mes";
    }
  }

  Widget _emptyState({
    String title = "Sin datos disponibles",
    String subtitle = "Aún no hay información para este período",
    IconData icon = Icons.bar_chart_rounded,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, size: 50, color: Colors.grey[400]),
          const SizedBox(height: 16),

          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),

          const SizedBox(height: 8),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }

  //=======================================//
  Widget _kpi(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(label, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  //==============CHARTS==================//
  Widget _flowChartCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tendencia de Ganancias por Ventas",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          AspectRatio(
            aspectRatio: 1.5,
            child: SizedBox(
              height: 220,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: SizedBox(
                  width: _getChartWidth(range),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: LineChart(mainData(range)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cakeChartCard() {
    if (productsSold.isEmpty) {
      return _emptyState(
        title: "No hay distribución disponible",
        subtitle: "Todavía no existen productos vendidos",
        icon: Icons.pie_chart,
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Distribución de Ganancias por Producto",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gráfico circular
              Expanded(
                flex: 2,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(seconds: 2),
                    builder: (context, value, child) {
                      return PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection ==
                                            null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = pieTouchResponse
                                        .touchedSection!
                                        .touchedSectionIndex;
                                  });
                                },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: showingSections(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Leyenda dinámica con soprote para nombres largos
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(productsSold.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Indicator(
                            color: chartColors[i % chartColors.length],
                            text: "", // dejamos vacío porque el texto va aparte
                            isSquare: true,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              productsSold[i].productName,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.visible, // wrap automático
                              softWrap: true,
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
        ],
      ),
    );
  }

  Widget _barsChartCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Distribución por categorias",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          AspectRatio(
            aspectRatio: 1.7,
            child: SizedBox(
              height: 220,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 24 * 25,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: BarChart(mainBarData()),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartData mainBarData() {
    final horas = [
      "08",
      "09",
      "10",
      "11",
      "12",
      "13",
      "14",
      "15",
      "16",
      "17",
      "18",
      "19",
    ];
    final ventas = [35, 20, 40, 35, 20, 40, 35, 20, 40, 35, 20, 40];
    final ingresos = [
      1500,
      900,
      1800,
      1500,
      900,
      1800,
      1500,
      900,
      1800,
      1500,
      900,
      1800,
    ];

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 2000,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipPadding: const EdgeInsets.all(8),
          tooltipMargin: 8,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              textAlign: TextAlign.left,
              "${horas[group.x]} - ${int.parse(horas[group.x]) + 1}\n" // Agregar un formateador de hora
              "${ventas[group.x]} pedidos\n"
              "\$${ingresos[group.x]}",
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => Text(
              horas[value.toInt()],
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: List.generate(horas.length, (i) {
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: ingresos[i].toDouble(),
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.green],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              width: 25,
              borderRadius: BorderRadius.circular(6),
            ),
          ],
        );
      }),
    );
  }

  double _getChartWidth(ChartRange range) {
    switch (range) {
      case ChartRange.day:
        return 24 * 40; // 40px por hora
      case ChartRange.week:
        return 7 * 60;
      case ChartRange.month:
        return daysInMonth * 30;
    }
  }

  String _monthShort(int month) {
    const months = [
      "ene",
      "feb",
      "mar",
      "abr",
      "may",
      "jun",
      "jul",
      "ago",
      "sep",
      "oct",
      "nov",
      "dic",
    ];
    return months[month - 1];
  }

  Widget _card(BuildContext context, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _cardDetailSale(
    BuildContext context,
    OrderItemSummary item,
    int index, {
    bool showDetails = false,
  }) {
    return InkWell(
      onTap: showDetails ? () {} : null,
      child: Card(
        elevation: 0.5,
        color: showDetails ? const Color(0xFFF7FFFC) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bloque con índice y nombre
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(208, 173, 233, 207),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            "#${index + 1}",
                            style: TextStyle(
                              color: PuventColors.primaryGreen.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName,
                                style: const TextStyle(fontSize: 14),
                                maxLines: 2, // máximo dos líneas
                                overflow:
                                    TextOverflow.ellipsis, // corta con "..."
                                softWrap: true,
                              ),
                              Text("${item.totalQuantity} vendidos"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bloque con subtotal y flecha
                  Row(
                    children: [
                      Text(
                        "\$${item.subtotal}",
                        style: TextStyle(
                          color: PuventColors.primaryGreen.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      if (showDetails) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardDetailHistory(
    BuildContext context,
    List<Widget> children, {
    bool showDetails = false,
  }) {
    return InkWell(
      onTap: showDetails ? () {} : null,
      child: Card(
        color: showDetails ? Color(0xFFF7FFFC) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(208, 173, 233, 207),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsetsDirectional.all(5),
                        child: Text(
                          "10-00",
                          style: TextStyle(
                            color: PuventColors.primaryGreen.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text("42 ped"),
                  Text(
                    "\$172,00",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: PuventColors.primaryGreen.color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta, ChartRange range) {
    const style = TextStyle(fontSize: 11);
    String text = "";

    final now = DateTime.now();

    switch (range) {
      case ChartRange.day:
        text = "${value.toInt()}h";
        break;

      case ChartRange.week:
        // Semana actual (lunes a domingo)
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final date = weekStart.add(Duration(days: value.toInt()));
        const days = ["L", "M", "X", "J", "V", "S", "D"];
        text = days[date.weekday - 1];
        break;

      case ChartRange.month:
        final firstDayOfMonth = DateTime(now.year, now.month, 1);
        final date = firstDayOfMonth.add(Duration(days: value.toInt()));
        text = "${date.day} ${_monthShort(date.month)}";
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style),
    );
  }

  double _getMaxY(List<FlSpot> data) {
    if (data.isEmpty) return 0; // evita error si no hay datos

    // obtiene el valor máximo de Y
    double maxY = data.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    // agrega margen visual proporcional
    return maxY + (maxY * 0.1); // 10% de margen
  }

  List<FlSpot> _getChartData(ChartRange range) {
    // final scale = chartWidth / data.length;

    switch (range) {
      case ChartRange.day:
        final Map<int, double> hourlyTotals = {};

        for (final order in totalOrders) {
          final hour = order.createdAt.hour;

          hourlyTotals[hour] = (hourlyTotals[hour] ?? 0) + order.totalAmount;
        }

        return List.generate(24, (hour) {
          final y = hourlyTotals[hour] ?? 0;

          if (!dataIndexStartChart["finded"] && y > 0) {
            dataIndexStartChart["finded"] = true;
            dataIndexStartChart["index"] = hour * 50.0; // escala aproximada
          }

          return FlSpot(hour.toDouble(), hourlyTotals[hour] ?? 0);
        });

      case ChartRange.week:
        final Map<int, double> totalsByDay = {};

        for (final order in totalOrders) {
          final dayIndex = order.createdAt.weekday - 1;

          totalsByDay[dayIndex] =
              (totalsByDay[dayIndex] ?? 0) + order.totalAmount;
        }

        return List.generate(7, (day) {
          return FlSpot(day.toDouble(), totalsByDay[day] ?? 0);
        });

      case ChartRange.month:
        final Map<int, double> totalsByDay = {};

        for (final order in totalOrders) {
          final day = order.createdAt.day;

          totalsByDay[day] = (totalsByDay[day] ?? 0) + order.totalAmount;
        }

        return List.generate(daysInMonth, (index) {
          final day = index + 1;

          return FlSpot(index.toDouble(), totalsByDay[day] ?? 0);
        });
    }
  }

  LineChartData mainData(ChartRange range) {
    final data = _getChartData(range);

    return LineChartData(
      // Este bloque muestra lineas de grid
      gridData: FlGridData(show: false, drawVerticalLine: true),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 25,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (range == ChartRange.month && value % 2 != 0) {
                return Container(); // oculta labels intermedios
              }
              return bottomTitleWidgets(value, meta, range);
            },
          ),
        ),
      ),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipPadding: const EdgeInsets.all(8),
          fitInsideHorizontally: true, // evita que se salga por los lados
          fitInsideVertically: true, // mantiene el tooltip dentro del gráfico
          tooltipMargin: 10, // distancia entre el punto y el tooltip
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              return LineTooltipItem(
                'Ventas: \$${spot.y.toStringAsFixed(2)}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            }).toList();
          },
        ),
        touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
          // opcional: puedes usar esto para animar o registrar el punto tocado
        },
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: Colors.white),
      ),
      minX: range != ChartRange.month ? 0 : -0.4,
      maxX: range != ChartRange.month
          ? data.length.toDouble() - 1
          : data.length.toDouble() - 0.4,
      minY: 0,
      maxY: _getMaxY(data),
      lineBarsData: [
        LineChartBarData(
          spots: data,
          //curveSmoothness: 0.1
          isCurved: false,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withValues(alpha: 0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  //==============MAIN CARDS==================//
  Widget _mainSalesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, PuventColors.primaryGreen.color],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ingresos Totales",
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 6),
              Text(
                "$totalSales",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: const [
                  Icon(Icons.trending_up, color: Colors.white, size: 18),
                  SizedBox(width: 4),
                  Text("+2.9%", style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.attach_money,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainProductSaleCard() {
    if (productsSold.isEmpty || productsSold[0] == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color.fromARGB(255, 255, 230, 154)),
          color: const Color.fromARGB(255, 255, 250, 235),
        ),
        child: const Text(
          "Aún no hay registros",
          style: TextStyle(
            color: Color(0xFF876500),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    final item = productsSold[0];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromARGB(255, 255, 230, 154)),
        color: const Color.fromARGB(255, 255, 250, 235),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(Icons.star, color: Colors.amber, size: 18),
                ),
                TextSpan(
                  text: " Más vendido",
                  style: const TextStyle(
                    color: Color(0xFF876500),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${productsSold[0].productName}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${productsSold[0].totalQuantity}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "unidades vendidas",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "\$${item!.subtotal}",
                    style: TextStyle(
                      color: PuventColors.primaryGreen.color,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "ingresos",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mainHistorySaleCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFA4CBF6)),
        color: const Color.fromARGB(255, 228, 241, 255),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.access_time,
                        color: const Color.fromARGB(255, 52, 116, 184),
                        size: 18,
                      ),
                    ),
                    TextSpan(
                      text: " Hora Pico",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 52, 116, 184),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),
              Text(
                "19:00 - 21:00",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "35",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Pedidos",
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\$185.00",
                        style: TextStyle(
                          color: PuventColors.primaryGreen.color,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Ingresos",
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  final List<Color> chartColors = [
    Colors.blue,
    Colors.amber,
    Colors.purple,
    Colors.green,
    Colors.red,
    Colors.teal,
  ];

  List<PieChartSectionData> showingSections() {
    final total = productsSold.fold<double>(
      0,
      (sum, item) => sum + item.subtotal,
    );

    return List.generate(productsSold.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      final item = productsSold[i];
      final value = item.subtotal;
      final percentage = total == 0 ? 0 : (value / total * 100);

      return PieChartSectionData(
        color: chartColors[i % chartColors.length], // asigna color fijo
        value: value,
        title: isTouched ? "${percentage.toStringAsFixed(1)}%" : "",
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
          shadows: shadows,
        ),
      );
    });
  }

  // Top Sell
  // Distributon
  // History
}

// obtener venta(dinero) total del Día, Semana, Mes
// obtener cual fue el porcentaje de ganancia o perdida respecto al dia anterior, a la semana anterior y al mes anterior

// obtener cantidad de pedidos hechos, al día, semana y mes

//Obtener datos para la tabla, ganancias del día, de la semana, del mes

//Obtener los 3 productos más vendidos del día, de la semana, del mes

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
