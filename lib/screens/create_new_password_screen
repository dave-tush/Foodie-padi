import 'package:flutter/material.dart';

class CreateNewPassword extends StatelessWidget {
  const CreateNewPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryOrange,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Create New Password", style: TextStyle(fontSize: 24.sp, color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 20.h),
                buildPasswordField("New Password", passwordController, provider.obscurePassword,
                    provider.togglePasswordVisibility),
                buildPasswordField("Confirm Password", confirmPasswordController, provider.obscureConfirmPassword,
                    provider.toggleConfirmPasswordVisibility),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (passwordController.text != confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Passwords do not match!"),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }
                      // Call API to reset password
                      Navigator.pushNamed(context, '/login');
                    }
                  },
                  child: Text("Reset Password"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryOrange,
                    minimumSize: Size(double.infinity, 50),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}