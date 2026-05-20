import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/values/colors.dart';

import 'tabs/home_tab_view.dart';
import 'tabs/parivar_tab_view.dart';
import 'tabs/marketplace_tab_view.dart';
import 'tabs/profile_tab_view.dart';
import '../widgets/home_dialogs.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAppBarLogo(),
              SizedBox(width: 10.w),
              Text(
                'app_name'.tr,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.primary,
          elevation: 0,
          actions: [
            IconButton(
              tooltip: 'select_language'.tr,
              icon: const Icon(Icons.language, color: AppColors.white),
              onPressed: () => showLanguageDialog(context, controller),
            ),
            IconButton(
              tooltip: controller.isDarkTheme.value ? 'light_mode'.tr : 'dark_mode'.tr,
              icon: Icon(
                controller.isDarkTheme.value ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                color: AppColors.white,
              ),
              onPressed: controller.toggleTheme,
            ),
            IconButton(
              tooltip: 'logout'.tr,
              icon: const Icon(Icons.logout_rounded, color: AppColors.white),
              onPressed: controller.logout,
            ),
            SizedBox(width: 8.w),
          ],
        ),
        body: Stack(
          children: [
            // Aurora Background Glows (visible on Home Tab)
            if (controller.currentIndex.value == 0) ...[
              Positioned(
                top: -80.h,
                left: -80.w,
                child: Container(
                  width: 260.w,
                  height: 260.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primaryLight.withValues(alpha: 0.15),
                        AppColors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 250.h,
                right: -100.w,
                child: Container(
                  width: 320.w,
                  height: 320.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.secondary.withValues(alpha: 0.12),
                        AppColors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],

            // Main Views
            IndexedStack(
              index: controller.currentIndex.value,
              children: const [
                HomeTabView(),
                ParivarTabView(),
                MarketplaceTabView(),
                ProfileTabView(),
              ],
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                width: 1,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            selectedItemColor: isDark ? AppColors.secondaryLight : AppColors.primary,
            unselectedItemColor: isDark ? Colors.white54 : Colors.black45,
            backgroundColor: isDark ? AppColors.cardDark : AppColors.white,
            elevation: 8,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12.sp),
            unselectedLabelStyle: GoogleFonts.outfit(fontSize: 11.sp),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline_rounded),
                activeIcon: Icon(Icons.people_rounded),
                label: 'Parivar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.storefront_outlined),
                activeIcon: Icon(Icons.storefront_rounded),
                label: 'Market',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAppBarLogo() {
    return Image.asset(
      'assets/images/logo.png',
      height: 32.h,
      width: 32.w,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(4.w),
          child: Icon(
            Icons.nature_people_rounded,
            size: 20.w,
            color: AppColors.primary,
          ),
        );
      },
    );
  }
}
