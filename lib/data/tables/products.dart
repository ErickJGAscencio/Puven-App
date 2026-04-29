import 'package:drift/drift.dart';

class Products extends Table{
  IntColumn get productId => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get hasSizes => boolean().withDefault(const Constant(false))();
  BoolColumn get isByGrams => boolean().withDefault(const Constant(false))();
}