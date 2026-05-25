import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../routes/app_pages.dart';
import '../../../../global_widgets/neomorphic_button.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/profile_controller.dart';
import 'package:gondalia_family/core/values/sizes.dart';

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final controller = Get.find<HomeController>();
    final profileController = Get.find<ProfileController>();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header / Avatar Section
          Obx(() {
            final user = profileController.currentUser.value;
            final initials = user != null
                ? '${user.firstName.isNotEmpty ? user.firstName[0] : ''}${user.lastName.isNotEmpty ? user.lastName[0] : ''}'
                      .toUpperCase()
                : 'JD';
            final fullName = user != null
                ? '${user.firstName} ${user.middleName} ${user.lastName}'.trim()
                : 'John Doe';
            final phone = user != null ? user.phoneNumber : '+91 98765 43210';
            final familyId = user != null
                ? '#GF-${user.id.substring(0, user.id.length > 6 ? 6 : user.id.length).toUpperCase()}'
                : '#GF-1042';
            final village = user != null && user.village.isNotEmpty
                ? user.village
                : (user?.nativeVillage ?? 'Gondal');
            final membersCount = user != null
                ? user.familyMembers.length.toString()
                : '4';

            return Container(
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
                  SizedBox(height: AppSizes.spacingXL.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 70.r,
                            height: 70.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.card,
                              boxShadow: colors.neumorphicShadow(
                                blur: 10,
                                distance: 2,
                              ),
                              border: Border.all(
                                color: colors.primary.withValues(alpha: 0.08),
                                width: 2,
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient:
                                    user?.profilePhoto == null ||
                                        user!.profilePhoto!.isEmpty
                                    ? LinearGradient(
                                        colors: colors.primaryGradient,
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child:
                                  user?.profilePhoto != null &&
                                      user!.profilePhoto!.isNotEmpty
                                  ? Image.network(
                                      user.profilePhoto!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Center(
                                                child: Text(
                                                  initials,
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                    )
                                  : Center(
                                      child: Text(
                                        initials,
                                        style: GoogleFonts.outfit(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: colors.card,
                              shape: BoxShape.circle,
                              boxShadow: colors.neumorphicShadow(
                                blur: 4,
                                distance: 1,
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(5.w),
                              decoration: BoxDecoration(
                                color: colors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                PhosphorIcons.pencilSimple(),
                                color: Colors.white,
                                size: 12.r,
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
                              fullName,
                              style: GoogleFonts.outfit(
                                fontSize: AppSizes.fontSizeTitleMedium.sp,
                                fontWeight: FontWeight.bold,
                                color: colors.textPrimary,
                              ),
                            ),
                            SizedBox(height: AppSizes.spacingXS.h),
                            Text(
                              phone,
                              style: GoogleFonts.outfit(
                                fontSize: AppSizes.fontSizeBodySmall.sp,
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
                                "${'family_id'.tr}: $familyId",
                                style: GoogleFonts.outfit(
                                  fontSize: AppSizes.fontSizeCaption.sp,
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
                  // Unified statistics container
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.spacingL.w,
                      vertical: AppSizes.spacingM.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.06),
                        width: 1,
                      ),
                      boxShadow: colors.neumorphicShadow(blur: 10, distance: 2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildProfileStatItem(
                            'village'.tr,
                            village,
                            PhosphorIcons.mapPin(PhosphorIconsStyle.fill),
                            colors,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 32.h,
                          color: colors.primary.withValues(alpha: 0.1),
                        ),
                        Expanded(
                          child: _buildProfileStatItem(
                            'members'.tr,
                            membersCount,
                            PhosphorIcons.users(PhosphorIconsStyle.fill),
                            colors,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.spacingXL.h),
                  NeomorphicButton(
                    text: 'edit_profile'.tr,
                    icon: PhosphorIcons.userList(),
                    isGradient: true,
                    width: double.infinity,
                    height: 38.h,
                    fontSize: AppSizes.fontSizeTitleSmall.sp,
                    iconSize: 16.sp,
                    onPressed: () => Get.toNamed(Routes.register),
                  ),
                ],
              ),
            );
          }),

          SizedBox(height: AppSizes.spacingXXL.h),

          // Menu Sections in premium grouped cards
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingXL.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  final user = profileController.currentUser.value;
                  final hasBusiness = user?.workDetails?.hasOwnBusiness == true &&
                      user?.workDetails?.businessDetails != null;
                  return _buildMenuGroup(
                    title: 'manage'.tr,
                    colors: colors,
                    children: [
                      if (hasBusiness)
                        _buildMenuTile(
                          icon: PhosphorIcons.briefcase(),
                          title: 'business_profile'.tr,
                          subtitle: 'business_profile_desc'.tr,
                          colors: colors,
                          onTap: () {
                            Get.toNamed(
                              Routes.business,
                              arguments: {'userId': user!.id, 'user': user},
                            );
                          },
                        ),
                      _buildMenuTile(
                        icon: PhosphorIcons.users(),
                        title: 'family_members'.tr,
                        subtitle: 'family_members_desc'.tr,
                        colors: colors,
                        onTap: () => Get.toNamed(Routes.familyMembers),
                      ),
                      _buildMenuTile(
                        icon: PhosphorIcons.storefront(),
                        title: 'my_business'.tr,
                        subtitle: 'my_business_desc'.tr,
                        colors: colors,
                        onTap: () => Get.toNamed(Routes.myBusiness),
                      ),
                    ],
                  );
                }),
                SizedBox(height: AppSizes.spacingXL.h),

                Obx(
                  () => _buildMenuGroup(
                    title: 'preferences'.tr,
                    colors: colors,
                    children: [
                      _buildMenuTile(
                        icon: PhosphorIcons.moon(),
                        title: 'dark_mode'.tr,
                        subtitle: 'dark_mode_desc'.tr,
                        colors: colors,
                        trailing: Switch(
                          value: controller.isDarkTheme.value,
                          onChanged: (val) => controller.toggleTheme(),
                          activeThumbColor: colors.primary,
                          activeTrackColor: colors.primary.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      _buildMenuTile(
                        icon: PhosphorIcons.translate(),
                        title: 'language'.tr,
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
                    ],
                  ),
                ),
                SizedBox(height: AppSizes.spacingXL.h),

                _buildMenuGroup(
                  title: 'support_about'.tr,
                  colors: colors,
                  children: [
                    _buildMenuTile(
                      icon: PhosphorIcons.lifebuoy(),
                      title: 'help_support'.tr,
                      subtitle: 'help_support_desc'.tr,
                      colors: colors,
                      onTap: () {
                        // TODO: Navigate to Support Page
                      },
                    ),
                    _buildMenuTile(
                      icon: PhosphorIcons.info(),
                      title: 'about_family'.tr,
                      colors: colors,
                      onTap: () {
                        // TODO: Navigate to About
                      },
                    ),
                    _buildMenuTile(
                      icon: PhosphorIcons.signOut(),
                      title: 'logout'.tr,
                      colors: colors,
                      iconColor: Colors.redAccent,
                      titleColor: Colors.redAccent,
                      onTap: () => controller.logout(),
                    ),
                  ],
                ),
                SizedBox(height: 90.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGroup({
    required String title,
    required List<Widget> children,
    required AppColorScheme colors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: AppSizes.spacingS.w,
            bottom: AppSizes.spacingS.h,
          ),
          child: Text(
            title.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: AppSizes.fontSizeMicro.sp,
              fontWeight: FontWeight.bold,
              color: colors.textSecondary.withValues(alpha: 0.8),
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
            border: Border.all(
              color: colors.primary.withValues(alpha: 0.06),
              width: 1,
            ),
            boxShadow: colors.neumorphicShadow(blur: 10, distance: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: children.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 0.5,
                color: colors.primary.withValues(alpha: 0.08),
                indent: AppSizes.spacingL.w + 34.r, // align with title
              ),
              itemBuilder: (context, index) => children[index],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required AppColorScheme colors,
    Widget? trailing,
    Color? iconColor,
    Color? titleColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.spacingL.w,
          vertical: AppSizes.spacingM.h,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.spacingS.w),
              decoration: BoxDecoration(
                color: (iconColor ?? colors.primary).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor ?? colors.primary, size: 18.r),
            ),
            SizedBox(width: AppSizes.spacingM.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontSize: AppSizes.fontSizeBodyMedium.sp,
                      color: titleColor ?? colors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        fontSize: AppSizes.fontSizeCaption.sp,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                Icon(
                  PhosphorIcons.caretRight(),
                  color: colors.textSecondary.withValues(alpha: 0.6),
                  size: 14.r,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStatItem(
    String label,
    String value,
    IconData icon,
    AppColorScheme colors,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(AppSizes.spacingS.w),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: colors.primary, size: 16.r),
        ),
        SizedBox(width: AppSizes.spacingM.w),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: AppSizes.fontSizeBodyMedium.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: AppSizes.fontSizeMicro.sp,
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
    );
  }
}
