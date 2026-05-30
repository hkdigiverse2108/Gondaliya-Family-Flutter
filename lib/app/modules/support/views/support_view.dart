import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:gondalia_family/app/global_widgets/glass_app_bar.dart';
import 'package:gondalia_family/app/global_widgets/neomorphic_card.dart';
import 'package:gondalia_family/app/global_widgets/neomorphic_button.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/values/sizes.dart';
import '../controllers/support_controller.dart';

class SupportView extends GetView<SupportController> {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    return SafeArea(
      top: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: GlassAppBar(titleText: 'help_support'.tr),
        body: Stack(
          children: [
            // Aurora background glow
            Positioned(
              top: -100.h,
              left: -80.w,
              child: Container(
                width: 280.w,
                height: 280.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colors.primary.withValues(alpha: isDark ? 0.15 : 0.2),
                      colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 100.h,
              right: -100.w,
              child: Container(
                width: 320.w,
                height: 320.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colors.secondary.withValues(alpha: isDark ? 0.12 : 0.18),
                      colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!controller.isSuccess.value) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.spacingXL.w,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          PhosphorIcons.warningCircle(PhosphorIconsStyle.fill),
                          color: colors.error,
                          size: 64.r,
                        ),
                        SizedBox(height: AppSizes.spacingM.h),
                        Text(
                          'failed_to_load_support'.tr.isEmpty
                              ? 'Failed to load support contact details.'
                              : 'failed_to_load_support'.tr,
                          style: GoogleFonts.outfit(
                            fontSize: AppSizes.fontSizeBodyLarge.sp,
                            color: colors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSizes.spacingS.h),
                        Text(
                          'please_check_internet'.tr.isEmpty
                              ? 'Please check your internet connection and try again.'
                              : 'please_check_internet'.tr,
                          style: GoogleFonts.outfit(
                            fontSize: AppSizes.fontSizeBodySmall.sp,
                            color: colors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSizes.spacingXXL.h),
                        NeomorphicButton(
                          text: 'retry'.tr.isEmpty ? 'Retry' : 'retry'.tr,
                          onPressed: controller.fetchSupportInfo,
                          isGradient: true,
                          width: 140.w,
                        ),
                      ],
                    ),
                  ),
                );
              }

              final support = controller.supportInfo.value;
              if (support == null) {
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  SizedBox(
                    height:
                        kToolbarHeight +
                        MediaQuery.of(context).padding.top +
                        AppSizes.spacingL.h,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spacingXL.w,
                        vertical: AppSizes.spacingS.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header Center Card
                          NeomorphicCard(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.spacingXL.w,
                              vertical: AppSizes.spacingXL.h,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16.r),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colors.primary.withValues(
                                      alpha: 0.08,
                                    ),
                                  ),
                                  child: Icon(
                                    PhosphorIcons.lifebuoy(
                                      PhosphorIconsStyle.fill,
                                    ),
                                    color: colors.primary,
                                    size: 40.r,
                                  ),
                                ),
                                SizedBox(height: AppSizes.spacingM.h),
                                Text(
                                  'Gondaliya Family Support',
                                  style: GoogleFonts.outfit(
                                    fontSize: AppSizes.fontSizeTitleMedium.sp,
                                    fontWeight: FontWeight.bold,
                                    color: colors.textPrimary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: AppSizes.spacingS.h),
                                Text(
                                  'We are here to help you. Reach out to our family office through any of the channels below.',
                                  style: GoogleFonts.outfit(
                                    fontSize: AppSizes.fontSizeBodySmall.sp,
                                    color: colors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSizes.spacingXL.h),

                          // Contact Numbers Card
                          if (support.phones.isNotEmpty) ...[
                            _buildContactCard(
                              colors: colors,
                              isDark: isDark,
                              title: 'Phone Contacts',
                              icon: PhosphorIcons.phone(
                                PhosphorIconsStyle.fill,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: support.phones.asMap().entries.map((
                                  entry,
                                ) {
                                  final index = entry.key;
                                  final phone = entry.value;
                                  final isLast =
                                      index == support.phones.length - 1;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildContactItem(
                                        colors: colors,
                                        label: index == 0
                                            ? 'Primary Support'
                                            : 'Alternative Support',
                                        value: phone,
                                        onTap: () => controller.makeCall(phone),
                                        actionIcon: PhosphorIcons.phoneCall(),
                                      ),
                                      if (!isLast) const Divider(height: 24),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: AppSizes.spacingXL.h),
                          ],

                          // Email Support Card
                          _buildContactCard(
                            colors: colors,
                            isDark: isDark,
                            title: 'Email Address',
                            icon: PhosphorIcons.envelope(
                              PhosphorIconsStyle.fill,
                            ),
                            child: _buildContactItem(
                              colors: colors,
                              label: 'Official Email Support',
                              value: support.email,
                              onTap: () => controller.sendEmail(support.email),
                              actionIcon: PhosphorIcons.paperPlaneTilt(),
                            ),
                          ),
                          SizedBox(height: AppSizes.spacingXL.h),

                          // Address Card
                          if (support.address != null &&
                              support.address!.trim().isNotEmpty)
                            _buildContactCard(
                              colors: colors,
                              isDark: isDark,
                              title: 'Office Location',
                              icon: PhosphorIcons.mapPin(
                                PhosphorIconsStyle.fill,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    support.address!,
                                    style: GoogleFonts.outfit(
                                      fontSize: AppSizes.fontSizeBodyMedium.sp,
                                      color: colors.textPrimary,
                                      fontWeight: FontWeight.w500,
                                      height: 1.4,
                                    ),
                                  ),
                                  SizedBox(height: AppSizes.spacingM.h),
                                  NeomorphicButton(
                                    text: 'Get Directions',
                                    icon: PhosphorIcons.navigationArrow(),
                                    isGradient: true,
                                    width: double.infinity,
                                    height: 38.h,
                                    fontSize: AppSizes.fontSizeTitleSmall.sp,
                                    iconSize: 16.sp,
                                    onPressed: () =>
                                        controller.openMap(support.address!),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: AppSizes.spacing3XL.h),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required AppColorScheme colors,
    required bool isDark,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return NeomorphicCard(
      padding: EdgeInsets.all(AppSizes.spacingL.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colors.primary, size: 18.r),
              SizedBox(width: AppSizes.spacingS.w),
              Text(
                title.toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: AppSizes.fontSizeMicro.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.textSecondary.withValues(alpha: 0.8),
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.spacingM.h),
          const Divider(height: 1),
          SizedBox(height: AppSizes.spacingM.h),
          child,
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required AppColorScheme colors,
    required String label,
    required String value,
    required VoidCallback onTap,
    required IconData actionIcon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.outfit(
                      fontSize: AppSizes.fontSizeCaption.sp,
                      color: colors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: GoogleFonts.outfit(
                      fontSize: AppSizes.fontSizeBodyLarge.sp,
                      color: colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary.withValues(alpha: 0.08),
              ),
              child: Icon(actionIcon, color: colors.primary, size: 16.r),
            ),
          ],
        ),
      ),
    );
  }
}
