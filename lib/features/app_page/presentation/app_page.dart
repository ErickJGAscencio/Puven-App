
import 'package:flutter/material.dart';
import 'package:localix/features/home/presentation/home_page.dart';
import 'package:localix/features/my_products/presentation/my_products_page.dart';
import 'package:localix/widgets/app_drawer.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int currentIndex = 0;

  final pages = [
    const HomePage(),
    const MyProductsPage(),
  ];

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
      drawer: AppDrawer(
        currentIndex: currentIndex,
        onItemSelected: _onSelect,
      ),
      body: pages[currentIndex],
    );
  }
}