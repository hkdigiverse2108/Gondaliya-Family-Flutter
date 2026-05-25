import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/values/sizes.dart';
import 'package:gondalia_family/core/utils/time_utils.dart';
import '../../../data/models/listing.dart';
import '../controllers/listing_detail_controller.dart';

class ListingDetailView extends GetView<ListingDetailController> {
  const ListingDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        final Listing? l = controller.listing.value;
        if (l == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('listing_details'.tr),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Get.back(),
              ),
            ),
            body: Center(
              child: Text(
                'No details available.',
                style: GoogleFonts.outfit(color: colors.textSecondary),
              ),
            ),
          );
        }

        final isSale = l.type.toUpperCase() == 'SALE';
        final availableDateStr =
            "${l.availableFrom.day} ${TimeUtils.getMonthName(l.availableFrom.month)} ${l.availableFrom.year}";

        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Sliver App Bar with slider/cover image
                  SliverAppBar(
                    expandedHeight: 220.h,
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
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground,
                      ],
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (l.photos != null && l.photos!.isNotEmpty) ...[
                            PageView.builder(
                              itemCount: l.photos!.length,
                              itemBuilder: (context, idx) {
                                return Image.network(
                                  l.photos![idx],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: colors.primaryGradient,
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.image_not_supported_outlined,
                                            color: Colors.white,
                                            size: 40.sp,
                                          ),
                                        ),
                                      ),
                                );
                              },
                            ),
                          ] else ...[
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: colors.primaryGradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  PhosphorIcons.houseLine(
                                    PhosphorIconsStyle.fill,
                                  ),
                                  color: Colors.white.withValues(alpha: 0.2),
                                  size: 80.sp,
                                ),
                              ),
                            ),
                          ],
                          // Top overlays (vignette gradient)
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black54,
                                  Colors.transparent,
                                  Colors.black38,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          // Bottom badges inside header
                          Positioned(
                            left: 16.w,
                            bottom: 16.h,
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSale
                                        ? colors.primary
                                        : colors.accent,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    l.type.toUpperCase(),
                                    style: GoogleFonts.outfit(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    l.status.toUpperCase(),
                                    style: GoogleFonts.outfit(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      color: colors.primary,
                                    ),
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
                        // Title & Price Section
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                l.title,
                                style: GoogleFonts.outfit(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.spacingM.h),

                        // Price details Box
                        Container(
                          padding: EdgeInsets.all(AppSizes.spacingL.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: colors.primaryGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusL.r,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'price'.tr.toUpperCase(),
                                    style: GoogleFonts.outfit(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    '₹ ${l.price}',
                                    style: GoogleFonts.outfit(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.radiusM.r,
                                  ),
                                ),
                                child: Text(
                                  l.priceUnit == 'FIXED'
                                      ? 'Total'
                                      : l.priceUnit,
                                  style: GoogleFonts.outfit(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppSizes.spacingXL.h),

                        // Description details
                        if (l.description.isNotEmpty) ...[
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
                            child: Text(
                              l.description,
                              style: GoogleFonts.outfit(
                                fontSize: AppSizes.fontSizeBodyMedium.sp,
                                color: colors.textPrimary,
                                height: 1.5,
                              ),
                            ),
                          ),
                          SizedBox(height: AppSizes.spacingXL.h),
                        ],

                        // Details grid (Location, Availability)
                        _buildSectionHeader(
                          'listing_details'.tr,
                          PhosphorIcons.info(),
                          colors,
                        ),
                        SizedBox(height: AppSizes.spacingM.h),
                        Container(
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
                            children: [
                              _buildDetailRow(
                                icon: PhosphorIcons.mapPin(
                                  PhosphorIconsStyle.fill,
                                ),
                                label: 'city'.tr,
                                value:
                                    '${l.location.city} - ${l.location.pincode}',
                                colors: colors,
                              ),
                              const Divider(height: 20),
                              _buildDetailRow(
                                icon: PhosphorIcons.calendar(
                                  PhosphorIconsStyle.fill,
                                ),
                                label: 'available_from'.tr,
                                value: availableDateStr,
                                colors: colors,
                              ),
                              const Divider(height: 20),
                              _buildDetailRow(
                                icon: PhosphorIcons.user(
                                  PhosphorIconsStyle.fill,
                                ),
                                label: 'posted_by'.tr,
                                value: l.postedBy,
                                colors: colors,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppSizes.spacing3XL.h),
                      ]),
                    ),
                  ),
                ],
              ),
            ),

            // Sticky Bottom Actions bar for Call and WhatsApp
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.spacingL.w,
                vertical: AppSizes.spacingM.h,
              ),
              decoration: BoxDecoration(
                color: colors.card,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: colors.isDark ? 0.3 : 0.08,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final uri = Uri.parse('tel:${l.contactPhone}');
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                      icon: Icon(
                        PhosphorIcons.phone(PhosphorIconsStyle.fill),
                        color: Colors.white,
                      ),
                      label: Text('call_now'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32), // Deep green
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusM.r,
                          ),
                        ),
                        textStyle: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.spacingM.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final text =
                            'Hi, I am interested in your listing: ${l.title}';
                        final url =
                            'https://wa.me/${l.contactPhone}?text=${Uri.encodeComponent(text)}';
                        final uri = Uri.parse(url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      icon: Icon(
                        PhosphorIcons.chatCircle(PhosphorIconsStyle.fill),
                        color: Colors.white,
                      ),
                      label: Text('whatsapp'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF25D366,
                        ), // WhatsApp green
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusM.r,
                          ),
                        ),
                        textStyle: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
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

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required AppColorScheme colors,
  }) {
    return Row(
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
      ],
    );
  }
}
