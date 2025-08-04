import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie_padi_apps/providers/onboarding_provider.dart';
import 'package:foodie_padi_apps/providers/role_provider.dart'
    show RoleProvider;
import 'package:foodie_padi_apps/providers/signup_provider.dart';
import 'package:foodie_padi_apps/providers/user_provider.dart'
    show UserProvider;
import 'package:foodie_padi_apps/screens/login_screen.dart';
import 'package:foodie_padi_apps/screens/splash_screen.dart';
import 'providers/cart_provider.dart';
import 'providers/vendor_provider.dart';
import 'screens/review_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/verify_code_screen.dart';

import 'screens/signup_screen.dart';

//import 'screens/forgot_password_screen.dart';
//import 'screens/verify_code_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool hasAccount = prefs.getBool('hasAccount') ?? false;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_) => UserProvider()..loadUsersFromLocal()),
      ChangeNotifierProvider(create: (_) => OnboardingProvider()),
      ChangeNotifierProvider(create: (_) => SignUpProvider()),
      ChangeNotifierProvider(create: (_) => RoleProvider()),
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(
          create: (_) => VendorProvider()..loadVendorDetails()),
    ],
    child: ScreenUtilInit(
      designSize: Size(393, 852),
      minTextAdapt: true,
      builder: (context, child) => MyApp(
        hasAccount: hasAccount,
      ),
    ),
  ));
}

class MyApp extends StatelessWidget {
  final bool hasAccount;
  const MyApp({required this.hasAccount, super.key});

  @override
  Widget build(BuildContext context) {
    Widget home;
    if (hasAccount) {
      home = LoginScreen();
    } else {
      home = SplashScreen();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: home,
      //hasAccount ? LoginScreen() : SplashScreen(),
    );
  }
}
