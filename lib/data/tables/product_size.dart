import 'package:drift/drift.dart';

class ProductSizes extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}