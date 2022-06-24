import 'package:device_info_plus/device_info_plus.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:expensee/models/app_colours.dart';
import 'package:expensee/providers/currencies_provider.dart';
import 'package:expensee/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Ensures the deviceInfo is ran before initializing the Flutter application.
  WidgetsFlutterBinding.ensureInitialized();

  // Uses the Device Info Plus package to get the device's Android Information.
  AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;

  // Passes the Device's Android SDK version as a parameter to the application.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CurrenciesProvider())
      ],
      child: MyApp(sdkInt: androidInfo.version.sdkInt),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.sdkInt}) : super(key: key);

  final dynamic sdkInt;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expensee',
      localizationsDelegates: const [FormBuilderLocalizations.delegate],
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: AppColours.wittyWhite,
        // Ternary to switch between the Android 12's stretchy scroll animation and the glow animation in versions below 12.
        androidOverscrollIndicator: sdkInt >= 31
            ? AndroidOverscrollIndicator.stretch
            : AndroidOverscrollIndicator.glow,
        colorScheme: const ColorScheme.light(
          background: AppColours.wittyWhite,
          primary: AppColours.forestryGreen,
          secondary: AppColours.moodyPurple,
        ),
      ),
      home: const DoubleBack(
        child: MainScreen(),
      ),
    );
  }
}
