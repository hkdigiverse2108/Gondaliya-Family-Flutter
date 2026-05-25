import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'tabs/home_tab_view.dart';
import 'tabs/parivar_tab_view.dart';
import 'tabs/marketplace_tab_view.dart';
import 'tabs/profile_tab_view.dart';
import '../controllers/navigation_controller.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/values/sizes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    // Ensure NavigationController is available
    Get.put(NavigationController());

    return SafeArea(
      top: false,
      child: Scaffold(
        body: Stack(
          children: [
            // Background Gradient blobs to simulate aurora glow (outside reactive builder)
            _buildAuroraBlob(
              colors: colors,
              isDark: isDark,
              top: -100.h,
              left: -100.w,
              size: 300.w,
              alphaPrimary: isDark ? 0.25 : 0.15,
              alphaGradient: 0.4,
              isPrimary: true,
            ),
            _buildAuroraBlob(
              colors: colors,
              isDark: isDark,
              top: 200.h,
              right: -150.w,
              size: 400.w,
              alphaPrimary: isDark ? 0.2 : 0.1,
              alphaGradient: 0.35,
              isPrimary: false,
            ),

            // Reactive tab content using IndexedStack
            Obx(() {
              final navController = Get.find<NavigationController>();
              return IndexedStack(
                index: navController.currentIndex.value,
                children: List.generate(4, (index) {
                  final isVisited = navController.visitedIndices.contains(
                    index,
                  );

                  if (!isVisited) {
                    return const SizedBox.shrink();
                  }

                  return const [
                    HomeTabView(),
                    ParivarTabView(),
                    MarketplaceTabView(),
                    ProfileTabView(),
                  ][index];
                }),
              );
            }),
          ],
        ),
        extendBody: true,
        bottomNavigationBar: _FloatingNavBar(colors: colors, isDark: isDark),
      ),
    );
  }

  Widget _buildAuroraBlob({
    required AppColorScheme colors,
    required bool isDark,
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required double alphaPrimary,
    required double alphaGradient,
    required bool isPrimary,
  }) {
    final baseColor = isPrimary ? colors.primary : colors.secondary;
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: baseColor.withValues(alpha: alphaPrimary),
          gradient: RadialGradient(
            colors: [
              baseColor.withValues(alpha: alphaGradient),
              colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  final AppColorScheme colors;
  final bool isDark;

  const _FloatingNavBar({required this.colors, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: 0.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value * 100),
          child: child,
        );
      },
      child: Container(
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
              child: Builder(
                builder: (context) {
                  final navController = Get.find<NavigationController>();
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _NavItem(
                        index: 0,
                        icon: PhosphorIcons.house(),
                        activeIcon: PhosphorIcons.house(
                          PhosphorIconsStyle.fill,
                        ),
                        label: 'Home',
                        navController: navController,
                        colors: colors,
                      ),
                      _NavItem(
                        index: 1,
                        icon: PhosphorIcons.users(),
                        activeIcon: PhosphorIcons.users(
                          PhosphorIconsStyle.fill,
                        ),
                        label: 'Parivar',
                        navController: navController,
                        colors: colors,
                      ),
                      _NavItem(
                        index: 2,
                        icon: PhosphorIcons.storefront(),
                        activeIcon: PhosphorIcons.storefront(
                          PhosphorIconsStyle.fill,
                        ),
                        label: 'Market',
                        navController: navController,
                        colors: colors,
                      ),
                      _NavItem(
                        index: 3,
                        icon: PhosphorIcons.user(),
                        activeIcon: PhosphorIcons.user(PhosphorIconsStyle.fill),
                        label: 'Profile',
                        navController: navController,
                        colors: colors,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final NavigationController navController;
  final AppColorScheme colors;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.navController,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = navController.currentIndex.value == index;
      return GestureDetector(
        onTap: () {
          if (!isSelected) {
            navController.changeTab(index);
          } else {
            // TODO: Implement scroll to top logic for the active tab
          }
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutBack,
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
              AnimatedScale(
                scale: isSelected ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    key: ValueKey<bool>(isSelected),
                    color: isSelected ? colors.primary : colors.textSecondary,
                    size: AppSizes.spacingXXL.w,
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 350),
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
    });
  }
}
