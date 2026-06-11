import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../core/values/colors.dart';

import 'glass_stat_card.dart';
import 'action_row.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/values/sizes.dart';

/// The full dashboard section containing the header banner, stats row,
/// and quick-action items.
class DashboardSection extends StatelessWidget {
  final int familyMembersCount;
  final int businessesCount;
  final ValueChanged<int> changeTab;
  final VoidCallback showFamilyMemberForm;
  final VoidCallback showBusinessForm;

  const DashboardSection({
    super.key,
    required this.familyMembersCount,
    required this.businessesCount,
    required this.changeTab,
    required this.showFamilyMemberForm,
    required this.showBusinessForm,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSizes.spacingL.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dynamic overlapping header banner
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radiusXXL.r),
              gradient: LinearGradient(
                colors: colors.primaryGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.spacingXL.w,
              vertical: AppSizes.spacingXXL.h,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'app_name'.tr,
                        style: GoogleFonts.outfit(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.fontSizeTitleLarge.sp,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'motto'.tr,
                        style: GoogleFonts.outfit(
                          color: AppColors.white.withValues(alpha: 0.9),
                          fontStyle: FontStyle.italic,
                          fontSize: AppSizes.fontSizeBodySmall.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppSizes.spacingM.w),
                Image.asset(
                  'assets/images/logo.png',
                  height: 70.h,
                  width: 70.w,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 65.h,
                      width: 65.w,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.nature_people_rounded,
                        size: 38,
                        color: AppColors.primary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.spacingXXL.h),

          // Stats row using frosted glass cards
          Row(
            children: [
              Expanded(
                child: GlassStatCard(
                  title: 'total_members'.tr,
                  value: '$familyMembersCount',
                  icon: Icons.people_alt_rounded,
                  accentColor: AppColors.tealBridge,
                  onTap: () => changeTab(1),
                ),
              ),
              SizedBox(width: AppSizes.spacingL.w),
              Expanded(
                child: GlassStatCard(
                  title: 'total_businesses'.tr,
                  value: '$businessesCount',
                  icon: Icons.storefront_rounded,
                  accentColor: AppColors.secondary,
                  onTap: () => changeTab(2),
                ),
              ),
            ],
          ),
          SizedBox(height: 28.h),

          // Quick actions Header
          Text(
            'quick_actions'.tr,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: AppSizes.fontSizeBodyLarge.sp,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.spacingM.h),

          // Re-styled Action items
          ActionRow(
            title: 'add_member'.tr,
            subtitle: 'Add a new member to the family records',
            icon: Icons.person_add_alt_1_rounded,
            accentColor: AppColors.tealBridge,
            onTap: () {
              changeTab(1);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showFamilyMemberForm();
              });
            },
          ),
          SizedBox(height: AppSizes.spacingM.h),
          ActionRow(
            title: 'add_business'.tr,
            subtitle: 'Register family-run businesses',
            icon: Icons.add_business_rounded,
            accentColor: AppColors.secondary,
            onTap: () {
              changeTab(2);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showBusinessForm();
              });
            },
          ),
        ],
      ),
    );
  }
}
