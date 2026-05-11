import 'package:drift/drift.dart';


class CashSesion extends Table{
  IntColumn get cashSesionId => integer().autoIncrement()();
  DateTimeColumn get openedAt => dateTime()();
  DateTimeColumn get closedAt => dateTime()();
  TextColumn get openedBy => text()();
  TextColumn get closedBy => text()();
  RealColumn get initialCash => real()();
  RealColumn get finalCash => real()();
}