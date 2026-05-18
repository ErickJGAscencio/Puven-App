import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:localix/data/tables/order_items.dart';
import 'package:localix/data/tables/orders.dart';
import 'package:localix/data/tables/product_size.dart';
import 'package:localix/data/tables/cash_sesion.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/products.dart';
import 'tables/product_variants.dart';

part 'database.g.dart';

class DatabaseProvider {
  static final AppDatabase instance = AppDatabase();
}

@DriftDatabase(
  tables: [
    Products,
    ProductVariants,
    ProductSizes,
    Orders,
    OrderItems,
    CashSessions,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      // Se ejecuta la primera vez que se crea la base
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 7) {
        // Limpiar órdenes antiguas que fueron guardadas con zona horaria UTC incorrecta
        // Para evitar inconsistencias de fechas
        // await customStatement('DELETE FROM order_items');
        // await customStatement('DELETE FROM orders');
        await m.createAll();
      }
      if (from == 6) {
        // Definir que hacer al pasar de version X a Y
        await m.addColumn(cashSessions, cashSessions.lastInteraction);
        ////////////////////////////

        await m.createAll();
        // await m.createTable(cashSessions);

        // Insertar tamaño "Único"
        // await into(
        //   productSizes,
        //).insert(ProductSizesCompanion.insert(name: "UNICO"));

        ///////////////////////
        //   print("ACTUAIZA");
        //   await m.createTable(productVariants);
        //   await customStatement('''
        //   INSERT INTO product_variants (id, product_id, size, price, price_per_kg)
        //   SELECT id, product_id, size, price, price_per_kg FROM product_variants_old;
        // ''');
        // //////////////////
        //         // 1. Añadir la columna en la nueva tabla
        // await m.addColumn(orderItems, orderItems.createdAt);

        //       // 2. Copiar datos de la columna antigua a la nueva
        //       await customStatement('''
        //         UPDATE product_variants
        //         SET price_per_kg = (
        //           SELECT price_per_kg FROM products
        //           WHERE products.id = product_variants.product_id
        //         )
        //       ''');
        //////////////////////
      }
    },
    beforeOpen: (details) async {
      // Para acciones antes de abrir la base
    },
  );

  // CRUD operations for Products
  Future<int> insertProduct(ProductsCompanion product) =>
      into(products).insert(product);
  Stream<List<Product>> watchProducts() {
    return select(products).watch();
  }

  Future<List<Product>> getAllProducts() => select(products).get();
  Future deleteProduct(int id) =>
      (delete(products)..where((tbl) => tbl.productId.equals(id))).go();
  Future updateProduct(Product product) => update(products).replace(product);

  // CRUD operations for Variants
  Future<int> insertVariant(ProductVariantsCompanion variant) =>
      into(productVariants).insert(variant);
  Future<List<ProductVariant>> getAllVariants() =>
      select(productVariants).get();
  Future<List<ProductVariant>> getVariantsByProduct(int productId) {
    return (select(
      productVariants,
    )..where((tbl) => tbl.productId.equals(productId))).get();
  }

  Stream<List<ProductVariant>> watchVariants(int productId) {
    return (select(
      productVariants,
    )..where((tbl) => tbl.productId.equals(productId))).watch();
  }

  Future deleteVariantsByProduct(int productId) => (delete(
    productVariants,
  )..where((tbl) => tbl.productId.equals(productId))).go();
  Future updateVariant(ProductVariant variant) =>
      update(productVariants).replace(variant);
  Stream<List<(ProductVariant, ProductSize)>> watchVariantsWithSize(
    int productId,
  ) {
    final query = select(productVariants).join([
      innerJoin(
        productSizes,
        productSizes.productSizeId.equalsExp(productVariants.productSizeId),
      ),
    ])..where(productVariants.productId.equals(productId));

    return query.watch().map((rows) {
      return rows.map((row) {
        return (row.readTable(productVariants), row.readTable(productSizes));
      }).toList();
    });
  }

  // CRUD operations for Sizes
  Future<int> insertSize(ProductSizesCompanion size) =>
      into(productSizes).insert(size);
  Stream<List<ProductSize>> watchSizes() => select(productSizes).watch();
  Future<List<ProductSize>> getAllSizes() => select(productSizes).get();
  Future deleteSize(int id) =>
      (delete(productSizes)..where((tbl) => tbl.productSizeId.equals(id))).go();
  Future updateSize(ProductSize size) => update(productSizes).replace(size);

  // CRUD operations for Orders
  Future<int> insertOrder(OrdersCompanion order) => into(orders).insert(order);
  Stream<List<Order>> watchOrders() => select(orders).watch();
  Future<List<Order>> getAllOrders() => select(orders).get();
  Future deleteOrder(int id) =>
      (delete(orders)..where((tbl) => tbl.orderId.equals(id))).go();
  Future updateOrder(Order order) => update(orders).replace(order);

  // CRUD for orders rangess
  Future<List<Order>> getOrdersByDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));

    return (select(
      orders,
    )..where((o) => o.createdAt.isBetweenValues(start, end))).get();
  }

  Future<List<Order>> getOrdersBetween(DateTime start, DateTime end) {
    return (select(
      orders,
    )..where((o) => o.createdAt.isBetweenValues(start, end))).get();
  }

  Future<List<Order>> getOrdersByMonth(int year, int month) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);

    return (select(
      orders,
    )..where((o) => o.createdAt.isBetweenValues(start, end))).get();
  }

  // CRUD for products sold per range
  Future<List<OrderItemSummary>> getProductsSoldByDay(DateTime day) async {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));

    final results = await customSelect(
      'SELECT o.variant_id, p.name AS product_name, SUM(quantity) AS total_quantity, SUM(subtotal) AS total_subtotal '
      'FROM order_items o '
      'INNER JOIN products p ON p.product_id = o.variant_id '
      'WHERE o.created_at >= ? AND o.created_at < ? '
      'GROUP BY o.variant_id, p.name '
      'ORDER BY total_quantity DESC',
      variables: [Variable.withDateTime(start), Variable.withDateTime(end)],
      readsFrom: {orderItems, products},
    ).get();

    return results.map((row) {
      return OrderItemSummary(
        variantId: row.read<int>('variant_id'),
        productName: row.read<String>('product_name'),
        totalQuantity: row.read<int>('total_quantity'),
        subtotal: row.read<double>('total_subtotal'),
      );
    }).toList();
  }

  Future<List<OrderItemSummary>> getProductsSoldByBetween(
    DateTime start,
    DateTime end,
  ) async {
    final results = await customSelect(
      'SELECT o.variant_id, p.name AS product_name, SUM(quantity) AS total_quantity, SUM(subtotal) AS total_subtotal '
      'FROM order_items o '
      'INNER JOIN products p ON p.product_id = o.variant_id '
      'WHERE o.created_at >= ? AND o.created_at < ? '
      'GROUP BY o.variant_id, p.name '
      'ORDER BY total_quantity DESC',
      variables: [Variable.withDateTime(start), Variable.withDateTime(end)],
      readsFrom: {orderItems, products},
    ).get();

    // final result =
    //     await (selectOnly(orders)
    //           ..addColumns([orders.totalAmount.sum()])
    //           ..where(orders.createdAt.isBetweenValues(start, end)))
    //         .getSingle();

    return results.map((row) {
      return OrderItemSummary(
        variantId: row.read<int>('variant_id'),
        productName: row.read<String>('product_name'),
        totalQuantity: row.read<int>('total_quantity'),
        subtotal: row.read<double>('total_subtotal'),
      );
    }).toList();
  }

  Future<List<OrderItemSummary>> getProductsSoldByMonth(
    int year,
    int month,
  ) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);

    final results = await customSelect(
      'SELECT o.variant_id, p.name AS product_name, SUM(quantity) AS total_quantity, SUM(subtotal) AS total_subtotal '
      'FROM order_items o '
      'INNER JOIN products p ON p.product_id = o.variant_id '
      'WHERE o.created_at >= ? AND o.created_at < ? '
      'GROUP BY o.variant_id, p.name '
      'ORDER BY total_quantity DESC',
      variables: [Variable.withDateTime(start), Variable.withDateTime(end)],
      readsFrom: {orderItems, products},
    ).get();

    final result =
        await (selectOnly(orders)
              ..addColumns([orders.totalAmount.sum()])
              ..where(orders.createdAt.isBetweenValues(start, end)))
            .getSingle();

    return results.map((row) {
      return OrderItemSummary(
        variantId: row.read<int>('variant_id'),
        productName: row.read<String>('product_name'),
        totalQuantity: row.read<int>('total_quantity'),
        subtotal: row.read<double>('total_subtotal'),
      );
    }).toList();
  }

  // CRUD for total sales by rangess
  Future<double> getTotalByDay(DateTime day) async {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));

    final result =
        await (selectOnly(orders)
              ..addColumns([orders.totalAmount.sum()])
              ..where(orders.createdAt.isBetweenValues(start, end)))
            .getSingle();

    return result.read(orders.totalAmount.sum()) ?? 0.0;
  }

  Future<double> getTotalByRange(DateTime start, DateTime end) async {
    final result =
        await (selectOnly(orders)
              ..addColumns([orders.totalAmount.sum()])
              ..where(orders.createdAt.isBetweenValues(start, end)))
            .getSingle();

    return result.read(orders.totalAmount.sum()) ?? 0.0;
  }

  Future<double> getTotalByMonth(int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);

    final result =
        await (selectOnly(orders)
              ..addColumns([orders.totalAmount.sum()])
              ..where(orders.createdAt.isBetweenValues(start, end)))
            .getSingle();

    return result.read(orders.totalAmount.sum()) ?? 0.0;
  }

  Future<int> getUniqueSizeId() async {
    final existing = await (select(
      productSizes,
    )..where((tbl) => tbl.name.equals("UNICO"))).getSingleOrNull();

    if (existing != null) return existing.productSizeId;

    await into(productSizes).insert(
      ProductSizesCompanion.insert(name: "UNICO"),
      mode: InsertMode.insertOrIgnore,
    );

    final created = await (select(
      productSizes,
    )..where((tbl) => tbl.name.equals("UNICO"))).getSingle();

    return created.productSizeId;
  }

  // CRUD operations for Items Order
  Future<int> insertOrderItem(OrderItemsCompanion orderItem) =>
      into(orderItems).insert(orderItem);
  Stream<List<OrderItem>> watchOrderItems() => select(orderItems).watch();
  Future<List<OrderItem>> getAllOrderItems() => select(orderItems).get();
  Future<List<OrderItem>> getAllOrderItemsByOrder(int orderId) {
    return (select(
      orderItems,
    )..where((tbl) => tbl.orderId.equals(orderId))).get();
  }

  Future<List<(OrderItem, Product, ProductSize)>> getOrderDetails(
    int orderId,
  ) async {
    final query = select(orderItems).join([
      innerJoin(
        productVariants,
        productVariants.productVariantId.equalsExp(orderItems.variantId),
      ),
      innerJoin(
        products,
        products.productId.equalsExp(productVariants.productId),
      ),
      innerJoin(
        productSizes,
        productSizes.productSizeId.equalsExp(productVariants.productSizeId),
      ),
    ])..where(orderItems.orderId.equals(orderId));

    final rows = await query.get();

    return rows.map((row) {
      final item = row.readTable(orderItems);
      final product = row.readTable(products);
      final size = row.readTable(productSizes);

      return (item, product, size);
    }).toList();
  }

  Future deleteOrderItem(int id) =>
      (delete(orderItems)..where((tbl) => tbl.orderItemId.equals(id))).go();
  Future updateOrderItem(OrderItem orderItem) =>
      (update(orderItems).replace(orderItem));

  // CRUD History sales
  Future<List<Order>> getOrdersPage({
    required int limit,
    required int offset,
    required String search,
  }) {
    if (search.isNotEmpty) {
      return (select(orders)
            ..orderBy([(o) => OrderingTerm.desc(o.createdAt)])
            ..limit(limit, offset: offset)
            ..where((o) => o.folio.like('%$search%')))
          .get();
    }

    return (select(orders)
          ..orderBy([(o) => OrderingTerm.desc(o.createdAt)])
          ..limit(limit, offset: offset))
        .get();
  }

  // CRUD for CashSessions
  Future<int> insertCashSession(CashSessionsCompanion cashSession) =>
      into(cashSessions).insert(cashSession);

  Future<CashSession?> getCashSessionOpened() {
    return (select(
      cashSessions,
    )..where((tbl) => tbl.status.equals("open"))).getSingleOrNull();
  }

  Future<void> closeCashSession(
    int id,
    String closedBy,
    double finalCash,
    double expectedCash,
    String status,
    String type
  ) async {
    await (update(
      cashSessions,
    )..where((tbl) => tbl.cashSesionId.equals(id))).write(
      CashSessionsCompanion(
        closedAt: Value(DateTime.now()),
        closedBy: Value(closedBy),
        closingAmount: Value(finalCash), 
        expectedAmount: Value(expectedCash),
        status: Value(status),
        closeReason: Value(type)
      ),
    );
  }

  /// Actualiza la última interacción de una sesión de caja abierta
  /// Se debe llamar cada vez que hay actividad del usuario
  Future<void> updateLastInteraction(int cashSessionId) async {
    await (update(cashSessions)
          ..where((tbl) => tbl.cashSesionId.equals(cashSessionId)))
        .write(
      CashSessionsCompanion(
        lastInteraction: Value(DateTime.now()),
      ),
    );
  }

  /// Obtiene cajas abiertas de un día específico
  /// Útil para detectar si hay caja abierta desde otro día
  Future<List<CashSession>> getCashSessionsByDay(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return (select(cashSessions)
          ..where((tbl) =>
              tbl.openedAt.isBetweenValues(startOfDay, endOfDay) &
              tbl.status.equals("open")))
        .get();
  }

  /// Obtiene la sesión de caja abierta más reciente sin importar la fecha
  /// Útil para validar si hay caja abierta desde hace varios días
  Future<CashSession?> getLatestOpenCashSession() {
    return (select(cashSessions)
          ..where((tbl) => tbl.status.equals("open"))
          ..orderBy([(t) => OrderingTerm.desc(t.openedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Actualiza el tipo de sesión (para marcar como "temporal" si hay inactividad)
  Future<void> updateCashSessionType(int cashSessionId, String type) async {
    await (update(cashSessions)
          ..where((tbl) => tbl.cashSesionId.equals(cashSessionId)))
        .write(
      CashSessionsCompanion(
        closeReason: Value(type),
      ),
    );
  }

}

class TotalByHour {
  final int hour;
  final double total;
  TotalByHour({required this.hour, required this.total});
}

class TotalByDay {
  final String day;
  final double total;
  TotalByDay({required this.day, required this.total});
}

class OrderItemSummary {
  final int variantId;
  final int totalQuantity;
  final double subtotal;
  final String productName;
  OrderItemSummary({
    required this.variantId,
    required this.productName,
    required this.totalQuantity,
    required this.subtotal,
  });
}

//conexión SQLite
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.sqlite'));
    return NativeDatabase(file);
  });
}
