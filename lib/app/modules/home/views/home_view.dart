import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/values/colors.dart';

import '../widgets/dashboard_section.dart';
import '../widgets/family_member_card.dart';
import '../widgets/business_card.dart';
import '../widgets/family_member_form_sheet.dart';
import '../widgets/business_form_sheet.dart';
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
            // Aurora Background Glows
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

            // Views container
            IndexedStack(
              index: controller.currentIndex.value,
              children: [
                DashboardSection(
                  familyMembersCount: controller.familyMembers.length,
                  businessesCount: controller.businesses.length,
                  changeTab: controller.changeTab,
                  showFamilyMemberForm: () => showFamilyMemberFormSheet(context, controller: controller),
                  showBusinessForm: () => showBusinessFormSheet(context, controller: controller),
                ),
                _buildFamilyMembers(context),
                _buildBusinesses(context),
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
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.dashboard_outlined),
                activeIcon: const Icon(Icons.dashboard_rounded),
                label: 'dashboard'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.people_outline_rounded),
                activeIcon: const Icon(Icons.people_rounded),
                label: 'family_members'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.business_center_outlined),
                activeIcon: const Icon(Icons.business_center_rounded),
                label: 'businesses'.tr,
              ),
            ],
          ),
        ),
        floatingActionButton: controller.currentIndex.value == 0
            ? null
            : FloatingActionButton(
                onPressed: () {
                  if (controller.currentIndex.value == 1) {
                    showFamilyMemberFormSheet(context, controller: controller);
                  } else {
                    showBusinessFormSheet(context, controller: controller);
                  }
                },
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                elevation: 4,
                child: const Icon(Icons.add_rounded, size: 28),
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

  // --- Family Members View ---

  Widget _buildFamilyMembers(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Search field
        Padding(
          padding: EdgeInsets.all(16.w),
          child: TextField(
            onChanged: (val) => controller.familySearchQuery.value = val,
            style: GoogleFonts.outfit(fontSize: 14.sp),
            decoration: InputDecoration(
              hintText: '${'search'.tr}...',
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primaryLight),
              suffixIcon: Obx(() {
                if (controller.familySearchQuery.value.isNotEmpty) {
                  return IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () => controller.familySearchQuery.value = '',
                  );
                }
                return const SizedBox.shrink();
              }),
            ),
          ),
        ),

        // List View
        Expanded(
          child: Obx(() {
            final list = controller.filteredFamilyMembers;
            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline_rounded,
                      size: 64.w,
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'no_members_yet'.tr,
                      style: GoogleFonts.outfit(
                        color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: list.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final member = list[index];
                return FamilyMemberCard(
                  member: member,
                  onEdit: () => showFamilyMemberFormSheet(context, controller: controller, member: member),
                  onDelete: () => showDeleteConfirmation(context, controller: controller, isMember: true, id: member.id),
                  onCall: () => _makePhoneCall(member.phoneNumber),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  // --- Businesses View ---

  Widget _buildBusinesses(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Search field
        Padding(
          padding: EdgeInsets.all(16.w),
          child: TextField(
            onChanged: (val) => controller.businessSearchQuery.value = val,
            style: GoogleFonts.outfit(fontSize: 14.sp),
            decoration: InputDecoration(
              hintText: '${'search'.tr}...',
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primaryLight),
              suffixIcon: Obx(() {
                if (controller.businessSearchQuery.value.isNotEmpty) {
                  return IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () => controller.businessSearchQuery.value = '',
                  );
                }
                return const SizedBox.shrink();
              }),
            ),
          ),
        ),

        // List View
        Expanded(
          child: Obx(() {
            final list = controller.filteredBusinesses;
            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.storefront_rounded,
                      size: 64.w,
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'no_businesses_yet'.tr,
                      style: GoogleFonts.outfit(
                        color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: list.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final business = list[index];
                return BusinessCard(
                  business: business,
                  onEdit: () => showBusinessFormSheet(context, controller: controller, business: business),
                  onDelete: () => showDeleteConfirmation(context, controller: controller, isMember: false, id: business.id),
                  onCall: () => _makePhoneCall(business.contact),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  // --- Actions ---

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      Get.snackbar(
        'Error',
        'Could not launch dialer for number: $phoneNumber',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
