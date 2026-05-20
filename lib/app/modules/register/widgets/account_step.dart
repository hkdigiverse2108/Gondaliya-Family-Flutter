import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/values/colors.dart';
import '../../../../core/values/sizes.dart';
import '../../../global_widgets/custom_text_field.dart';
import '../controllers/register_controller.dart';

class AccountStep extends StatelessWidget {
  final RegisterController controller;

  const AccountStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 2,
          child: Padding(
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
                  CustomTextField(
                    controller: controller.phoneController,
                    labelText: 'phone_number'.tr,
                    hintText: 'e.g. 9876543210',
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(
                      Icons.phone_iphone_outlined,
                      color: AppColors.primaryLight,
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty)
                        return 'field_required'.tr;
                      if (val.trim().length != 10) return 'invalid_phone'.tr;
                      return null;
                    },
                  ),
                  SizedBox(height: AppSizes.spacingM.h),
                  CustomTextField(
                    controller: controller.passwordController,
                    labelText: 'password'.tr,
                    isPassword: true,
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.primaryLight,
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return 'field_required'.tr;
                      if (val.length < 6) return 'invalid_password'.tr;
                      return null;
                    },
                  ),
                  SizedBox(height: AppSizes.spacingM.h),
                  CustomTextField(
                    controller: controller.confirmPasswordController,
                    labelText: 'confirm_password'.tr,
                    isPassword: true,
                    prefixIcon: const Icon(
                      Icons.lock_reset_rounded,
                      color: AppColors.primaryLight,
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return 'field_required'.tr;
                      if (val != controller.passwordController.text)
                        return 'password_mismatch'.tr;
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
                  CustomTextField(
                    controller: controller.mobile1Controller,
                    labelText: 'mobile_1'.tr,
                    enabled: false,
                    prefixIcon: const Icon(
                      Icons.phone_iphone_outlined,
                      color: AppColors.primaryLight,
                    ),
                  ),
                  SizedBox(height: AppSizes.spacingM.h),
                  CustomTextField(
                    controller: controller.mobile2Controller,
                    labelText: 'mobile_2'.tr,
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(
                      Icons.phone_iphone_outlined,
                      color: AppColors.primaryLight,
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
        ),
      ],
    );
  }
}
