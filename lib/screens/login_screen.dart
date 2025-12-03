import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie_padi_apps/core/constants/app_colors.dart';
import 'package:foodie_padi_apps/core/constants/sizes.dart';
import 'package:foodie_padi_apps/providers/signup_provider.dart';
import 'package:foodie_padi_apps/providers/user_provider.dart';
import 'package:foodie_padi_apps/screens/homescreen/homepage_screen.dart';
import 'package:foodie_padi_apps/screens/signup_screen.dart';
import 'package:foodie_padi_apps/screens/vendor_screens/vendor_home_screen.dart';
import 'package:foodie_padi_apps/screens/vendor_screens/vendor_homescreen.dart';
import 'package:foodie_padi_apps/services/auth_services.dart';
import 'package:foodie_padi_apps/widgets/passwordfield.dart';
import 'package:foodie_padi_apps/widgets/textform_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _checkingSession = true;

  @override
  void initState() {
    super.initState();
    // _checkSavedSession();
  }

  /// 🧩 Check if user is already logged in
  Future<void> _checkSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final role = prefs.getString('user_role');

    if (token != null && token.isNotEmpty) {
      await Future.delayed(const Duration(seconds: 1)); // Optional splash delay

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              role == 'VENDOR' ? const VendorHomeScreens() : const HomeScreen(),
        ),
      );
    } else {
      setState(() => _checkingSession = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignUpProvider>(context);

    // While checking saved session, show loading
    //  if (_checkingSession) {
    //  return const Scaffold(
    //  backgroundColor: Color(0xFFFF4100),
    // body: Center(
    //  child: CircularProgressIndicator(color: Colors.white),
    // ),
    // );
    // }

    return Scaffold(
      backgroundColor: const Color(0XFFFF4100),
      body: Stack(
        children: [
          Positioned(
            top: -570.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/BG.png',
              fit: BoxFit.contain,
              height: 250.h,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 11.h,
            ),
            child: Column(
              children: [
                SizedBox(height: 50.h),
                Text(
                  "Log In",
                  style: TextStyle(
                    fontSize: Sizes.fontExtraExtraLarge.h,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "Please sign in to your existing account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.fontMedium.spMin,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  height: MediaQuery.of(context).size.height / 1.4.h,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildTextField(
                          label: "Email",
                          hint: "Email",
                          controller: emailController,
                          validatorText: "Email is required",
                          inputType: TextInputType.emailAddress,
                        ),
                        buildPasswordField(
                          label: "Password",
                          controller: passwordController,
                          obscure: provider.obscurePassword,
                          toggle: provider.togglePasswordVisibility,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/forgot-password');
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(color: Color(0xFFFF7622)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ✅ Working Login Button with session persistence
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF7622),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => _isLoading = true);
                                    try {
                                      final AuthServices authServices =
                                          AuthServices();

                                      final result = await authServices.login(
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                      );

                                      print(
                                          'Role from backend: ${result['user']['role']}');

                                      // ✅ Save session
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setString(
                                          'access_token',
                                          result['token'] ??
                                              result['accessToken'] ??
                                              '');
                                      await prefs.setString('user_role',
                                          result['user']['role'] ?? '');

                                      // ✅ Load user to provider
                                      Provider.of<UserProvider>(
                                        context,
                                        listen: false,
                                      ).loadUsersFromLocal();

                                      // ✅ Navigate based on role
                                      if (!mounted) return;
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              result['user']['role'] == 'VENDOR'
                                                  ? const VendorHomeScreens()
                                                  : const HomeScreen(),
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text("Login successful!"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Login failed: ${e.toString()}",
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } finally {
                                      setState(() => _isLoading = false);
                                    }
                                  }
                                },
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Login",
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),

                        SizedBox(height: 10.h),
                        RichText(
                          text: TextSpan(
                            text: 'Don’t have an account? ',
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: const TextStyle(
                                  color: AppColors.primaryOrange,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const SignupScreen(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
