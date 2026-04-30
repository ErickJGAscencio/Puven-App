import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:localix/features/app_page/presentation/app_page.dart';
import 'package:localix/widgets/pill.dart';

enum ChartRange { day, week, month }

enum ChartFilter { gen, top, dis, his }

class StatisticsPage extends StatefulWidget {
  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<Color> gradientColors = [PuventColors.primaryGreen.color, Colors.blue];

  ChartRange range = ChartRange.week;

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
              DefaultTabController(
                length: 3,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TabBar(
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
              ),
              const SizedBox(height: 10),

              Expanded(
                child: DefaultTabController(
                  length: 4,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)
                        ),
                        child: TabBar(
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
                            Tab(text: "General"),
                            Tab(text: "Ventas"),
                            Tab(text: "Reparto"),
                            Tab(text: "Histórico"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: TabBarView(
                            children: [
                              _buildGeneralView(),
                              _buildVentasView(),
                              _buildGeneralView(),
                              _buildGeneralView(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //================VIEWS===================//
  Widget _buildGeneralView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          _mainSalesCard(),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _kpi(Icons.shopping_cart, "250", "Pedidos")),
              const SizedBox(width: 10),
              Expanded(child: _kpi(Icons.receipt_long, "124", "Tickets")),
              const SizedBox(width: 10),
              Expanded(child: _kpi(Icons.inventory, "15", "Productos")),
            ],
          ),
          const SizedBox(height: 20),
          _chartCard(),
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
                  onTap: () {
                    //cambiar el tap
                  },
                  child: Text("Ver todos"),
                ),
              ],
            ),
            _cardDetailSale(context, []),
          ]),
        ],
      ),
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
                Text("Ver todos"),
              ],
            ),
            _cardDetailSale(context, [], showDetails: true),
          ]),
        ],
      ),
    );
  }

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

  Widget _chartCard() {
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
            "Tendencia de Ventas",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          AspectRatio(
            aspectRatio: 1.7,
            child: SizedBox(
              height: 220,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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

  double _getChartWidth(ChartRange range) {
    switch (range) {
      case ChartRange.day:
        return 24 * 40; // 40px por hora
      case ChartRange.week:
        return 7 * 60;
      case ChartRange.month:
        return 30 * 40;
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
    List<Widget> children, {
    bool showDetails = false,
  }) {
    return InkWell(
      onTap: showDetails ? () {} : null,
      child: Card(
        color: showDetails ? Color.fromARGB(208, 239, 255, 248) : Colors.white,
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
                          color: Color.fromARGB(208, 154, 221, 192),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsetsDirectional.all(5),
                        child: Text(
                          "#1",
                          style: TextStyle(
                            color: PuventColors.primaryGreen.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text("NombreProducto"), Text("3 vendidos")],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "\$17,123.00",
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

  Widget bottomTitleWidgets(double value, TitleMeta meta, ChartRange range) {
    const style = TextStyle(fontSize: 11);

    String text = "";

    final now = DateTime.now();

    switch (range) {
      case ChartRange.day:
        text = "${value.toInt()}h";
        break;

      case ChartRange.week:
        final date = now.subtract(Duration(days: 6 - value.toInt()));
        const days = ["L", "M", "X", "J", "V", "S", "D"];
        text = days[date.weekday - 1];
        break;

      case ChartRange.month:
        final date = now.subtract(Duration(days: 29 - value.toInt()));

        text = "${date.day} ${_monthShort(date.month)}";
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style),
    );
  }

  double _getMaxY(List<FlSpot> data) {
    double maxY = data.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    return maxY + 2; // margen visual
  }

  List<FlSpot> _getChartData(ChartRange range) {
    switch (range) {
      case ChartRange.day:
        // 24 horas
        return List.generate(24, (i) {
          return FlSpot(i.toDouble(), (i % 5 + 2).toDouble());
        });

      case ChartRange.week:
        // 7 días
        return List.generate(7, (i) {
          return FlSpot(i.toDouble(), (i * 1.5 + 2));
        });

      case ChartRange.month:
        // 30 días
        return List.generate(30, (i) {
          return FlSpot(i.toDouble(), (i % 6 + 1).toDouble());
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
            // reservedSize: 25,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (range == ChartRange.month && value % 3 != 0) {
                return Container(); // oculta labels intermedios
              }
              return bottomTitleWidgets(value, meta, range);
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: data.length.toDouble() - 1,
      minY: 0,
      maxY: _getMaxY(data),
      lineBarsData: [
        LineChartBarData(
          spots: data,
          isCurved: true,
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

  // General
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
                "Ventas Totales",
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 6),
              const Text(
                "\$35,500",
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromARGB(255, 255, 230, 154)),
        color: const Color.fromARGB(255, 255, 250, 235),
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
                      child: Icon(Icons.star, color: Colors.amber, size: 18),
                    ),
                    TextSpan(
                      text: " Más vendido",
                      style: TextStyle(
                        color: const Color(0xFF876500),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),
              Text(
                "Pizza Pepperoni",
                style: TextStyle(
                  fontSize: 22,
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
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "unidades vendidas",
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

  // Top Sell
  // Distributon
  // History
}



// obtener venta(dinero) total del Día, Semana, Mes
// obtener cual fue el porcentaje de ganancia o perdida respecto al dia anterior, a la semana anterior y al mes anterior

// obtener cantidad de pedidos hechos, al día, semana y mes

//Obtener datos para la tabla, ganancias del día, de la semana, del mes

//Obtener los 3 productos más vendidos del día, de la semana, del mes

