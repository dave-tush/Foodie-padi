import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie_padi_apps/core/constants/app_assets.dart';
import 'package:foodie_padi_apps/providers/favourite_provider.dart';
import 'package:provider/provider.dart';

Widget buildMealCard({
  required String id,
  required String imgPath,
  required String title,
  required double rating,
  required double price,
  required BuildContext context,
  double? oldPrice,
}) {
  final bool isNetwork = imgPath.startsWith('http');
  final favProvider = Provider.of<FavouriteProvider>(context);
  final isFav = favProvider.isFavourite(id);
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.r),
      color: Colors.white,
      boxShadow: [
        BoxShadow(color: Colors.grey.shade200, blurRadius: 5, spreadRadius: 1),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              child: isNetwork
                  ? Image.network(
                      imgPath,
                      height: 120.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, StackTrace) {
                        return Image.asset(
                          AppAssets.bg,
                          height: 120.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      imgPath,
                      height: 100.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: GestureDetector(
                  onTap: () {
                    favProvider.toggleFavouriteByParams(
                        id: id,
                        imgPath: imgPath,
                        title: title,
                        rating: rating,
                        price: price);
                  },
                  child: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red)),
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
                  const Icon(Icons.star, color: Colors.orange, size: 16),
                  SizedBox(width: 4.w),
                  Text(rating.toStringAsFixed(2),
                      style: TextStyle(fontSize: 12.sp)),
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
                        fontSize: 24.sp,
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
