import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../data/models/user.dart';
import '../../home/controllers/profile_controller.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/values/sizes.dart';
import '../../../routes/app_pages.dart';
import '../controllers/job_detail_controller.dart';

class JobDetailView extends GetView<JobDetailController> {
  const JobDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final owner = controller.owner.value;
        if (owner == null || owner.workDetails?.jobDetails == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('job'.tr),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: Get.back,
              ),
            ),
            body: Center(
              child: Text(
                'No Job details set yet.'.tr,
                style: GoogleFonts.outfit(color: colors.textSecondary),
              ),
            ),
          );
        }

        final job = owner.workDetails!.jobDetails!;
        final initials =
            '${owner.firstName.isNotEmpty ? owner.firstName[0] : ''}${owner.lastName.isNotEmpty ? owner.lastName[0] : ''}'
                .toUpperCase();
        final ownerFullName =
            '${owner.firstName} ${owner.middleName} ${owner.lastName}'.trim();

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Sliver App Bar with rich gradient background
            SliverAppBar(
              expandedHeight: 180.h,
              pinned: true,
              stretch: true,
              backgroundColor: colors.card,
              leading: Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: colors.card.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: colors.textPrimary,
                  ),
                  onPressed: Get.back,
                ),
              ),
              actions: [
                Obx(() {
                  UserModel? currentUser;
                  if (Get.isRegistered<ProfileController>()) {
                    currentUser =
                        Get.find<ProfileController>().currentUser.value;
                  }
                  if (currentUser != null && currentUser.id == owner.id) {
                    return Container(
                      margin: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: colors.card.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.edit_rounded, color: colors.primary),
                        onPressed: () => Get.toNamed(Routes.editWork),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                ],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: colors.primaryGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    // Aurora glow overlays
                    Positioned(
                      right: -50.w,
                      top: -50.h,
                      child: Container(
                        width: 180.w,
                        height: 180.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.secondary.withValues(alpha: 0.25),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20.w,
                      bottom: 20.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusS.r,
                              ),
                            ),
                            child: Text(
                              job.jobCategory.toUpperCase(),
                              style: GoogleFonts.outfit(
                                fontSize: AppSizes.fontSizeMicro.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          SizedBox(
                            width: 280.w,
                            child: Text(
                              job.companyName,
                              style: GoogleFonts.outfit(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  const Shadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.all(AppSizes.spacingL.w),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Occupation details header
                  _buildSectionHeader(
                    'occupation_details'.tr,
                    PhosphorIcons.briefcase(),
                    colors,
                  ),
                  SizedBox(height: AppSizes.spacingM.h),

                  // Job Card Details
                  Container(
                    padding: EdgeInsets.all(AppSizes.spacingL.w),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                      boxShadow: colors.neumorphicShadow(blur: 10, distance: 2),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.04),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          'company_name'.tr,
                          job.companyName,
                          colors,
                        ),
                        const Divider(height: 16),
                        _buildInfoRow('category'.tr, job.jobCategory, colors),
                        const Divider(height: 16),
                        _buildInfoRow('job_role'.tr, job.jobRole, colors),
                        const Divider(height: 16),
                        _buildInfoRow(
                          'company_address'.tr,
                          job.jobLocation,
                          colors,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.spacingXL.h),

                  // Profile Owner section
                  _buildSectionHeader(
                    'Employee Profile',
                    PhosphorIcons.user(),
                    colors,
                  ),
                  SizedBox(height: AppSizes.spacingM.h),
                  InkWell(
                    onTap: () {
                      Get.toNamed(
                        Routes.family,
                        arguments: {'userId': owner.id, 'user': owner},
                      );
                    },
                    borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                    child: Container(
                      padding: EdgeInsets.all(AppSizes.spacingL.w),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                        boxShadow: colors.neumorphicShadow(
                          blur: 10,
                          distance: 2,
                        ),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.05),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26.r,
                            backgroundColor: colors.primary.withValues(
                              alpha: 0.1,
                            ),
                            child: Text(
                              initials,
                              style: GoogleFonts.outfit(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: colors.primary,
                              ),
                            ),
                          ),
                          SizedBox(width: AppSizes.spacingL.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ownerFullName,
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppSizes.fontSizeBodyLarge.sp,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'view_owner_profile'.tr,
                                  style: GoogleFonts.outfit(
                                    fontSize: AppSizes.fontSizeCaption.sp,
                                    color: colors.accent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            PhosphorIcons.caretRight(),
                            color: colors.textSecondary.withValues(alpha: 0.6),
                            size: 16.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppSizes.spacing4XL.h),
                ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSectionHeader(
    String title,
    IconData icon,
    AppColorScheme colors,
  ) {
    return Row(
      children: [
        Icon(icon, color: colors.primary, size: 20.sp),
        SizedBox(width: 8.w),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, AppColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        SizedBox(width: AppSizes.spacingS.w),
        Expanded(
          flex: 3,
          child: Text(
            value.isNotEmpty ? value : '-',
            style: GoogleFonts.outfit(
              fontSize: AppSizes.fontSizeBodyMedium.sp,
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
