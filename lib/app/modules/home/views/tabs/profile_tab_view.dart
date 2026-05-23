import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../routes/app_pages.dart';
import '../../../../global_widgets/neomorphic_button.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import '../../controllers/home_controller.dart';

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final controller = Get.find<HomeController>();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Add padding to account for the transparent AppBar and status bar
          SizedBox(
            height:
                Scaffold.of(context).appBarMaxHeight ??
                (MediaQuery.of(context).padding.top + kToolbarHeight),
          ),

          // Header / Avatar Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            decoration: BoxDecoration(
              color: colors.card,
              boxShadow: colors.neumorphicShadow(blur: 15, distance: 4),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32.r),
                bottomRight: Radius.circular(32.r),
              ),
            ),
            child: Column(
              children: [
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
                            margin: EdgeInsets.all(4.w),
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
                          padding: EdgeInsets.all(4.w),
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
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Doe',
                            style: GoogleFonts.outfit(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '+91 98765 43210',
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              color: colors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: colors.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              'Family ID: #GF-1042',
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
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
                SizedBox(height: 24.h),
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
                    SizedBox(width: 12.w),
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
                SizedBox(height: 20.h),
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

          SizedBox(height: 24.h),

          // Menu Sections
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage',
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 12.h),

                // My Business Option
                _buildMenuOption(
                  icon: PhosphorIcons.storefront(),
                  title: 'My Business',
                  subtitle: 'Manage your listings and inquiries',
                  colors: colors,
                  onTap: () => Get.toNamed(Routes.myBusiness),
                ),

                SizedBox(height: 24.h),
                Text(
                  'Preferences',
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 12.h),

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

                SizedBox(height: 24.h),
                Text(
                  'Support & About',
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 12.h),

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

                SizedBox(height: 24.h),

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
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: colors.neumorphicInsetShadow(),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
          minVerticalPadding: 0,
          leading: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: (iconColor ?? colors.primary).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor ?? colors.primary, size: 20.r),
          ),
          title: Text(
            title,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
              color: titleColor ?? colors.textPrimary,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 11.sp,
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: colors.neumorphicInsetShadow(blur: 6, distance: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colors.primary, size: 20.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 11.sp,
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
