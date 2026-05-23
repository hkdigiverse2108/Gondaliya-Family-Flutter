import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gondalia_family/app/global_widgets/glass_app_bar.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import '../controllers/placeholder_home_controller.dart';
import 'package:gondalia_family/core/values/sizes.dart';

class PlaceholderHomeView extends GetView<PlaceholderHomeController> {
  const PlaceholderHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    return Obx(() {
      final user = controller.user.value;
      return SafeArea(
        top: false,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: GlassAppBar(
            title: Text(
              'app_name'.tr,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
                color: colors.textPrimary,
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'select_language'.tr,
                icon: Icon(Icons.language, color: colors.textPrimary),
                onPressed: controller.toggleLanguage,
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
              SizedBox(width: AppSizes.spacingS.w),
            ],
          ),
          body: Stack(
            children: [
              // Aurora Background Glows
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
              // Main Content
              SafeArea(
                child: user == null
                    ? Center(
                        child: CircularProgressIndicator(color: colors.primary),
                      )
                    : SingleChildScrollView(
                        padding: EdgeInsets.all(AppSizes.spacingXL.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(AppSizes.spacingXL.w),
                              decoration: BoxDecoration(
                                color: colors.card,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusL.r,
                                ),
                                border: Border.all(
                                  color: colors.primary.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: colors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'welcome'.tr,
                                    style: GoogleFonts.outfit(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      color: colors.primary,
                                    ),
                                  ),
                                  SizedBox(height: AppSizes.spacingS.h),
                                  Text(
                                    'welcome_desc'.tr,
                                    style: GoogleFonts.outfit(
                                      fontSize: AppSizes.fontSizeBodyMedium.sp,
                                      color: colors.textSecondary,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: AppSizes.spacingXXL.h),
                            _buildSectionHeader(
                              'personal_info'.tr,
                              Icons.person,
                              colors,
                            ),
                            _buildInfoCard(
                              colors: colors,
                              children: [
                                _buildDataRow(
                                  'name'.tr,
                                  '${user.firstName} ${user.middleName} ${user.lastName}',
                                  colors,
                                ),
                                _buildDataRow(
                                  'phone_number'.tr,
                                  user.phoneNumber,
                                  colors,
                                ),
                                _buildDataRow(
                                  'birth_date'.tr,
                                  user.dob,
                                  colors,
                                ),
                                _buildDataRow(
                                  'blood_group'.tr,
                                  user.bloodGroup,
                                  colors,
                                ),
                                _buildDataRow(
                                  'education'.tr,
                                  user.education,
                                  colors,
                                ),
                                _buildDataRow(
                                  'current_address'.tr,
                                  user.currentCity ?? '-',
                                  colors,
                                ),
                              ],
                            ),
                            SizedBox(height: AppSizes.spacingXL.h),
                            if (user.workDetails != null) ...[
                              _buildSectionHeader(
                                'occupation_details'.tr,
                                Icons.work,
                                colors,
                              ),
                              _buildInfoCard(
                                colors: colors,
                                children: [
                                  _buildDataRow(
                                    'has_own_business'.tr,
                                    user.workDetails!.hasOwnBusiness
                                        ? 'yes'.tr
                                        : 'no'.tr,
                                    colors,
                                  ),
                                  if (user.workDetails!.hasOwnBusiness &&
                                      user.workDetails!.businessDetails !=
                                          null) ...[
                                    _buildDataRow(
                                      'business_name'.tr,
                                      user
                                          .workDetails!
                                          .businessDetails!
                                          .businessName,
                                      colors,
                                    ),
                                    _buildDataRow(
                                      'category'.tr,
                                      user
                                          .workDetails!
                                          .businessDetails!
                                          .category,
                                      colors,
                                    ),
                                  ] else if (user.workDetails!.jobDetails !=
                                      null) ...[
                                    _buildDataRow(
                                      'company_name'.tr,
                                      user.workDetails!.jobDetails!.companyName,
                                      colors,
                                    ),
                                    _buildDataRow(
                                      'job_role'.tr,
                                      user.workDetails!.jobDetails!.jobRole,
                                      colors,
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(height: AppSizes.spacingXL.h),
                            ],
                            _buildSectionHeader(
                              '${'family_members'.tr} (${user.familyMembers.length})',
                              Icons.family_restroom,
                              colors,
                            ),
                            if (user.familyMembers.isEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: AppSizes.spacingS.h,
                                ),
                                child: Text(
                                  'no_members_yet'.tr,
                                  style: GoogleFonts.outfit(
                                    color: colors.textSecondary,
                                  ),
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: user.familyMembers.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: AppSizes.spacingM.h),
                                itemBuilder: (context, index) {
                                  final member = user.familyMembers[index];
                                  return _buildInfoCard(
                                    colors: colors,
                                    children: [
                                      _buildDataRow(
                                        'name'.tr,
                                        '${member.firstName} ${member.lastName}',
                                        colors,
                                      ),
                                      _buildDataRow(
                                        'relationship'.tr,
                                        member.relation.isEmpty
                                            ? '-'
                                            : member.relation,
                                        colors,
                                      ),
                                      _buildDataRow(
                                        'phone_number'.tr,
                                        member.phoneNumber.isEmpty
                                            ? '-'
                                            : member.phoneNumber,
                                        colors,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            SizedBox(height: AppSizes.spacing4XL.h),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSectionHeader(
    String title,
    IconData icon,
    AppColorScheme colors,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSizes.spacingM.h,
        left: AppSizes.spacingXS.w,
      ),
      child: Row(
        children: [
          Icon(icon, color: colors.primary, size: 20.sp),
          SizedBox(width: AppSizes.spacingS.w),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required List<Widget> children,
    required AppColorScheme colors,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.spacingL.w),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildDataRow(String label, String value, AppColorScheme colors) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.spacingS.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: AppSizes.fontSizeBodyMedium.sp,
                color: colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(' : ', style: TextStyle(color: colors.textSecondary)),
          Expanded(
            flex: 3,
            child: Text(
              value.isNotEmpty ? value : '-',
              style: GoogleFonts.outfit(
                fontSize: AppSizes.fontSizeBodyMedium.sp,
                color: colors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
