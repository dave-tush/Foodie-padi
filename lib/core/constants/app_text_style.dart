import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/core/constants/app_colors.dart';
import 'package:foodie_padi_apps/core/constants/sizes.dart';

class AppTextStyle {
  static final TextStyle body = TextStyle(
    fontSize: Sizes.fontMedium,
    color: AppColors.textLight,
  );
  static final TextStyle bodySmall = TextStyle(
    fontSize: Sizes.fontSmall,
    color: AppColors.textDark,
  );
  static final TextStyle heading = TextStyle(
    fontSize: Sizes.fontExtraLarge,
    color: AppColors.textDark,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle subtitle = TextStyle(
    fontSize: Sizes.fontLarge,
    color: AppColors.textLight,
    fontStyle: FontStyle.italic,
  );
  static final TextStyle button = TextStyle(
    fontSize: Sizes.fontMedium,
    color: AppColors.white,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle error = TextStyle(
    fontSize: Sizes.fontSmall,
    color: AppColors.errorRed,
  );
  static final TextStyle headingExtra = TextStyle(
    fontSize: Sizes.fontSmall,
    color: AppColors.textDark,
  );
  static final TextStyle headingExtraBold = TextStyle(
    fontSize: Sizes.fontExtraLarge,
    color: AppColors.textDark,
    fontWeight: FontWeight.bold,
  );
}
