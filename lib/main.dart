import 'package:device_info_plus/device_info_plus.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:expensee/models/app_colours.dart';
import 'package:expensee/providers/accounts_provider.dart';
import 'package:expensee/providers/currencies_provider.dart';
import 'package:expensee/providers/records_provider.dart';
import 'package:expensee/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'screens/login_screen.dart';

void main() async {
  /// Ensures the deviceInfo is ran before initializing the Flutter application.
  WidgetsFlutterBinding.ensureInitialized();

  /// Uses the Device Info Plus package to get the device's Android Information.
  AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    /// Multi Provider for the three providers (Currencies, Records and Accounts)
    MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.userChanges(),
          initialData: null,
        ),
        ChangeNotifierProvider(create: (context) => CurrenciesProvider()),
        ChangeNotifierProvider(create: (context) => RecordsProvider()),
        ChangeNotifierProvider(create: (context) => AccountsProvider())
      ],

      /// Passes the Device's Android SDK version as a parameter to the application.
      child: MyApp(sdkInt: androidInfo.version.sdkInt),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.sdkInt}) : super(key: key);

  final dynamic sdkInt;

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    bool isAuthenticated = user != null && user.emailVerified;
    debugPrint('isAuthenticated: $isAuthenticated');

    return MaterialApp(
      title: 'Expensee',
      localizationsDelegates: const [FormBuilderLocalizations.delegate],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: AppColours.wittyWhite,

        /// Ternary to switch between the Android 12's stretchy scroll animation and the glow animation in versions below 12.
        androidOverscrollIndicator: sdkInt >= 31 ? AndroidOverscrollIndicator.stretch : AndroidOverscrollIndicator.glow,
        colorScheme: const ColorScheme.light(
          background: AppColours.wittyWhite,
          primary: AppColours.forestryGreen,
          secondary: AppColours.moodyPurple,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColours.feistyOrange,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColours.feistyOrange,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColours.moodyPurple,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColours.moodyPurple,
              width: 4,
            ),
          ),
        ),
      ),

      /// Making sure the user has to tap back twice to exit the application.
      home: DoubleBack(child: isAuthenticated ? const MainScreen() : LoginScreen()),
    );
  }
}
