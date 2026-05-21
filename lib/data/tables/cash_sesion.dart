import 'package:drift/drift.dart';

enum CloseReason{
  none,
  normal,
  inactivity,
  temporallyClosed,
  dayClosed,
  forced
}

class CloseReasonConverter extends TypeConverter<CloseReason, String> {
  const CloseReasonConverter();

  @override
  CloseReason fromSql(String fromDB){
    return CloseReason.values.firstWhere((e) => e.name == fromDB, orElse: () => CloseReason.none);
  }
  @override
  String toSql(CloseReason value) => value.name;
}

class CashSessions extends Table{
  IntColumn get cashSesionId => integer().autoIncrement()();
  
  DateTimeColumn get lastInteraction => dateTime()();
  DateTimeColumn get openedAt => dateTime()();
  DateTimeColumn get closedAt => dateTime().nullable()();

  TextColumn get openedBy => text()();
  TextColumn get closedBy => text().nullable()();
  
  RealColumn get openingAmount => real()();
  RealColumn get closingAmount => real().nullable()();
  RealColumn get expectedAmount => real().nullable()();

  TextColumn get status => text().withDefault(Constant('open'))();
  TextColumn get closeReason => text().map(const CloseReasonConverter()).withDefault(Constant('none'))();

  /*
    * none - sin cierre registrado
   * normal - cierre normal
   * temporal - caja abierta con inactividad
   * forced - cierre inesperado de la app
   */
}