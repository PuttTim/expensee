import 'package:flutter/material.dart';

import '../models/AppColours.dart';
import '../screens/currency_screen.dart';
import '../screens/home_screen.dart';
import '../screens/splits_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentScreenIndex = 0;
  List<Widget> screens = const [HomeScreen(), CurrencyScreen(), SplitsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentScreenIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: AppColours.blackestBlack.withOpacity(0.40),
          backgroundColor: AppColours.forestryGreen,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
              color: AppColours.paleForestryGreen,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          iconTheme: MaterialStateProperty.all(
            const IconThemeData(color: AppColours.paleForestryGreen),
          ),
        ),
        child: NavigationBar(
          animationDuration: const Duration(milliseconds: 1000),
          selectedIndex: currentScreenIndex,
          onDestinationSelected: (int newIndex) {
            setState(() {
              currentScreenIndex = newIndex;
            });
          },
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.currency_exchange),
              icon: Icon(Icons.currency_exchange_outlined),
              label: 'Currencies',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.sync_alt_rounded),
              icon: Icon(Icons.sync_alt_outlined),
              label: 'Bill Splits',
            )
          ],
        ),
      ),
    );
  }
}
