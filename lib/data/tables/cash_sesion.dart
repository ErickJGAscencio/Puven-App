import 'package:drift/drift.dart';

class CashSessions extends Table{
  IntColumn get cashSesionId => integer().autoIncrement()();
  
  DateTimeColumn get openedAt => dateTime()();
  DateTimeColumn get closedAt => dateTime().nullable()();

  TextColumn get openedBy => text()();
  TextColumn get closedBy => text().nullable()();
  
  RealColumn get openingAmount => real()();
  RealColumn get closingAmount => real().nullable()();
  RealColumn get expectedAmount => real().nullable()();

  TextColumn get status => text().withDefault(Constant('open'))();
}