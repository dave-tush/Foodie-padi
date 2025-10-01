import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie_padi_apps/providers/favourite_provider.dart';
import 'package:foodie_padi_apps/providers/food_provider.dart';
import 'package:foodie_padi_apps/providers/onboarding_provider.dart';
import 'package:foodie_padi_apps/providers/role_provider.dart';
import 'package:foodie_padi_apps/providers/search_provider.dart';
import 'package:foodie_padi_apps/providers/signup_provider.dart';
import 'package:foodie_padi_apps/providers/user_provider.dart';
import 'package:foodie_padi_apps/screens/login_screen.dart';
import 'package:foodie_padi_apps/screens/splash_screen.dart';
import 'package:foodie_padi_apps/screens/vendor_screens/add_food_screen.dart';
import 'package:foodie_padi_apps/services/cart_services.dart';
import 'package:foodie_padi_apps/services/product_services.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/vendor_provider.dart';
import 'screens/chat_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/vendor_screens/vendor_home_screen.dart';

//import 'screens/forgot_password_screen.dart';
//import 'screens/verify_code_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final UserProvider userProvider = UserProvider();
  final FavouriteProvider favouriteProvider = FavouriteProvider();
  await userProvider.loadUsersFromLocal();
  await favouriteProvider.loadFavourites();
  final prefs = await SharedPreferences.getInstance();
  bool hasAccount = prefs.getBool('hasAccount') ?? false;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_) => UserProvider()..loadUsersFromLocal()),
      ChangeNotifierProvider(create: (_) => OnboardingProvider()),
      ChangeNotifierProvider(create: (_) => FavouriteProvider()),
      ChangeNotifierProvider(create: (_) => SignUpProvider()),
      ChangeNotifierProvider(create: (_) => RoleProvider()),
      ChangeNotifierProvider(
          create: (_) => CartProvider(
              CartServices(dotenv.env['BASE_URL'] ?? 'http://localhost:3000'))),
      ChangeNotifierProvider(create: (_) => FoodProvider()),
      ChangeNotifierProvider(
          create: (_) => SearchProvider(ProductServices(
              dotenv.env['BASE_URL'] ?? 'http://localhost:3000'))),
      ChangeNotifierProvider(
          create: (_) => ProductProvider(ProductServices(
              dotenv.env['BASE_URL'] ?? 'http://localhost:3000'))
            ..loadProducts()),
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
      routes: {
        '/vendorHome': (context) => const VendorHomeScreen(),
        '/orders': (context) => const OrdersScreen(),
        '/addMeal': (context) => const FoodUploadScreen(),
        '/chat': (context) => const ChatScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      home: home,
      //hasAccount ? LoginScreen() : SplashScreen(),
    );
  }
}
