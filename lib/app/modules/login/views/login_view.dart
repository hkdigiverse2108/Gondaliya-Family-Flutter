import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/values/colors.dart';
import '../../../../core/values/sizes.dart';
import '../../../routes/app_pages.dart';
import '../../../global_widgets/custom_text_field.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/glass_card.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Language Toggle Button (Styled as a premium Chip)
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.cardDark.withValues(alpha: 0.6)
                    : AppColors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isDark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight,
                  width: 1,
                ),
              ),
              child: TextButton.icon(
                onPressed: controller.toggleLanguage,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                ),
                icon: Icon(
                  Icons.language,
                  color: isDark ? AppColors.secondaryLight : AppColors.primary,
                  size: 16.w,
                ),
                label: Text(
                  Get.locale?.languageCode == 'gu' ? 'English' : 'ગુજરાતી',
                  style: GoogleFonts.outfit(
                    color: isDark ? AppColors.white : AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Gradient blobs to simulate aurora glow
          Positioned(
            top: -100.h,
            left: -100.w,
            child: Container(
              width: 300.w,
              height: 300.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(
                  alpha: isDark ? 0.25 : 0.15,
                ),
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.4),
                    AppColors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 200.h,
            right: -150.w,
            child: Container(
              width: 400.w,
              height: 400.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(
                  alpha: isDark ? 0.2 : 0.1,
                ),
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.35),
                    AppColors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main Body Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Logo & Branding Container
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 110.h,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 90.h,
                                width: 90.w,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.primary,
                                      AppColors.tealBridge,
                                      AppColors.secondary,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.nature_people,
                                  size: 48,
                                  color: AppColors.white,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: AppSizes.spacingL.h),

                          // Form Title & Motto with premium typography
                          Text(
                            'register_header'.tr,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.primary,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: AppSizes.spacingXS.h),
                          Text(
                            'motto'.tr,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: AppSizes.fontSizeBodyMedium.sp,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                              color: isDark
                                  ? AppColors.textDarkSecondary
                                  : AppColors.textLightSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingL.h),

                    // Frosted Glass Card for Login fields
                    GlassCard(
                      borderRadius: AppSizes.radiusXXL.w,
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'login'.tr,
                            style: GoogleFonts.outfit(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textLightPrimary,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: AppSizes.spacingXL.h),

                          // Phone Number Input
                          CustomTextField(
                            controller: controller.phoneController,
                            labelText: 'phone_number'.tr,
                            hintText: 'e.g. 9876543210',
                            keyboardType: TextInputType.phone,
                            prefixIcon: const Icon(
                              Icons.phone_iphone_outlined,
                              color: AppColors.primaryLight,
                            ),
                          ),
                          SizedBox(height: AppSizes.spacingL.h),

                          // Password Input
                          CustomTextField(
                            controller: controller.passwordController,
                            labelText: 'password'.tr,
                            isPassword: true,
                            prefixIcon: const Icon(
                              Icons.lock_outline_rounded,
                              color: AppColors.primaryLight,
                            ),
                          ),
                          SizedBox(height: AppSizes.spacingXL.h),

                          // Sign In Button with Aurora Gradient background style
                          Obx(
                            () => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.tealBridge,
                                    AppColors.secondary,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                    offset: const Offset(0, 6),
                                    blurRadius: 16,
                                    spreadRadius: -2,
                                  ),
                                ],
                              ),
                              child: CustomButton(
                                text: 'sign_in'.tr,
                                backgroundColor: AppColors.transparent,
                                isLoading: controller.isLoading.value,
                                onPressed: controller.login,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingXL.h),

                    // Sign Up link
                    Center(
                      child: TextButton(
                        onPressed: () => Get.toNamed(Routes.REGISTER),
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.outfit(
                              fontSize: AppSizes.fontSizeBodyLarge.sp,
                              color: isDark
                                  ? AppColors.textDarkSecondary
                                  : AppColors.textLightSecondary,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '${'dont_have_account'.tr.split('?').first}? ',
                              ),
                              TextSpan(
                                text: 'dont_have_account'.tr
                                    .split('?')
                                    .last
                                    .trim(),
                                style: GoogleFonts.outfit(
                                  color: isDark
                                      ? AppColors.secondaryLight
                                      : AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
