import 'package:flutter/material.dart';

import '../models/app_colours.dart';
import 'currency_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentScreenIndex = 0;
  List<Widget> screens = const [HomeScreen(), CurrencyScreen()];

  /// This screen holds the two main screens; Home and Currency Screens.
  /// The Home Screen is the default screen.
  /// The Currency Screen is the screen that shows the list of currencies.
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
          ],
        ),
      ),
    );
  }
}
