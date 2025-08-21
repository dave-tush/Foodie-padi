import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/core/constants/app_assets.dart';
import 'package:foodie_padi_apps/core/constants/app_text_style.dart';
import 'package:foodie_padi_apps/core/constants/gaps.dart';
import 'package:foodie_padi_apps/services/auth_services.dart';
import 'package:foodie_padi_apps/widgets/button.dart';
import 'package:foodie_padi_apps/widgets/passwordfield.dart';
import 'package:foodie_padi_apps/widgets/textform_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/sizes.dart';
import '../models/user_model.dart';
import '../providers/role_provider.dart';
import '../providers/signup_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie_padi_apps/core/constants/app_colors.dart';

import '../providers/user_provider.dart';
import 'selection_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    fullNameController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (passwordController.text != confirmPasswordController.text) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Passwords do not match")),
          );
        }
        setState(() => _isLoading = false);
        return;
      }
      final AuthServices authServices = AuthServices();
      final results = await authServices.signUp(
        email: emailController.text,
        name: fullNameController.text,
        phone: phoneNumberController.text,
        password: passwordController.text,
      );
      final userData = results['user'];
      if (userData == null || results['accessToken'] == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Sign Up failed: Invalid response")),
          );
        }
        setState(() => _isLoading = false);
        return;
      }
      final user = User.fromJson(results['user'], results['accessToken']);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.saveUsersToLocal(
        user,
        results['accessToken'],
        results['refreshToken'] ?? '',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign Up successful!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ChooseRoleScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign Up failed: ${e.toString()}")),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignUpProvider>(context);
    return Scaffold(
        backgroundColor: AppColors.primaryOrange,
        body: Stack(children: [
          Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                AppAssets.bg,
                fit: BoxFit.cover,
                height: 0.75.sw,
                width: 1.sw,
              )),
          SafeArea(
            bottom: false,
            child: Column(children: [
              Gaps.vLarge,
              Text(
                'Sign Up',
                style: AppTextStyle.heading.copyWith(
                  color: Colors.white,
                  fontSize: Sizes.fontExtraExtraLarge,
                ),
              ),
              Gaps.vSmall,
              Text('Please sign up to get started',
                  style: AppTextStyle.body.copyWith(
                    color: Colors.white,
                    fontSize: Sizes.fontMedium,
                  )),
              Gaps.vSmall,
              Expanded(
                //flex: 3,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20.r)),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          buildTextField(
                            label: "Full Name",
                            hint: "Name",
                            controller: fullNameController,
                            validatorText: "Full Name is required",
                          ),
                          buildTextField(
                            label: "Email",
                            hint: "Email",
                            controller: emailController,
                            validatorText: "Email is required",
                            inputType: TextInputType.emailAddress,
                          ),
                          buildTextField(
                            label: "Phone Number",
                            hint: "Phone Number",
                            controller: phoneNumberController,
                            validatorText: "Phone Number is required",
                            inputType: TextInputType.phone,
                          ),
                          buildPasswordField(
                            label: "Password",
                            controller: passwordController,
                            obscure:
                                false, // toggle handled inside provider if needed
                            toggle: () {},
                          ),
                          buildPasswordField(
                            label: "Confirm Password",
                            controller: confirmPasswordController,
                            obscure: false,
                            toggle: () {},
                          ),
                          Gaps.vMedium,
                          _buildLoginRedirect(),
                          Gaps.vLarge,
                          button(
                            text: _isLoading
                                ? SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child: const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Sign Up",
                                    style: AppTextStyle.button.copyWith(
                                      color: Colors.white,
                                      fontSize: Sizes.fontMedium,
                                    ),
                                  ),
                            onPressed: _isLoading ? () {} : _validateAndSubmit,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ]),
          )
        ]));
  }
}

Widget _buildLoginRedirect() {
  return RichText(
    text: TextSpan(
      text: "Already have an account? ",
      style: AppTextStyle.body.copyWith(
        color: Colors.black,
        fontSize: Sizes.fontMedium,
      ),
      children: [
        TextSpan(
          text: "Login",
          style: AppTextStyle.body.copyWith(
            color: AppColors.primaryOrange,
            fontSize: Sizes.fontMedium,
            fontWeight: FontWeight.bold,
          ),
          //  recognizer: TapGestureRecognizer()
          //  ..onTap = () {
          //  Navigator.pushNamed(context, '/login');
          // },
        ),
      ],
    ),
  );
}
