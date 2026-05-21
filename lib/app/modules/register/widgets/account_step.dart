import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/values/colors.dart';
import '../../../../core/values/sizes.dart';
import '../../../global_widgets/neomorphic_text_field.dart';
import '../../../global_widgets/neomorphic_card.dart';
import '../controllers/register_controller.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';

class AccountStep extends StatelessWidget {
  final RegisterController controller;

  const AccountStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NeomorphicCard(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: controller.accountFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'login'.tr,
                  style: GoogleFonts.outfit(
                    fontSize: AppSizes.fontSizeTitleMedium.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.secondaryLight
                        : AppColors.primary,
                  ),
                ),
                SizedBox(height: AppSizes.spacingM.h),
                NeomorphicTextField(
                  controller: controller.phoneController,
                  labelText: 'phone_number'.tr,
                  hintText: 'e.g. 9876543210',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icon(
                    Icons.phone_iphone_outlined,
                    color: colors.textPrimary,
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'field_required'.tr;
                    }
                    if (val.trim().length != 10) return 'invalid_phone'.tr;
                    return null;
                  },
                ),
                SizedBox(height: AppSizes.spacingM.h),
                NeomorphicTextField(
                  controller: controller.passwordController,
                  labelText: 'password'.tr,
                  isPassword: true,
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: colors.textPrimary,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'field_required'.tr;
                    }
                    if (val.length < 6) return 'invalid_password'.tr;
                    return null;
                  },
                ),
                SizedBox(height: AppSizes.spacingM.h),
                NeomorphicTextField(
                  controller: controller.confirmPasswordController,
                  labelText: 'confirm_password'.tr,
                  isPassword: true,
                  prefixIcon: Icon(
                    Icons.lock_reset_rounded,
                    color: colors.textPrimary,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'field_required'.tr;
                    }
                    if (val != controller.passwordController.text) {
                      return 'password_mismatch'.tr;
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSizes.spacingXL.h),
                Text(
                  'business_contact'.tr,
                  style: GoogleFonts.outfit(
                    fontSize: AppSizes.fontSizeTitleMedium.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.secondaryLight
                        : AppColors.primary,
                  ),
                ),
                SizedBox(height: AppSizes.spacingM.h),
                NeomorphicTextField(
                  controller: controller.mobile1Controller,
                  labelText: 'mobile_1'.tr,
                  enabled: false,
                  prefixIcon: Icon(
                    Icons.phone_iphone_outlined,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.spacingM.h),
                NeomorphicTextField(
                  controller: controller.mobile2Controller,
                  labelText: 'mobile_2'.tr,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icon(
                    Icons.phone_iphone_outlined,
                    color: colors.textPrimary,
                  ),
                  validator: (val) {
                    if (val != null && val.isNotEmpty && val.length != 10) {
                      return 'invalid_phone'.tr;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
