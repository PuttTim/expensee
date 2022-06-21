import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:expensee/models/AppColours.dart';
import 'package:expensee/widgets/navbar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expensee',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: AppColours.wittyWhite,
        colorScheme: const ColorScheme.light(
          background: AppColours.wittyWhite,
          primary: AppColours.forestryGreen,
          secondary: AppColours.moodyPurple,
        ),
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DoubleBack(
        message: 'Press back again to exit.',
        child: NavBar(),
      ),
    );
  }
}
