import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../../../core/values/colors.dart';
import '../../../../routes/app_pages.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Add padding to account for the transparent AppBar and status bar
          SizedBox(height: Scaffold.of(context).appBarMaxHeight ?? (MediaQuery.of(context).padding.top + kToolbarHeight)),
          // Header / Avatar Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
            decoration: BoxDecoration(
              color: colors.card,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        'JD',
                        style: GoogleFonts.outfit(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.edit_rounded, color: Colors.white, size: 16.r),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  'John Doe',
                  style: GoogleFonts.outfit(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '+91 98765 43210',
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16.h),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to Edit Registration Form
                    Get.toNamed(Routes.register);
                  },
                  icon: const Icon(Icons.person_outline_rounded, size: 18),
                  label: Text('Edit Profile', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24.h),

          // Menu Sections
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage',
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 12.h),
                
                // My Business Option
                _buildMenuOption(
                  icon: Icons.storefront_rounded,
                  title: 'My Business',
                  subtitle: 'Manage your listings and inquiries',
                  colors: colors,
                  onTap: () {
                    Get.toNamed(Routes.myBusiness);
                  },
                ),
                
                SizedBox(height: 24.h),
                Text(
                  'Preferences',
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 12.h),
                
                _buildMenuOption(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  subtitle: 'System Default',
                  colors: colors,
                  trailing: Switch(
                    value: isDark,
                    onChanged: (val) {
                      Get.changeThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                    },
                    activeThumbColor: AppColors.primary,
                  ),
                ),
                
                _buildMenuOption(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  subtitle: 'English (App labels in Gujarati)',
                  colors: colors,
                ),

                SizedBox(height: 24.h),
                
                _buildMenuOption(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  colors: colors,
                  color: Colors.redAccent,
                  onTap: () {
                    Get.offAllNamed(Routes.login);
                  },
                ),
                
                SizedBox(height: 40.h),
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
    Color? color,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: (color ?? AppColors.primary).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color ?? AppColors.primary, size: 24.r),
        ),
        title: Text(
          title,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: color,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              )
            : null,
        trailing: trailing ?? Icon(Icons.chevron_right_rounded, color: Colors.grey),
      ),
    );
  }
}
