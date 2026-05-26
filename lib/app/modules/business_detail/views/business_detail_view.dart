import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:gondalia_family/app/data/models/user.dart';
import 'package:gondalia_family/app/data/models/work_details.dart';
import 'package:gondalia_family/app/modules/home/controllers/profile_controller.dart';

import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/values/sizes.dart';
import 'package:gondalia_family/app/routes/app_pages.dart';
import '../controllers/business_detail_controller.dart';

class BusinessDetailView extends GetView<BusinessDetailController> {
  const BusinessDetailView({super.key});

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
        if (owner == null || owner.workDetails?.businessDetails == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('business'.tr),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              ),
            ),
            body: Center(
              child: Text(
                'no_businesses_yet'.tr,
                style: GoogleFonts.outfit(color: colors.textSecondary),
              ),
            ),
          );
        }

        final biz = owner.workDetails!.businessDetails!;
        final initials =
            '${owner.firstName.isNotEmpty ? owner.firstName[0] : ''}${owner.lastName.isNotEmpty ? owner.lastName[0] : ''}'
                .toUpperCase();
        final ownerFullName =
            '${owner.firstName} ${owner.middleName} ${owner.lastName}'.trim();

        UserModel? currentUser;
        if (Get.isRegistered<ProfileController>()) {
          currentUser = Get.find<ProfileController>().currentUser.value;
        }
        final isOwner = currentUser != null && currentUser.id == owner.id;

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
                  onPressed: () => Get.back(),
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
                              biz.category.toUpperCase(),
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
                              biz.businessName,
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
                  // Category Tag if subcategory exists
                  if (biz.subCategory.isNotEmpty) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusM.r,
                          ),
                          border: Border.all(
                            color: colors.primary.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Text(
                          biz.subCategory,
                          style: GoogleFonts.outfit(
                            fontSize: AppSizes.fontSizeBodySmall.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingL.h),
                  ],

                  // Quick Actions Bar: Call, WhatsApp, DM
                  if (!isOwner) ...[
                    _buildQuickActionsRow(
                      biz: biz,
                      owner: owner,
                      colors: colors,
                      controller: controller,
                    ),
                    SizedBox(height: AppSizes.spacingXL.h),
                  ],

                  // Description card
                  if (biz.description.isNotEmpty) ...[
                    _buildSectionHeader(
                      'description'.tr,
                      PhosphorIcons.article(),
                      colors,
                    ),
                    SizedBox(height: AppSizes.spacingM.h),
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
                        biz.description,
                        style: GoogleFonts.outfit(
                          fontSize: AppSizes.fontSizeBodyMedium.sp,
                          color: colors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingXL.h),
                  ],

                  // Business Owner section
                  _buildSectionHeader(
                    'owner_name'.tr,
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
                                  biz.ownerName.isNotEmpty
                                      ? biz.ownerName
                                      : ownerFullName,
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
                  SizedBox(height: AppSizes.spacingXL.h),

                  // Locations section
                  if (biz.locations.isNotEmpty) ...[
                    _buildSectionHeader(
                      'business_address'.tr,
                      PhosphorIcons.mapPin(),
                      colors,
                    ),
                    SizedBox(height: AppSizes.spacingM.h),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: biz.locations.length,
                      itemBuilder: (context, idx) {
                        final loc = biz.locations[idx];
                        return Container(
                          margin: EdgeInsets.only(bottom: AppSizes.spacingM.h),
                          padding: EdgeInsets.all(AppSizes.spacingL.w),
                          decoration: BoxDecoration(
                            color: colors.card,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusL.r,
                            ),
                            boxShadow: colors.neumorphicShadow(
                              blur: 10,
                              distance: 2,
                            ),
                            border: Border.all(
                              color: colors.primary.withValues(alpha: 0.04),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${'branch'.tr} ${idx + 1}',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppSizes.fontSizeBodySmall.sp,
                                  color: colors.primary,
                                ),
                              ),
                              SizedBox(height: AppSizes.spacingS.h),
                              Text(
                                loc.shopAddress,
                                style: GoogleFonts.outfit(
                                  fontSize: AppSizes.fontSizeBodyMedium.sp,
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${loc.areaCity}, ${loc.state} - ${loc.pincode}',
                                style: GoogleFonts.outfit(
                                  fontSize: AppSizes.fontSizeBodySmall.sp,
                                  color: colors.textSecondary,
                                ),
                              ),
                              if (loc.googleMapLink.isNotEmpty) ...[
                                SizedBox(height: AppSizes.spacingM.h),
                                InkWell(
                                  onTap: () async {
                                    final uri = Uri.parse(loc.googleMapLink);
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(
                                        uri,
                                        mode: LaunchMode.externalApplication,
                                      );
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.radiusM.r,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                      horizontal: 12.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.primary.withValues(
                                        alpha: 0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.radiusM.r,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          PhosphorIcons.navigationArrow(
                                            PhosphorIconsStyle.fill,
                                          ),
                                          color: colors.primary,
                                          size: 14.sp,
                                        ),
                                        SizedBox(width: 6.w),
                                        Text(
                                          'map_link'.tr,
                                          style: GoogleFonts.outfit(
                                            fontSize:
                                                AppSizes.fontSizeBodySmall.sp,
                                            fontWeight: FontWeight.bold,
                                            color: colors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: AppSizes.spacingXL.h),
                  ],

                  // Contact Details Section
                  if (biz.contactInfo != null) ...[
                    _buildSectionHeader(
                      'business_contact'.tr,
                      PhosphorIcons.phone(),
                      colors,
                    ),
                    SizedBox(height: AppSizes.spacingM.h),
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
                      child: Column(
                        children: [
                          if (biz.contactInfo!.mobile1.isNotEmpty)
                            _buildContactRow(
                              icon: PhosphorIcons.phone(
                                PhosphorIconsStyle.fill,
                              ),
                              label: 'mobile_1'.tr,
                              value: biz.contactInfo!.mobile1,
                              colors: colors,
                              onTap: () => launchUrl(
                                Uri.parse('tel:${biz.contactInfo!.mobile1}'),
                              ),
                            ),
                          if (biz.contactInfo!.mobile2.isNotEmpty) ...[
                            const Divider(height: 16),
                            _buildContactRow(
                              icon: PhosphorIcons.phone(
                                PhosphorIconsStyle.fill,
                              ),
                              label: 'mobile_2'.tr,
                              value: biz.contactInfo!.mobile2,
                              colors: colors,
                              onTap: () => launchUrl(
                                Uri.parse('tel:${biz.contactInfo!.mobile2}'),
                              ),
                            ),
                          ],
                          if (biz.contactInfo!.email.isNotEmpty) ...[
                            const Divider(height: 16),
                            _buildContactRow(
                              icon: PhosphorIcons.envelope(
                                PhosphorIconsStyle.fill,
                              ),
                              label: 'email'.tr,
                              value: biz.contactInfo!.email,
                              colors: colors,
                              onTap: () => launchUrl(
                                Uri.parse('mailto:${biz.contactInfo!.email}'),
                              ),
                            ),
                          ],
                          if (biz.contactInfo!.website.isNotEmpty) ...[
                            const Divider(height: 16),
                            _buildContactRow(
                              icon: PhosphorIcons.globe(
                                PhosphorIconsStyle.fill,
                              ),
                              label: 'website'.tr,
                              value: biz.contactInfo!.website,
                              colors: colors,
                              onTap: () => launchUrl(
                                Uri.parse(biz.contactInfo!.website),
                                mode: LaunchMode.externalApplication,
                              ),
                            ),
                          ],
                          if (biz.contactInfo!.portfolioLink.isNotEmpty) ...[
                            const Divider(height: 16),
                            _buildContactRow(
                              icon: PhosphorIcons.browser(
                                PhosphorIconsStyle.fill,
                              ),
                              label: 'portfolio_website'.tr,
                              value: biz.contactInfo!.portfolioLink,
                              colors: colors,
                              onTap: () => launchUrl(
                                Uri.parse(biz.contactInfo!.portfolioLink),
                                mode: LaunchMode.externalApplication,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.spacing4XL.h),
                  ],
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

  Widget _buildContactRow({
    required IconData icon,
    required String label,
    required String value,
    required AppColorScheme colors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: colors.primary, size: 16.sp),
            ),
            SizedBox(width: AppSizes.spacingM.w),
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
                  Text(
                    value,
                    style: GoogleFonts.outfit(
                      fontSize: AppSizes.fontSizeBodyMedium.sp,
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              PhosphorIcons.arrowSquareOut(),
              color: colors.textSecondary.withValues(alpha: 0.5),
              size: 14.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsRow({
    required BusinessDetails biz,
    required UserModel owner,
    required AppColorScheme colors,
    required BusinessDetailController controller,
  }) {
    final rawNumber = biz.contactInfo?.mobile1.isNotEmpty == true
        ? biz.contactInfo!.mobile1
        : owner.phoneNumber;

    return Row(
      children: [
        // Call Button
        Expanded(
          child: _buildActionCard(
            icon: PhosphorIcons.phone(PhosphorIconsStyle.bold),
            label: 'call_now'.tr,
            color: colors.primary,
            onTap: () async {
              try {
                final uri = Uri.parse('tel:$rawNumber');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  Get.snackbar('Error', 'Could not launch dialer');
                }
              } catch (e) {
                Get.snackbar('Error', 'Could not place call');
              }
            },
            colors: colors,
          ),
        ),
        SizedBox(width: AppSizes.spacingM.w),
        // WhatsApp Button
        Expanded(
          child: _buildActionCard(
            icon: PhosphorIcons.chatCircle(PhosphorIconsStyle.bold),
            label: 'whatsapp'.tr,
            color: const Color(0xFF25D366),
            onTap: () async {
              try {
                String cleanPhone = rawNumber.replaceAll(RegExp(r'[^0-9]'), '');
                if (cleanPhone.length == 10) {
                  cleanPhone = '91$cleanPhone';
                }
                final text =
                    'Hi, I am interested in your business: ${biz.businessName}';
                final url =
                    'https://wa.me/$cleanPhone?text=${Uri.encodeComponent(text)}';
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  Get.snackbar('Error', 'Could not open WhatsApp');
                }
              } catch (e) {
                Get.snackbar('Error', 'Could not start WhatsApp chat');
              }
            },
            colors: colors,
          ),
        ),
        SizedBox(width: AppSizes.spacingM.w),
        // DM Button
        Expanded(
          child: Obx(() {
            return _buildActionCard(
              icon: PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.bold),
              label: 'dm'.tr,
              color: colors.accent,
              isLoading: controller.isStartingChat.value,
              onTap: () {
                controller.startDirectMessage();
              },
              colors: colors,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required AppColorScheme colors,
    bool isLoading = false,
  }) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
          boxShadow: colors.neumorphicShadow(blur: 10, distance: 2),
          border: Border.all(
            color: colors.primary.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: color, size: 24.sp),
                  SizedBox(height: 6.h),
                  Text(
                    label,
                    style: GoogleFonts.outfit(
                      fontSize: AppSizes.fontSizeBodySmall.sp,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
