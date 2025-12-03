import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodie_padi_apps/screens/vendor_screens/vendor_homescreen.dart';
import 'package:foodie_padi_apps/services/role_service.dart';
import 'package:foodie_padi_apps/widgets/button.dart';
import 'package:provider/provider.dart' show Provider;
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_style.dart';
import '../core/constants/gaps.dart';
import '../core/constants/sizes.dart';
import '../providers/user_provider.dart';

import 'homescreen/homepage_screen.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  Future<bool> _handleRoleSelection(BuildContext context, String role) async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    final token = provider.accessToken;
    print('Access token from provider: $token');
    print(token);
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No access token found'),
        ),
      );
      return false;
    }
    print('Selected role: $role');
    print('Access token: $token');
    try {
      print('Sending role update to backend...');
      final success = await RoleService.setUserRole(token, role);
      print('Role update sent to backend: $success');
      if (success) {
        await provider.updateRole(role);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to set user role'),
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizes.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gaps.vMedium,
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios),
                ),
              ),
              Gaps.vSmall,
              Image.asset(
                'assets/images/way.png',
                height: 300.h,
              ),
              Gaps.vLarge,
              Text(
                'Welcome once again!',
                style: AppTextStyle.body.copyWith(
                  fontSize: Sizes.fontExtraLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              Gaps.vSmall,
              Text(
                'Yay you are almost done! please choose the button below to complete the registration process.',
                style: AppTextStyle.bodySmall.copyWith(
                  fontSize: Sizes.fontSmallMedium,
                  color: AppColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),
              Gaps.vExtraExtraLarge,
              button(
                  text: Text(
                    "Vendor",
                    style: AppTextStyle.button.copyWith(
                      color: Colors.white,
                      fontSize: Sizes.fontSmallMedium,
                    ),
                  ),
                  onPressed: () async {
                    bool success =
                        await _handleRoleSelection(context, 'VENDOR');
                    if (success) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VendorHomeScreens(),
                        ),
                      );
                    }
                  }),

              // Vendor Button
              Gaps.vMedium,
              outlineButton(
                  text: 'Customer',
                  onPressed: () async {
                    bool success =
                        await _handleRoleSelection(context, 'CUSTOMER');
                    if (success) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(),
                        ),
                      );
                    }
                  }),
              Gaps.vMedium,
              outlineButton(text: 'Driver', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
