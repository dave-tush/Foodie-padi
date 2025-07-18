import "package:flutter/material.dart";
import "package:foodie_padi_apps/constants/app_colors.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

Widget buildTextField(String label, String hint,
    TextEditingController controller, String validatorText,
    {TextInputType inputType = TextInputType.text}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: AppColors.grey,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
      SizedBox(height: 6),
      TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) return validatorText;
          return null;
        },
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Color(0xFFF3F6F8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
        ),
      ),
      SizedBox(height: 12),
    ],
  );
}
