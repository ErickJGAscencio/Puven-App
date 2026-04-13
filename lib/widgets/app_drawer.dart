import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget{
  final Function(int) onItemSelected;
  final int currentIndex;

  const AppDrawer({
    super.key,
    required this.onItemSelected,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context){
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue
            ),
            child: Align(alignment: Alignment.bottomLeft,child: Text("Puven", style: TextStyle(
            color: Colors.white, fontSize: 20
          ),),)),
          _drawerItem(
            icon: Icons.inventory,
            text: "Punto de Venta",
            index: 0,
          ),
          _drawerItem(
            icon: Icons.inventory,
            text: "Mis productos",
            index: 1,
          ),

          const Spacer(),

          const Divider(),

          _drawerItem(
            icon: Icons.logout,
            text: "Cerrar sesión",
            index: 2,
          ),
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
      leading: Icon(icon),
      title: Text(text),
      selected: currentIndex == index,
      onTap: () => onItemSelected(index),
    );
  }
}