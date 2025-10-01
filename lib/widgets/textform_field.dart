import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

Widget buildTextField(
    {required String label,
    required String hint,
    required TextEditingController controller,
    required String validatorText,
    TextInputType inputType = TextInputType.text}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Color(0xFF646982),
          fontWeight: FontWeight.w700,
          fontSize: 16.sp,
        ),
      ),
      SizedBox(height: 6.h),
      TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) return validatorText;
          return null;
        },
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Color(0xFF646982),
            fontSize: 14.sp,
          ),
          labelStyle: TextStyle(
            color: Color(0xFF1C1C1C),
            fontSize: 14.sp,
          ),
          filled: true,
          fillColor: Color(0xFFF0F5FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
        ),
      ),
      SizedBox(height: 12.h),
    ],
  );
}
