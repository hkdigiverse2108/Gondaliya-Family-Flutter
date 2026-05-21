import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/values/sizes.dart';
import '../../../routes/app_pages.dart';
import '../../../global_widgets/neomorphic_text_field.dart';
import '../../../global_widgets/neomorphic_button.dart';
import '../../../global_widgets/neomorphic_card.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            tooltip: controller.isDarkTheme.value
                ? 'light_mode'.tr
                : 'dark_mode'.tr,
            icon: Icon(
              controller.isDarkTheme.value
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              color: colors.textPrimary,
            ),
            onPressed: controller.toggleTheme,
          ),
          // Language Toggle Button (Neumorphic style)
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: controller.toggleLanguage,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: colors.neumorphicShadow(blur: 10, distance: 2),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.language, color: colors.textPrimary, size: 16.w),
                    SizedBox(width: 6.w),
                    Text(
                      Get.locale?.languageCode == 'gu' ? 'English' : 'ગુજરાતી',
                      style: GoogleFonts.outfit(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
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
                color: colors.primary.withValues(
                  alpha: colors.isDark ? 0.25 : 0.15,
                ),
                gradient: RadialGradient(
                  colors: [
                    colors.primary.withValues(alpha: 0.4),
                    colors.transparent,
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
                color: colors.secondary.withValues(
                  alpha: colors.isDark ? 0.2 : 0.1,
                ),
                gradient: RadialGradient(
                  colors: [
                    colors.secondary.withValues(alpha: 0.35),
                    colors.transparent,
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
                                  gradient: LinearGradient(
                                    colors: colors.primaryGradient,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: colors.primary.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.nature_people,
                                  size: 48,
                                  color: colors.white,
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
                              color: colors.isDark
                                  ? colors.white
                                  : colors.primary,
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
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingL.h),

                    // Neumorphic Card for Login fields
                    NeomorphicCard(
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
                              color: colors.isDark
                                  ? colors.white
                                  : colors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: AppSizes.spacingXL.h),

                          // Phone Number Input - Neumorphic
                          NeomorphicTextField(
                            controller: controller.phoneController,
                            labelText: 'phone_number'.tr,
                            hintText: 'e.g. 9876543210',
                            keyboardType: TextInputType.phone,
                            showValidationIcon: false,
                            prefixIcon: Icon(
                              Icons.phone_iphone_outlined,
                              color: colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: AppSizes.spacingL.h),

                          // Password Input - Neumorphic
                          NeomorphicTextField(
                            controller: controller.passwordController,
                            labelText: 'password'.tr,
                            isPassword: true,
                            prefixIcon: Icon(
                              Icons.lock_outline_rounded,
                              color: colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: AppSizes.spacingXL.h),

                          // Sign In Button with Neumorphic styling
                          Obx(
                            () => NeomorphicButton(
                              text: 'sign_in'.tr,
                              isLoading: controller.isLoading.value,
                              onPressed: controller.login,
                              isGradient: true,
                              gradientColors: colors.primaryGradient,
                              gradientBegin: Alignment.centerLeft,
                              gradientEnd: Alignment.centerRight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingXL.h),

                    // Sign Up link
                    Center(
                      child: GestureDetector(
                        onTap: () => Get.toNamed(Routes.register),
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.outfit(
                              fontSize: AppSizes.fontSizeBodyLarge.sp,
                              color: colors.textSecondary,
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
                                  color: colors.accent,
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
