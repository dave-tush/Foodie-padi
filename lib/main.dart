import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie_padi_apps/providers/onboarding_provider.dart';
import 'package:foodie_padi_apps/providers/signup_provider.dart';
import 'package:foodie_padi_apps/screens/create_new_password_screen';
import 'package:foodie_padi_apps/screens/homepage_screen';
import 'package:foodie_padi_apps/screens/login_screen.dart';
import 'package:foodie_padi_apps/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'screens/forgot_password_screen.dart';
import 'screens/verify_code_screen.dart';

void main() {
  runApp(
    ScreenUtilInit(
      designSize: Size(393, 852),
      minTextAdapt: true,
      builder: (context, child) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: CreateNewPassword(),
        //ForgotPasswordScreen()
        //LoginScreen(),
        //HomeScreen()
        //const SplashScreen(),
      ),
    );
  }
}
