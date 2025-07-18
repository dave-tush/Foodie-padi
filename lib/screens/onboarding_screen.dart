import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/providers/onboarding_provider.dart';
import 'package:foodie_padi_apps/screens/signup_screen.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingProvider = Provider.of<OnboardingProvider>(context);
    final PageController pageController = PageController();
    final List<Map<String, String>> onboardingData = [
      {
        'image': 'assets/images/onboarding_1.png',
        'title': 'Welcome to \n Foodie Padi',
        'subtitle':
        'Delicious meals from trusted\nlocal kitchens - ready when you are\nDiscover, order and enjoy with ease.',
      },
      {
        'image': 'assets/images/onboarding_2.png',
        'title': 'Track Your\nOrders Easily',
        'subtitle':
        'Get real-time updates and\ntrack your delivery right from the app.',
      },
      {
        'image': 'assets/images/onboarding_3.png',
        'title': 'Fast Delivery\nGuaranteed',
        'subtitle': 'Fresh meals delivered hot\nand fast right to your door.',
      },
    ];

    void nextPage(){
    if(onboardingProvider.currentPage < onboardingData.length - 1) {
      pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => SignUpScreen()));
    }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                        const SizedBox(height: 30),
                        Image.asset(
                          onboardingData[index]['image']!,
                          height: 500,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          onboardingData[index]['title']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          onboardingData[index]['subtitle']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Row(
                    children: List.generate(
                      onboardingData.length,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        width: onboardingProvider.currentPage == index ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: onboardingProvider.currentPage == index
                              ? const Color(0xFFFF6B00)
                              : Colors.black12,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B00),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      onboardingProvider.currentPage ==
                          onboardingData.length - 1
                          ? 'Get Started'
                          : 'Next',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
