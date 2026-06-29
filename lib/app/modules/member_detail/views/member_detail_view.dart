import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/values/sizes.dart';
import '../../../data/models/work_details.dart';
import '../../../routes/app_pages.dart';
import '../controllers/member_detail_controller.dart';

class MemberDetailView extends GetView<MemberDetailController> {
  const MemberDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final m = controller.member.value;
        final u = controller.linkedUser.value;

        if (m == null && u == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('member_details'.tr),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: Get.back,
              ),
            ),
            body: Center(
              child: Text(
                'no_members_yet'.tr,
                style: GoogleFonts.outfit(color: colors.textSecondary),
              ),
            ),
          );
        }

        // Resolve data from either FamilyMember or UserModel
        final firstName = u?.firstName ?? m?.firstName ?? '';
        final middleName = u?.middleName ?? m?.middleName ?? '';
        final lastName = u?.lastName ?? m?.lastName ?? '';
        final fullName = '$firstName $middleName $lastName'.trim();
        final initials =
            '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
                .toUpperCase();

        final dob = u?.dob ?? m?.dob ?? '-';
        final education = u?.education ?? m?.education ?? '-';
        final isMarried = u?.isMarried ?? m?.isMarried ?? '-';
        final bloodGroup = u?.bloodGroup ?? m?.bloodGroup ?? '-';
        final relation = m?.relation ?? 'Self';
        final phone = u?.phoneNumber ?? m?.phoneNumber ?? '';
        final skills = m?.skills ?? '';

        final workDetails = u?.workDetails ?? m?.workDetails;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Sliver App Bar
            SliverAppBar(
              expandedHeight: 200.h,
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
              flexibleSpace: FlexibleSpaceBar(
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
                    // Centered Avatar
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 35.h),
                          Container(
                            width: 80.r,
                            height: 80.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.card,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                initials,
                                style: GoogleFonts.outfit(
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.bold,
                                  color: colors.primary,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            fullName,
                            style: GoogleFonts.outfit(
                              fontSize: 20.sp,
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                  () {
                    final String relationDisplay;
                    final passedHeadName = controller.headName.value;
                    if (passedHeadName != null &&
                        passedHeadName.isNotEmpty &&
                        relation.trim().toLowerCase() != 'self') {
                      if (Get.locale?.languageCode == 'gu') {
                        final relationGu = _translateRelation(relation);
                        relationDisplay = '$passedHeadName ના $relationGu';
                      } else {
                        relationDisplay = '$relation of $passedHeadName';
                      }
                    } else {
                      relationDisplay = relation;
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
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
                            relationDisplay.toUpperCase(),
                            style: GoogleFonts.outfit(
                              fontSize: AppSizes.fontSizeCaption.sp,
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        if (bloodGroup != '-') ...[
                          SizedBox(width: AppSizes.spacingM.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusM.r,
                              ),
                              border: Border.all(
                                color: Colors.red.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              '${'blood_group'.tr}: $bloodGroup',
                              style: GoogleFonts.outfit(
                                fontSize: AppSizes.fontSizeCaption.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  }(),
                  SizedBox(height: AppSizes.spacingXL.h),

                  // Phone Number Action Card
                  if (phone.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.all(AppSizes.spacingL.w),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                        boxShadow: colors.neumorphicShadow(
                          blur: 10,
                          distance: 2,
                        ),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.04),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              PhosphorIcons.phoneCall(PhosphorIconsStyle.fill),
                              color: Colors.green,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: AppSizes.spacingL.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'phone_number'.tr,
                                  style: GoogleFonts.outfit(
                                    fontSize: AppSizes.fontSizeCaption.sp,
                                    color: colors.textSecondary,
                                  ),
                                ),
                                Text(
                                  phone,
                                  style: GoogleFonts.outfit(
                                    fontSize: AppSizes.fontSizeBodyLarge.sp,
                                    color: colors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final uri = Uri.parse('tel:$phone');
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              }
                            },
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusM.r,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: colors.primary,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusM.r,
                                ),
                              ),
                              child: Text(
                                'call_now'.tr,
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppSizes.fontSizeBodySmall.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingXL.h),
                  ],

                  // Direct Message Action Card (hide if it's the user's own profile)
                  if (u?.id != controller.currentUserId) ...[
                    Container(
                      padding: EdgeInsets.all(AppSizes.spacingL.w),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                        boxShadow: colors.neumorphicShadow(
                          blur: 10,
                          distance: 2,
                        ),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.04),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              PhosphorIcons.chatCircle(PhosphorIconsStyle.fill),
                              color: colors.primary,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: AppSizes.spacingL.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'direct_message'.tr,
                                  style: GoogleFonts.outfit(
                                    fontSize: AppSizes.fontSizeCaption.sp,
                                    color: colors.textSecondary,
                                  ),
                                ),
                                Text(
                                  u != null
                                      ? 'Chat privately'
                                      : 'not_registered_desc'.tr,
                                  style: GoogleFonts.outfit(
                                    fontSize: u != null
                                        ? AppSizes.fontSizeBodyLarge.sp
                                        : AppSizes.fontSizeCaption.sp,
                                    color: colors.textPrimary,
                                    fontWeight: u != null
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (u != null)
                            Obx(() {
                              final starting = controller.isStartingChat.value;
                              return InkWell(
                                onTap: starting
                                    ? null
                                    : () => controller.startDirectMessage(),
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusM.r,
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.primary,
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusM.r,
                                    ),
                                  ),
                                  child: starting
                                      ? SizedBox(
                                          width: 16.w,
                                          height: 16.h,
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                        )
                                      : Text(
                                          'dm_me'.tr,
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                AppSizes.fontSizeBodySmall.sp,
                                          ),
                                        ),
                                ),
                              );
                            })
                          else
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusM.r,
                                ),
                              ),
                              child: Text(
                                'Not Available',
                                style: GoogleFonts.outfit(
                                  color: colors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: AppSizes.fontSizeCaption.sp,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingXL.h),
                  ],

                  // Personal Info Section
                  _buildSectionHeader(
                    'personal_info'.tr,
                    PhosphorIcons.identificationCard(),
                    colors,
                  ),
                  SizedBox(height: AppSizes.spacingM.h),
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
                        _buildInfoRow('birth_date'.tr, dob, colors),
                        const Divider(height: 16),
                        _buildInfoRow('education'.tr, education, colors),
                        const Divider(height: 16),
                        _buildInfoRow(
                          'marital_status'.tr,
                          isMarried.tr,
                          colors,
                        ),
                        if (skills.isNotEmpty) ...[
                          const Divider(height: 16),
                          _buildInfoRow('skill'.tr, skills, colors),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.spacingXL.h),

                  // Occupation Section
                  _buildSectionHeader(
                    'occupation_details'.tr,
                    PhosphorIcons.briefcase(),
                    colors,
                  ),
                  SizedBox(height: AppSizes.spacingM.h),
                  if (workDetails != null &&
                      workDetails.hasOwnBusiness &&
                      workDetails.businessDetails != null)
                    _buildBusinessCard(
                      workDetails.businessDetails!,
                      colors,
                      u?.id ?? '',
                    )
                  else if (workDetails != null &&
                      workDetails.jobDetails != null)
                    _buildJobCard(workDetails.jobDetails!, colors)
                  else if (m?.occupation != null &&
                      m!.occupation!.trim().isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(AppSizes.spacingL.w),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                        boxShadow: colors.neumorphicShadow(
                          blur: 10,
                          distance: 2,
                        ),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.08),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              PhosphorIcons.briefcase(PhosphorIconsStyle.fill),
                              color: colors.primary,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: AppSizes.spacingM.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'occupation'.tr,
                                  style: GoogleFonts.outfit(
                                    fontSize: AppSizes.fontSizeCaption.sp,
                                    color: colors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  m.occupation!,
                                  style: GoogleFonts.outfit(
                                    fontSize: AppSizes.fontSizeBodyLarge.sp,
                                    fontWeight: FontWeight.bold,
                                    color: colors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: EdgeInsets.all(AppSizes.spacingL.w),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                        boxShadow: colors.neumorphicShadow(
                          blur: 10,
                          distance: 2,
                        ),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.04),
                        ),
                      ),
                      child: Text(
                        'none'.tr,
                        style: GoogleFonts.outfit(
                          fontSize: AppSizes.fontSizeBodyMedium.sp,
                          color: colors.textSecondary,
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
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: AppSizes.fontSizeBodyMedium.sp,
            color: colors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value.isNotEmpty ? value : '-',
          style: GoogleFonts.outfit(
            fontSize: AppSizes.fontSizeBodyMedium.sp,
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessCard(
    BusinessDetails biz,
    AppColorScheme colors,
    String userId,
  ) {
    return Container(
      padding: EdgeInsets.all(AppSizes.spacingL.w),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        boxShadow: colors.neumorphicShadow(blur: 10, distance: 2),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  PhosphorIcons.storefront(PhosphorIconsStyle.fill),
                  color: colors.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: AppSizes.spacingM.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      biz.businessName,
                      style: GoogleFonts.outfit(
                        fontSize: AppSizes.fontSizeBodyLarge.sp,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      biz.category,
                      style: GoogleFonts.outfit(
                        fontSize: AppSizes.fontSizeCaption.sp,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (biz.description.isNotEmpty) ...[
            SizedBox(height: AppSizes.spacingM.h),
            Text(
              biz.description,
              style: GoogleFonts.outfit(
                fontSize: AppSizes.fontSizeBodySmall.sp,
                color: colors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          SizedBox(height: AppSizes.spacingL.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await Get.toNamed(
                  Routes.business,
                  arguments: {'userId': userId},
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Text(
                'view_business'.tr,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSizes.fontSizeBodySmall.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(JobDetails job, AppColorScheme colors) {
    return Container(
      padding: EdgeInsets.all(AppSizes.spacingL.w),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        boxShadow: colors.neumorphicShadow(blur: 10, distance: 2),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow('company_name'.tr, job.companyName, colors),
          const Divider(height: 16),
          _buildInfoRow('job_role'.tr, job.jobRole, colors),
          const Divider(height: 16),
          _buildInfoRow('company_address'.tr, job.jobLocation, colors),
        ],
      ),
    );
  }

  /// Translates a stored relation string (English) using the app locale.
  /// Relies on translation keys added to en_us.dart / gu_in.dart.
  String _translateRelation(String relation) {
    // Capitalize first letter to match the key format in AppEnums.relations
    final key = relation.trim().isEmpty
        ? relation
        : relation.trim()[0].toUpperCase() + relation.trim().substring(1);
    return key.tr;
  }
}
