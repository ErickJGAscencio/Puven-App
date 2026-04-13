import 'package:flutter/material.dart';
import 'package:localix/data/database.dart';
import 'package:localix/features/home/presentation/home_page.dart';
import 'package:localix/features/my_products/presentation/my_products_page.dart';
import 'package:localix/widgets/app_drawer.dart';

class AppPage extends StatefulWidget {
  final AppDatabase database;
  const AppPage({super.key, required this.database});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int currentIndex = 0;
  late final AppDatabase database;
  late final List<Widget> pages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database = widget.database;

    pages = [
      HomePage(database: database),
      MyProductsPage(database: database),
    ];
  }

  void _onSelect(int index) {
    Navigator.pop(context);

    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Puven")),
      drawer: AppDrawer(currentIndex: currentIndex, onItemSelected: _onSelect),
      body: pages[currentIndex],
    );
  }
}
