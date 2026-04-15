import 'package:drift/drift.dart';

class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  RealColumn get totalAmount => real()();
  TextColumn get status => text().withDefault(const Constant("Pendiente"))();
  TextColumn get paymentMethod => text().nullable()();
  TextColumn get notes => text().nullable()();
}
