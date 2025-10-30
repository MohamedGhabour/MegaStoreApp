import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../../utility/app_data.dart';
import '../../../widget/page_wrapper.dart';
import '../utility/functions.dart';
import 'product_cart_screen/cart_screen.dart';
import 'product_favorite_screen/favorite_screen.dart';
import 'product_list_screen/product_list_screen.dart';
import 'profile_screen/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // 🟢 List of main screens for the bottom navigation
  static const List<Widget> screens = [
    ProductListScreen(),
    FavoriteScreen(),
    CartScreen(),
    ProfileScreen()
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int newIndex = 0; // 🟢 Currently selected bottom nav index

  @override
  void initState() {
    super.initState();
    checkServerConnectivity(); // 🟢 Check server connectivity on app start
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Scaffold(
        // 🟢 Bottom navigation bar
        bottomNavigationBar: NavigationBar(
          selectedIndex: newIndex,
          onDestinationSelected: (int index) {
            setState(() {
              newIndex = index; // 🟢 Update selected index
            });
          },
          destinations: AppData.bottomNavBarItems
              .map(
                (item) => NavigationDestination(
              icon: item.icon,
              label: item.title,
              selectedIcon: item.icon, // Keep same icon for simplicity
            ),
          )
              .toList(),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        ),

        // 🟢 Main body with animated screen transitions
        body: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              ) {
            // 🟢 Fade-through transition for smooth screen change
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: HomeScreen.screens[newIndex], // 🟢 Current selected screen
        ),
      ),
    );
  }
}
