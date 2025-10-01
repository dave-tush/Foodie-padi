import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie_padi_apps/core/constants/app_assets.dart';
import 'package:foodie_padi_apps/core/constants/app_colors.dart';
import 'package:foodie_padi_apps/core/constants/app_text_style.dart';
import 'package:foodie_padi_apps/providers/onboarding_provider.dart';
import 'package:foodie_padi_apps/screens/signup_screen.dart';
import 'package:foodie_padi_apps/widgets/button.dart';
import 'package:provider/provider.dart';

import '../core/constants/gaps.dart';
import '../core/constants/sizes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController pageController;

  final List<Map<String, String>> onboardingData = [
    {
      'image': AppAssets.onboarding1,
      'title': 'Welcome to \n Foodie Padi',
      'subtitle':
          'Delicious meals from trusted\nlocal kitchens - ready when you are.\nDiscover, order and enjoy with ease.',
    },
    {
      'image': AppAssets.onboarding2,
      'title': "Find What You’re \nCraving",
      'subtitle':
          'Browse real-time menus \nfrom food vendors near you.\nSee what’s hot for breakfast, lunch, or dinner.',
    },
    {
      'image': AppAssets.onboarding3,
      'title': 'Support Great Food, Locally Made',
      'subtitle':
          'Your orders help small food businesses grow.\nTaste the care in every meal\nand fuel local dreams.',
    },
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void nextPage(OnboardingProvider onboardingProvider) {
    if (onboardingProvider.currentPage < onboardingData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignupScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboardingProvider = Provider.of<OnboardingProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Sizes.paddingLarge,
            vertical: Sizes.paddingMedium,
          ),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: (index) {
                    onboardingProvider.setCurrentPage(index);
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(height: Sizes.paddingLarge),
                        Image.asset(
                          onboardingData[index]['image']!,
                          height:
                              400.h, // keeps your original responsive height
                        ),
                        Text(
                          onboardingData[index]['title']!,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.heading,
                        ),
                        Gaps.vLarge, // keeps your spacing widget
                        Text(
                          onboardingData[index]['subtitle']!,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.headingExtra,
                        ),
                      ],
                    );
                  },
                ),
              ),
              Gaps.vLarge,
              Row(
                children: [
                  // Indicators
                  Row(
                    children: List.generate(
                      onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.only(
                            right: 6.r), // keeps your responsive margin
                        width: onboardingProvider.currentPage == index
                            ? Sizes.buttonHeightMedium
                            : Sizes.paddingMedium,
                        height: 16,
                        decoration: BoxDecoration(
                          color: onboardingProvider.currentPage == index
                              ? AppColors.secondaryYellow
                              : AppColors.secondary,
                          borderRadius:
                              BorderRadius.circular(Sizes.radiusLarge),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Next / Get Started Button
                  onboardingButton(
                    onboardingProvider.currentPage == onboardingData.length - 1
                        ? "Get Started"
                        : "Next",
                    () => nextPage(onboardingProvider),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
