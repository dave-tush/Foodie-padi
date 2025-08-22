import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie_padi_apps/core/constants/app_colors.dart';
import 'package:foodie_padi_apps/core/constants/app_text_style.dart';

import '../core/constants/sizes.dart';

Widget button(
    {required Widget text,
    required VoidCallback onPressed,
    bool isLoading = false}) {
  return Material(
    color: AppColors.secondaryYellow,
    borderRadius: BorderRadius.circular(Sizes.radiusLarge),
    child: InkWell(
      borderRadius: BorderRadius.circular(Sizes.radiusLarge),
      onTap: onPressed,
      splashColor: isLoading ? Colors.transparent : null,
      highlightColor: isLoading ? Colors.transparent : null,
      child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w, // width padding
            vertical: 14.h, // height padding
          ),
          alignment: Alignment.center,
          child: text),
    ),
  );
}

Widget onboardingButton(String text, VoidCallback onPressed) {
  return Material(
    color: AppColors.secondaryYellow,
    borderRadius: BorderRadius.circular(Sizes.radiusLarge),
    child: InkWell(
      borderRadius: BorderRadius.circular(Sizes.radiusLarge),
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24.w, // width padding
          vertical: 14.h, // height padding
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: AppTextStyle.button.copyWith(color: Colors.white),
        ),
      ),
    ),
  );
}

Widget onboardingButtons(String text, VoidCallback onTap) {
  return Material(
    child: InkWell(
      onTap: onTap,
      child: Container(
        height: Sizes.buttonHeightMedium,
        width: Sizes.buttonWidthMedium,
        decoration: BoxDecoration(
          color: AppColors.secondaryYellow,
          borderRadius: BorderRadius.circular(Sizes.radiusLarge),
        ),
        // width: 360,
        child: Center(
            child: Text(
          text,
          style: TextStyle(
            fontSize: 18.sp,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        )),
      ),
    ),
  );
}
