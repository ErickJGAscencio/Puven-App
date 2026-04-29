import 'package:drift/drift.dart';
import 'package:localix/data/tables/product_size.dart';
import 'package:localix/data/tables/products.dart';

class ProductVariants extends Table{
  IntColumn get productVariantId => integer().autoIncrement()();
  IntColumn get productId => integer().references(Products, #productId)();
  IntColumn get productSizeId => integer().references(ProductSizes, #productSizeId)();
  RealColumn get price => real().nullable()();
  RealColumn get pricePerKg => real().nullable()();
}