import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gondalia_family/app/global_widgets/glass_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tabs/home_tab_view.dart';
import 'tabs/parivar_tab_view.dart';
import 'tabs/marketplace_tab_view.dart';
import 'tabs/profile_tab_view.dart';
import '../widgets/home_dialogs.dart';
import '../controllers/home_controller.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    return Obx(() {
      return SafeArea(
        top: false,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: GlassAppBar(
            title: Row(
              children: [
                // _buildAppBarLogo(),
                // SizedBox(width: 10.w),
                Text(
                  'app_name'.tr,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'select_language'.tr,
                icon: Icon(Icons.language, color: colors.textPrimary),
                onPressed: () => showLanguageDialog(context, controller),
              ),
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
              IconButton(
                tooltip: 'logout'.tr,
                icon: Icon(Icons.logout_rounded, color: colors.textPrimary),
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
                          colors.primaryVariant.withValues(
                            alpha: isDark ? 0.08 : 0.15,
                          ),
                          colors.transparent,
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
                          colors.secondary.withValues(
                            alpha: isDark ? 0.06 : 0.12,
                          ),
                          colors.transparent,
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
              border: Border(top: BorderSide(color: colors.divider, width: 1)),
            ),
            child: BottomNavigationBar(
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeTab,
              selectedItemColor: colors.accent,
              unselectedItemColor: isDark ? Colors.white54 : Colors.black45,
              backgroundColor: colors.card,
              elevation: 8,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
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
          floatingActionButton: controller.currentIndex.value == 0
              ? FloatingActionButton(
                  onPressed: () {
                    // TODO: Navigate to create post view
                  },
                  backgroundColor: colors.primary,
                  elevation: 4,
                  child: const Icon(Icons.edit_rounded, color: Colors.white),
                )
              : null,
        ),
      );
    });
  }

  // Widget _buildAppBarLogo() {
  //   return Image.asset(
  //     'assets/images/logo.png',
  //     height: 32.h,
  //     width: 32.w,
  //     errorBuilder: (context, error, stackTrace) {
  //       return Container(
  //         decoration: const BoxDecoration(
  //           color: AppColors.white,
  //           shape: BoxShape.circle,
  //         ),
  //         padding: EdgeInsets.all(4.w),
  //         child: Icon(
  //           Icons.nature_people_rounded,
  //           size: 20.w,
  //           color: AppColors.primary,
  //         ),
  //       );
  //     },
  //   );
  // }
}
