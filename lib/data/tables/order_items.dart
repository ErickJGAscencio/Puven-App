import 'package:drift/drift.dart';
import 'package:localix/data/tables/orders.dart';
import 'package:localix/data/tables/product_variants.dart';

class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(Orders, #id)();
  IntColumn get variantId => integer().nullable().references(ProductVariants, #id)();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  RealColumn get quantityDecimal => real().nullable()();
  RealColumn get unitPrice => real()();
  RealColumn get subtotal => real()();
  TextColumn get notes => text().nullable()();
}
