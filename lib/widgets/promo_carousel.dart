import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie_padi_apps/core/constants/app_text_style.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../core/constants/sizes.dart';

class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _promoItems = [
    {
      'title': "Order Food with Friends and get",
      'discount': "40% OFF",
      'color': Colors.orange,
    },
    {
      'title': "Double Combo Deal",
      'discount': "Buy 1 Get 1",
      'color': Colors.green,
    },
    {
      'title': "Double Combo Deal",
      'discount': "Buy 1 Get 1",
      'color': Colors.deepPurple,
    },
    {
      'title': "Order Food with Friends and get",
      'discount': "40% OFF",
      'color': Colors.blue,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _promoItems.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildPromoCard(
      {required String title, required String discount, required Color color}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Sizes.paddingSmall),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(Sizes.radiusLarge),
      ),
      padding: EdgeInsets.all(Sizes.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            discount,
            style: AppTextStyle.body.copyWith(
              fontSize: Sizes.fontExtraLarge,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: Sizes.paddingSmall),
          Text(
            title,
            style: TextStyle(
              fontSize: Sizes.fontMedium,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: PageView(
            controller: _pageController,
            children: _promoItems
                .map((promo) => _buildPromoCard(
                    title: promo['title'],
                    discount: promo['discount'],
                    color: promo['color']))
                .toList(),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        SmoothPageIndicator(
          controller: _pageController,
          count: _promoItems.length,
          effect: WormEffect(
            dotHeight: 8.h,
            dotWidth: 8.w,
            activeDotColor: Colors.orange,
            dotColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}
