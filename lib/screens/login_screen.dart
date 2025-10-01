import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie_padi_apps/core/constants/app_colors.dart';
import 'package:foodie_padi_apps/providers/user_provider.dart';
import 'package:foodie_padi_apps/screens/signup_screen.dart';
import 'package:foodie_padi_apps/services/auth_services.dart';
import 'package:foodie_padi_apps/widgets/button.dart';
import 'package:foodie_padi_apps/widgets/passwordfield.dart';
import 'package:foodie_padi_apps/widgets/textform_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/sizes.dart';
import '../providers/signup_provider.dart';
import 'cart_screen.dart';
import 'homepage_screen.dart';
import 'selection_screen.dart';
import 'vendor_screens/vendor_home_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignUpProvider>(context);

    return Scaffold(
      backgroundColor: Color(0XFFFF4100),
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
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.4.h,
                  padding: EdgeInsets.all(20),
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
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(color: Color(0xFFFF7622)),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF7622),
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final AuthServices authServices =
                                    AuthServices();
                                final result = await authServices.login(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                                print(
                                  'Role from backend: ${result['user']['role']}',
                                );
                                Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                ).loadUsersFromLocal();
                                final prefs =
                                    await SharedPreferences.getInstance();
                                final token = prefs.getString('access_token');
                                if (token != null) {
                                  print('Token: $token');
                                } else {
                                  print('No token found');
                                }
                                // Navigate on success
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        result['user']['role'] == 'VENDOR'
                                            ? VendorHomeScreen()
                                            : HomeScreen(),
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Login successful!"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Login failed: ${e.toString()}",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          child: Text("Login", style: TextStyle(fontSize: 16)),
                        ),
                        // button(text: 'hello', onPressed: () {}),
                        SizedBox(height: 10.h),
                        RichText(
                          text: TextSpan(
                            text: 'Don’t have an account? ',
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: AppColors.primaryOrange,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            //CartScreen()
                                            SignupScreen(),
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
