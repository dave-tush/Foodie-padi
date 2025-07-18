import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie_padi_apps/constants/app_colors.dart';
import 'package:foodie_padi_apps/services/auth_services.dart';
import 'package:foodie_padi_apps/widgets/passwordfield.dart';
import 'package:foodie_padi_apps/widgets/textform_field.dart';
import 'package:provider/provider.dart';

import '../providers/signup_provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignUpProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.primaryOrange,
      body: Stack(
        children: [
          Positioned(
            top: -650.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset('assets/images/BG.png',
                fit: BoxFit.contain, height: 250.h),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 11.h),
            child: Column(
              children: [
                Text("Login",
                    style: TextStyle(
                        fontSize: 28.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 5.h),
                Text("Welcome back", style: TextStyle(color: Colors.white)),
                Container(
                  height: MediaQuery.of(context).size.height / 1.4.h,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildTextField("Email", "Email", emailController,
                            "Email is required",
                            inputType: TextInputType.emailAddress),
                        buildPasswordField(
                            "Password",
                            passwordController,
                            provider.obscurePassword,
                            provider.togglePasswordVisibility),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/forgot-password');
                            },
                            child: Text("Forgot Password?",
                                style:
                                    TextStyle(color: AppColors.primaryOrange)),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryOrange,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final AuthServices authServices =
                                    AuthServices();
                                final result = await authServices.login(
                                    email: emailController.text,
                                    password: passwordController.text);
                                // Navigate on success
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content:
                                      Text("Login failed: ${e.toString()}"),
                                  backgroundColor: Colors.red,
                                ));
                              }
                            }
                          },
                          child: Text("Login", style: TextStyle(fontSize: 16)),
                        ),
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
                                    Navigator.pushNamed(context, '/signup');
                                  },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
