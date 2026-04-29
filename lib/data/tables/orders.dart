import 'package:drift/drift.dart';

class Orders extends Table {
  IntColumn get orderId => integer().autoIncrement()();
  TextColumn get folio => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  RealColumn get totalAmount => real()();
  // Status del proceso dle pedido
    /*
      Pendiente
      En preparación
      Listo
      Entregado 
      */
  TextColumn get processStatus =>
      text().withDefault(const Constant("Pendiente"))();

  TextColumn get paymentMethod => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get deliveredAt => dateTime().nullable()();
}
