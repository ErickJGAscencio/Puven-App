import 'package:drift/drift.dart';

class ProductSizes extends Table{
  IntColumn get productSizeId => integer().autoIncrement()();
  TextColumn get name => text()();
}