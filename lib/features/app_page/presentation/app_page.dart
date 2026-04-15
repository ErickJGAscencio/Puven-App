import 'package:flutter/material.dart';
import 'package:localix/data/database.dart';
import 'package:localix/features/home/presentation/home_page.dart';
import 'package:localix/features/my_products/presentation/my_products_page.dart';
import 'package:localix/widgets/app_drawer.dart';

enum PuventColors {
  primaryGreen,
  accentBlue,
  warningRed,
  neutralGray,
  primaryGreyText,
}

extension PuventColorsExtension on PuventColors {
  Color get color {
    switch (this) {
      case PuventColors.primaryGreen:
        return const Color(0xFF00B982);
      case PuventColors.accentBlue:
        return const Color(0xFF2196F3);
      case PuventColors.warningRed:
        return const Color(0xFFF44336);
      case PuventColors.neutralGray:
        return const Color(0xFF9E9E9E);
      case PuventColors.primaryGreyText:
        return const Color(0xFF6C718F);
    }
  }
}


class AppPage extends StatefulWidget {
  final AppDatabase database;
  const AppPage({super.key, required this.database});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int currentIndex = 1;
  late final AppDatabase database;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    database = widget.database;

    // El orden en que estén los widgets es el orden en que se definen en AppDrawer
    pages = [
      HomePage(database: database),
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
      appBar: AppBar(
        title: Text("Puven"),
        backgroundColor: Colors.white,
        ),
      drawer: AppDrawer(currentIndex: currentIndex, onItemSelected: _onSelect),
      body: pages[currentIndex],
    );
  }
}
