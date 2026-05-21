import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import '../../../../core/values/colors.dart';
import '../controllers/splash_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Just touching the controller to ensure it is initialized immediately
    controller.toString();
    
    // During very early init, we can assume a basic background, 
    // but context.appColors works if ThemeMode is system default.
    final colors = context.appColors;
    
    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          // Subtle aurora for the splash
          Positioned(
            top: -100.h,
            left: -100.w,
            child: Container(
              width: 300.w,
              height: 300.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: colors.isDark ? 0.05 : 0.15),
                    Colors.transparent,
                  ],
                  radius: 0.8,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50.h,
            right: -50.w,
            child: Container(
              width: 250.w,
              height: 250.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: colors.isDark ? 0.05 : 0.15),
                    Colors.transparent,
                  ],
                  radius: 0.8,
                ),
              ),
            ),
          ),
          // Logo & Text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'app_logo',
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 120.h,
                    width: 120.h,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120.h,
                        width: 120.h,
                        decoration: BoxDecoration(
                          color: colors.card,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.nature_people_rounded,
                          size: 60.w,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Samast Gondaliya Patel\nParivar Surat',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Service • Cooperation • Organization',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: 40.h),
                SizedBox(
                  width: 30.w,
                  height: 30.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
