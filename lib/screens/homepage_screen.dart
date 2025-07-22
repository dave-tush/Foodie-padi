import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          //BottomNavigationBarItem(icon: Icon(Icons.favourite), label: ''),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ListView(
            children: [
              SizedBox(height: 20.h),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(Icons.menu, color: Colors.black),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('DELIVER TO',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Text('Oke Afin',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500)),
                          Icon(Icons.keyboard_arrow_down_rounded),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Icon(Icons.shopping_bag_outlined,
                            color: Colors.white),
                      ),
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          padding: EdgeInsets.all(4.r),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '2',
                            style: TextStyle(
                                color: Colors.white, fontSize: 10.sp),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 24.h),
              Text("Hi Daniel",
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 6.h),
              Text("What are you craving?",
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
              SizedBox(height: 20.h),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search dishes, vendors',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none),
                ),
              ),
              SizedBox(height: 20.h),

              // Promo Carousel
              SizedBox(
                height: 120.h,
                child: PageView(
                  children: [
                    _buildPromoCard(
                      title: "Order Food with Friends and get",
                      discount: "40% OFF",
                      color: Colors.orange.shade100,
                    ),
                    _buildPromoCard(
                      title: "Double Combo Deal",
                      discount: "Buy 1 Get 1",
                      color: Colors.deepPurple.shade100,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Category Tabs
              SizedBox(
                height: 40.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: ChoiceChip(
                        label: Text(categories[index]),
                        selected: index == 0,
                        selectedColor: Colors.green.shade100,
                        onSelected: (_) {},
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),

              // Meals Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 0.75,
                children: [
                  InkWell(
                    onTap: () {
                      
                    },
                    child: _buildMealCard(
                      imgPath: 'assets/images/onboarding_2.png',
                      title: 'Ewa Agoyin & Agege Bread',
                      rating: 4.5,
                      price: 5.00,
                      oldPrice: 6.50,
                    ),
                  ),
                  _buildMealCard(
                    imgPath: 'assets/images/onboarding_1.png',
                    title: 'Goat meat pepper soup',
                    rating: 4.9,
                    price: 10.00,
                    oldPrice: 12.00,
                  ),
                  _buildMealCard(
                    imgPath: 'assets/images/onboarding_1.png',
                    title: 'Chicken & Fries',
                    rating: 4.8,
                    price: 7.50,
                  ),
                  _buildMealCard(
                    imgPath: 'assets/images/onboarding_1.png',
                    title: 'Yam Porridge',
                    rating: 4.6,
                    price: 5.80,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromoCard({
    required String title,
    required String discount,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          Text(discount,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange)),
        ],
      ),
    );
  }

  Widget _buildMealCard({
    required String imgPath,
    required String title,
    required double rating,
    required double price,
    double? oldPrice,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200, blurRadius: 5, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                child: Image.asset(
                  imgPath,
                  height: 100.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.favorite_border, color: Colors.red),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp)),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 16.r),
                    SizedBox(width: 4.w),
                    Text(rating.toString(), style: TextStyle(fontSize: 12.sp)),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    if (oldPrice != null)
                      Text(
                        '£ ${oldPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    if (oldPrice != null) SizedBox(width: 8.w),
                    Text(
                      '£ ${price.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: Colors.red),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
