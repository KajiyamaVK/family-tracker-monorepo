import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/features/menu/menu_page.dart';

class ScaffoldWithNavBar extends StatefulWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key,
  });

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: widget.navigationShell,
      endDrawer: const Drawer(
        child: MenuPage(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: (int index) => _onTap(context, index),
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_add_outlined),
            selectedIcon: Icon(Icons.person_add),
            label: 'Add Family',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_location_alt_outlined),
            selectedIcon: Icon(Icons.add_location_alt),
            label: 'Add Location',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
    );
  }

  /// Navigate to the current location of the branch at the provided index when
  /// tapping an item in the BottomNavigationBar.
  void _onTap(BuildContext context, int index) {
    // If Menu (index 3) is selected, open the drawer instead of navigating
    if (index == 3) {
      _scaffoldKey.currentState?.openEndDrawer();
      return;
    }

    // When navigating to a new branch, it's recommended to use the goBranch
    // method, as doing so makes sure the last navigation state of the
    // Protocol Node is restored.
    widget.navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}
