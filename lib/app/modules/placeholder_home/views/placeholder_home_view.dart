import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gondalia_family/app/global_widgets/glass_app_bar.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import '../controllers/placeholder_home_controller.dart';

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
              SizedBox(width: 8.w),
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
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                color: colors.card,
                                borderRadius: BorderRadius.circular(16.r),
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
                                  SizedBox(height: 8.h),
                                  Text(
                                    'welcome_desc'.tr,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      color: colors.textSecondary,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24.h),
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
                            SizedBox(height: 20.h),
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
                              SizedBox(height: 20.h),
                            ],
                            _buildSectionHeader(
                              '${'family_members'.tr} (${user.familyMembers.length})',
                              Icons.family_restroom,
                              colors,
                            ),
                            if (user.familyMembers.isEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
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
                                    SizedBox(height: 12.h),
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
                            SizedBox(height: 40.h),
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
      padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
      child: Row(
        children: [
          Icon(icon, color: colors.primary, size: 20.sp),
          SizedBox(width: 8.w),
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
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(12.r),
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
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
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
                fontSize: 14.sp,
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
