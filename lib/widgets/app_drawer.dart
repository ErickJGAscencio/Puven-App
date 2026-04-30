import 'package:flutter/material.dart';
import 'package:localix/features/app_page/presentation/app_page.dart';

class AppDrawer extends StatelessWidget {
  final Function(int) onItemSelected;
  final int currentIndex;

  const AppDrawer({
    super.key,
    required this.onItemSelected,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
      ),
      backgroundColor: PuventColors.background.color,
      elevation: 5.0,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: PuventColors.primaryGreen.color),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Puven",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          _drawerItem(icon: Icons.login, text: "Acceder", index: 0),
          _drawerItem(
            icon: Icons.point_of_sale,
            text: "Punto de Venta",
            index: 1,
          ),
          _drawerItem(icon: Icons.inventory, text: "Mis productos", index: 2),
          _drawerItem(icon: Icons.table_chart, text: "Estadísticas", index: 3),
          _drawerItem(
            icon: Icons.history,
            text: "Historial de Ventas",
            index: 4,
          ),
          _drawerItem(icon: Icons.group, text: "Colaboradores", index: 5),
          _drawerItem(icon: Icons.settings, text: "Configuraciones", index: 6),
          _drawerItem(
            icon: Icons.workspace_premium,
            text: "Mejorar Plan",
            index: 7,
          ),
          const Spacer(),
          const Divider(),
          _drawerItem(icon: Icons.logout, text: "Cerrar sesión", index: 8),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String text,
    required int index,
  }) {
    return ListTile(
      selectedColor: PuventColors.primaryGreen.color,
      leading: Icon(icon),
      title: Text(text),
      selected: currentIndex == index,
      onTap: () => onItemSelected(index),
    );
  }
  
}
