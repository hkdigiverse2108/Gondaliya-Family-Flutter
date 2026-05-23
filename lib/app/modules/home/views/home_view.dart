import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gondalia_family/app/global_widgets/glass_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'tabs/home_tab_view.dart';
import 'tabs/parivar_tab_view.dart';
import 'tabs/marketplace_tab_view.dart';
import 'tabs/profile_tab_view.dart';
import '../controllers/home_controller.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/values/sizes.dart';

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
                tooltip: 'announcements'.tr,
                icon: Icon(
                  PhosphorIcons.megaphone(),
                  color: colors.textPrimary,
                ),
                onPressed: () {
                  // TODO: Navigate to announcements
                },
              ),
              IconButton(
                tooltip: 'notifications'.tr,
                icon: Icon(PhosphorIcons.bell(), color: colors.textPrimary),
                onPressed: () {
                  // TODO: Navigate to notifications
                },
              ),
              SizedBox(width: AppSizes.spacingS.w),
            ],
          ),
          body: Stack(
            children: [
              // Background Gradient blobs to simulate aurora glow (visible on all tabs to maintain consistent theme)
              Positioned(
                top: -100.h,
                left: -100.w,
                child: Container(
                  width: 300.w,
                  height: 300.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.primary.withValues(
                      alpha: isDark ? 0.25 : 0.15,
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
                      alpha: isDark ? 0.2 : 0.1,
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
          extendBody: true,
          bottomNavigationBar: _buildBottomNav(
            context,
            controller,
            colors,
            isDark,
          ),
          // floatingActionButton: controller.currentIndex.value == 0
          //     ? FloatingActionButton(
          //         onPressed: () {
          //           // TODO: Navigate to create post view
          //         },
          //         backgroundColor: colors.primary,
          //         elevation: 4,
          //         child: Icon(
          //           PhosphorIcons.plus(PhosphorIconsStyle.bold),
          //           color: Colors.white,
          //         ),
          //       )
          //     : null,
        ),
      );
    });
  }

  Widget _buildBottomNav(
    BuildContext context,
    HomeController controller,
    AppColorScheme colors,
    bool isDark,
  ) {
    return Container(
      margin: EdgeInsets.only(
        left: AppSizes.spacingXL.w,
        right: AppSizes.spacingXL.w,
        bottom: AppSizes.spacingXL.h + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: colors.card.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: colors.neumorphicShadow(blur: 15, distance: 4),
        border: Border.all(
          color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.2),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.spacingS.w,
              vertical: AppSizes.spacingS.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(
                  0,
                  PhosphorIcons.house(),
                  PhosphorIcons.house(PhosphorIconsStyle.fill),
                  'Home',
                  controller,
                  colors,
                ),
                _buildNavItem(
                  1,
                  PhosphorIcons.users(),
                  PhosphorIcons.users(PhosphorIconsStyle.fill),
                  'Parivar',
                  controller,
                  colors,
                ),
                _buildNavItem(
                  2,
                  PhosphorIcons.storefront(),
                  PhosphorIcons.storefront(PhosphorIconsStyle.fill),
                  'Market',
                  controller,
                  colors,
                ),
                _buildNavItem(
                  3,
                  PhosphorIcons.user(),
                  PhosphorIcons.user(PhosphorIconsStyle.fill),
                  'Profile',
                  controller,
                  colors,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
    HomeController controller,
    AppColorScheme colors,
  ) {
    final isSelected = controller.currentIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? AppSizes.spacingL.w : AppSizes.spacingM.w,
          vertical: AppSizes.spacingS.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusXL.r),
        ),
        child: Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) {
                if (!isSelected) {
                  return LinearGradient(
                    colors: [colors.textSecondary, colors.textSecondary],
                  ).createShader(bounds);
                }
                return LinearGradient(
                  colors: colors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: Icon(
                isSelected ? activeIcon : icon,
                color: Colors.white, // Color is defined by ShaderMask
                size: AppSizes.spacingXXL.w,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected) ...[
                    SizedBox(width: AppSizes.spacingS.w),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: colors.primaryGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        label,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.fontSizeBodySmall.sp,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
