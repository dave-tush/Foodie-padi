import 'package:flutter/material.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";

Widget buildPasswordField(
    {required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback toggle}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
            color: Color(0xFF646982),
            fontWeight: FontWeight.w700,
            fontSize: 16.sp),
      ),
      SizedBox(height: 6.h),
      TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: label,
          filled: true,
          fillColor: Color(0xFFF0F5FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: toggle,
          ),
        ),
      ),
      SizedBox(height: 12.h),
    ],
  );
}
