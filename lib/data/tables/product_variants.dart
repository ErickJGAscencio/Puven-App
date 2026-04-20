import 'package:drift/drift.dart';
import 'package:localix/data/tables/product_size.dart';
import 'package:localix/data/tables/products.dart';

class ProductVariants extends Table{
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get size => integer().references(ProductSizes, #id)();
  RealColumn get price => real().nullable()();
  RealColumn get pricePerKg => real().nullable()();
}