import 'package:flutter/material.dart';
import 'package:localix/data/database.dart';
import 'app/app.dart';

void main() {
  final db = AppDatabase();
  runApp(MyApp(database: db));
}