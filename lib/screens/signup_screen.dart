import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/services/auth_services.dart';
import 'package:foodie_padi_apps/widgets/passwordfield.dart';
import 'package:foodie_padi_apps/widgets/textform_field.dart';
import 'package:provider/provider.dart';
import '../providers/signup_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie_padi_apps/constants/app_colors.dart';

import 'selection_screen.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SignUpScreen({super.key});

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
              child: Image.asset(
                'assets/images/BG.png',
                fit: BoxFit.contain,
                height: 250.h,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 11.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Please sign up to get started",
                    style: TextStyle(color: Colors.white),
                  ),
                  // SizedBox(height: 20.h),
                  Container(
                      height: MediaQuery.of(context).size.height / 1.1667.h,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            buildTextField("Full Name", "Name",
                                fullNameController, "Full Name is required"),
                            buildTextField("Email", "Email", emailController,
                                "Email is required",
                                inputType: TextInputType.emailAddress),
                            buildTextField("Phone Number", "Phone Number",
                                phoneController, "Phone Number is required",
                                inputType: TextInputType.phone),
                            buildPasswordField(
                              "Password",
                              passwordController,
                              provider.obscurePassword,
                              provider.togglePasswordVisibility,
                            ),
                            buildPasswordField(
                              "Confirm Password",
                              confirmPasswordController,
                              provider.obscureConfirmPassword,
                              provider.toggleConfirmPasswordVisibility,
                            ),
                            SizedBox(height: 20),
                            RichText(
                              text: TextSpan(
                                text: 'Already have an account? ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                children: [
                                  TextSpan(
                                    text: 'Login',
                                    style: TextStyle(
                                      color: AppColors.primaryOrange,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Navigate to login screen
                                        Navigator.pushNamed(context, '/login');
                                      },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFF6B00),
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    // Check if passwords match
                                    if (passwordController.text !=
                                        confirmPasswordController.text) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text("Passwords do not match!"),
                                      ));
                                      return;
                                    }
                                    final AuthServices authServices =
                                        AuthServices();
                                    final results = await authServices.signUp(
                                        name: fullNameController.text,
                                        email: emailController.text,
                                        phone: phoneController.text,
                                        password: passwordController.text);
                                    await Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChooseRoleScreen()));
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("Error: ${e.toString()}"),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                }
                              },
                              child: Text("Sign Up",
                                  style: TextStyle(fontSize: 16)),
                            )
                          ],
                        ),
                      )),
                ],
              ),
            )
          ],
        ));
  }
}
