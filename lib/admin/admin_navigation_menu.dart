import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class AdminNavigationMenu extends StatefulWidget {
  final void Function(int index)? updateNavIndex;
  const AdminNavigationMenu(
      {Key? key, required this.navigationShell, this.updateNavIndex})
      : super(key: key);

  final StatefulNavigationShell navigationShell;

  @override
  State<AdminNavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<AdminNavigationMenu> {
  static int nav_index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: widget.navigationShell,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        height: 80,
        elevation: 0,
        selectedIndex: nav_index,
        onDestinationSelected: (value) {
          setState(() {
            nav_index = value;
          });
          goToBranch(nav_index);
        },
        destinations: [
          NavigationDestination(
              icon: Icon(Icons.dashboard), label: "Dashboard"),
          NavigationDestination(icon: Icon(Icons.set_meal), label: "Products"),
          NavigationDestination(
              icon: Icon(Icons.assignment_rounded), label: "Orders"),
          NavigationDestination(
              icon: Icon(Icons.delivery_dining), label: "Deliveries"),
          NavigationDestination(
              icon: Icon(Icons.report_gmailerrorred), label: "Concerns"),
        ],
      ),
    );
  }

  void goToBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}
