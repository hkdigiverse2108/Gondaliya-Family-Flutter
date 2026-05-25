import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../routes/app_pages.dart';
import '../../../../global_widgets/neomorphic_button.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import '../../controllers/home_controller.dart';
import 'package:gondalia_family/core/values/sizes.dart';

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final controller = Get.find<HomeController>();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header / Avatar Section
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.spacingXL.w,
              vertical: AppSizes.spacingXXL.h,
            ),
            decoration: BoxDecoration(
              color: colors.card,
              boxShadow: colors.neumorphicShadow(blur: 15, distance: 4),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppSizes.radius3XL.r),
                bottomRight: Radius.circular(AppSizes.radius3XL.r),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: AppSizes.spacingXXL.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 80.r,
                          height: 80.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.card,
                            boxShadow: colors.neumorphicShadow(
                              blur: 12,
                              distance: 3,
                            ),
                            border: Border.all(
                              color: colors.primary.withValues(alpha: 0.1),
                              width: 3,
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.all(AppSizes.spacingXS.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: colors.primaryGradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'JD',
                                style: GoogleFonts.outfit(
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(AppSizes.spacingXS.w),
                          decoration: BoxDecoration(
                            color: colors.card,
                            shape: BoxShape.circle,
                            boxShadow: colors.neumorphicShadow(
                              blur: 4,
                              distance: 1,
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              PhosphorIcons.pencilSimple(),
                              color: Colors.white,
                              size: 14.r,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: AppSizes.spacingXL.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Doe',
                            style: GoogleFonts.outfit(
                              fontSize: AppSizes.fontSizeTitleLarge.sp,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: AppSizes.spacingXS.h),
                          Text(
                            '+91 98765 43210',
                            style: GoogleFonts.outfit(
                              fontSize: AppSizes.fontSizeBodyMedium.sp,
                              color: colors.textSecondary,
                            ),
                          ),
                          SizedBox(height: AppSizes.spacingS.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: AppSizes.spacingXS.h,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusM.r,
                              ),
                              border: Border.all(
                                color: colors.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              'Family ID: #GF-1042',
                              style: GoogleFonts.outfit(
                                fontSize: AppSizes.fontSizeBodySmall.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.spacingXXL.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildProfileStat(
                        'Village',
                        'Gondal',
                        PhosphorIcons.mapPin(PhosphorIconsStyle.fill),
                        colors,
                      ),
                    ),
                    SizedBox(width: AppSizes.spacingM.w),
                    Expanded(
                      child: _buildProfileStat(
                        'Members',
                        '4',
                        PhosphorIcons.users(PhosphorIconsStyle.fill),
                        colors,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.spacingXL.h),
                NeomorphicButton(
                  text: 'Edit Profile',
                  icon: PhosphorIcons.userList(),
                  isGradient: true,
                  width: double.infinity,
                  height: 44.h,
                  onPressed: () => Get.toNamed(Routes.register),
                ),
              ],
            ),
          ),

          SizedBox(height: AppSizes.spacingXXL.h),

          // Menu Sections
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingXL.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage',
                  style: GoogleFonts.outfit(
                    fontSize: AppSizes.fontSizeInputHint.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: AppSizes.spacingM.h),

                // My Business Option
                _buildMenuOption(
                  icon: PhosphorIcons.storefront(),
                  title: 'My Business',
                  subtitle: 'Manage your listings and inquiries',
                  colors: colors,
                  onTap: () => Get.toNamed(Routes.myBusiness),
                ),

                SizedBox(height: AppSizes.spacingXXL.h),
                Text(
                  'Preferences',
                  style: GoogleFonts.outfit(
                    fontSize: AppSizes.fontSizeInputHint.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: AppSizes.spacingM.h),

                Obx(
                  () => _buildMenuOption(
                    icon: PhosphorIcons.moon(),
                    title: 'Dark Mode',
                    subtitle: 'Toggle theme preference',
                    colors: colors,
                    trailing: Switch(
                      value: controller.isDarkTheme.value,
                      onChanged: (val) => controller.toggleTheme(),
                      activeThumbColor: colors.primary,
                      activeTrackColor: colors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                ),

                _buildMenuOption(
                  icon: PhosphorIcons.translate(),
                  title: 'Language',
                  subtitle: Get.locale?.languageCode == 'gu'
                      ? 'ગુજરાતી'
                      : 'English',
                  colors: colors,
                  onTap: () {
                    // Quick toggle between EN and GU
                    final currentLang = Get.locale?.languageCode;
                    controller.changeLanguage(
                      currentLang == 'gu' ? 'en' : 'gu',
                    );
                  },
                ),

                SizedBox(height: AppSizes.spacingXXL.h),
                Text(
                  'Support & About',
                  style: GoogleFonts.outfit(
                    fontSize: AppSizes.fontSizeInputHint.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: AppSizes.spacingM.h),

                _buildMenuOption(
                  icon: PhosphorIcons.lifebuoy(),
                  title: 'Help & Support',
                  subtitle: 'Contact support for any queries',
                  colors: colors,
                  onTap: () {
                    // TODO: Navigate to Support Page
                  },
                ),

                _buildMenuOption(
                  icon: PhosphorIcons.info(),
                  title: 'About Gondaliya Family',
                  colors: colors,
                  onTap: () {
                    // TODO: Navigate to About
                  },
                ),

                SizedBox(height: AppSizes.spacingXXL.h),

                _buildMenuOption(
                  icon: PhosphorIcons.signOut(),
                  title: 'Logout',
                  colors: colors,
                  iconColor: Colors.redAccent,
                  titleColor: Colors.redAccent,
                  onTap: () => controller.logout(),
                ),

                SizedBox(height: 80.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    String? subtitle,
    required AppColorScheme colors,
    Widget? trailing,
    Color? iconColor,
    Color? titleColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
          boxShadow: colors.neumorphicInsetShadow(),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSizes.spacingL.w,
            vertical: 0.h,
          ),
          minVerticalPadding: 0,
          leading: Container(
            padding: EdgeInsets.all(AppSizes.spacingS.w),
            decoration: BoxDecoration(
              color: (iconColor ?? colors.primary).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor ?? colors.primary,
              size: AppSizes.radiusXL.r,
            ),
          ),
          title: Text(
            title,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w600,
              fontSize: AppSizes.fontSizeInputText.sp,
              color: titleColor ?? colors.textPrimary,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: AppSizes.fontSizeCaption.sp,
                    color: colors.textSecondary,
                  ),
                )
              : null,
          trailing:
              trailing ??
              Icon(
                PhosphorIcons.caretRight(),
                color: colors.textSecondary,
                size: 18.r,
              ),
        ),
      ),
    );
  }

  Widget _buildProfileStat(
    String label,
    String value,
    IconData icon,
    AppColorScheme colors,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.spacingL.w,
        vertical: AppSizes.spacingM.h,
      ),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: colors.neumorphicInsetShadow(blur: 6, distance: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.spacingS.w),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colors.primary, size: AppSizes.radiusXL.r),
          ),
          SizedBox(width: AppSizes.spacingM.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: AppSizes.fontSizeBodyLarge.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: AppSizes.fontSizeCaption.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
