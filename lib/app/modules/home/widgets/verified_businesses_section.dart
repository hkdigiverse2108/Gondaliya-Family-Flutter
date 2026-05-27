import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer/shimmer.dart';

import 'package:gondalia_family/app/routes/app_pages.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/values/sizes.dart';
import 'package:gondalia_family/core/config/app_config.dart';
import 'package:gondalia_family/app/data/models/business.dart';
import '../controllers/home_controller.dart';

class VerifiedBusinessesSection extends StatefulWidget {
  final AppColorScheme colors;

  const VerifiedBusinessesSection({super.key, required this.colors});

  @override
  State<VerifiedBusinessesSection> createState() =>
      _VerifiedBusinessesSectionState();
}

class _VerifiedBusinessesSectionState extends State<VerifiedBusinessesSection> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomeController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchBusinesses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaler.scale(1.0);
    final containerHeight = (230.0 * textScale).clamp(225.0, 265.0);

    return Obx(() {
      if (controller.isBusinessesLoading.value) {
        return _buildShimmerLoading(context, containerHeight);
      }

      final allBusinesses = controller.businesses;
      // Limit to 3 items
      final businesses = allBusinesses.take(3).toList();

      if (businesses.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.spacingL.w,
            vertical: AppSizes.spacingXL.h,
          ),
          child: Center(
            child: Text(
              'no_businesses_yet'.tr,
              style: GoogleFonts.outfit(color: widget.colors.textSecondary),
            ),
          ),
        );
      }

      return SizedBox(
        height: containerHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingL.w),
          itemCount: businesses.length,
          itemBuilder: (context, index) {
            final b = businesses[index];
            return BusinessCard(business: b, colors: widget.colors);
          },
        ),
      );
    });
  }

  Widget _buildShimmerLoading(BuildContext context, double height) {
    final colors = widget.colors;
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingL.w),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 260.w,
            margin: EdgeInsets.only(
              right: AppSizes.spacingL.w,
              bottom: AppSizes.spacingS.h,
            ),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
              border: Border.all(
                color: colors.isDark ? Colors.grey[800]! : Colors.grey[200]!,
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: colors.isDark ? Colors.grey[800]! : Colors.grey[300]!,
              highlightColor: colors.isDark
                  ? Colors.grey[700]!
                  : Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 75.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppSizes.radiusM.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.spacingM.w,
                    ),
                    child: Container(
                      width: 150.w,
                      height: 12.h,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.spacingM.w,
                    ),
                    child: Container(
                      width: 80.w,
                      height: 10.h,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Container(height: 1, color: Colors.white),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.spacingM.w,
                      vertical: AppSizes.spacingS.h,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 12.w,
                          height: 12.h,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4.w),
                        Container(
                          width: 70.w,
                          height: 10.h,
                          color: Colors.white,
                        ),
                        const Spacer(),
                        Container(
                          width: 12.w,
                          height: 12.h,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4.w),
                        Container(
                          width: 70.w,
                          height: 10.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

String _resolveUrl(String? url) {
  if (url == null || url.isEmpty || url == 'null') return '';
  if (url.startsWith('/uploads')) {
    return '${AppConfig.baseUrl}$url';
  }
  if (url.contains('localhost:5000')) {
    return url.replaceAll('http://localhost:5000', AppConfig.baseUrl);
  }
  if (url.contains('127.0.0.1:5000')) {
    return url.replaceAll('http://127.0.0.1:5000', AppConfig.baseUrl);
  }
  return url;
}

class BusinessCard extends StatelessWidget {
  final Business business;
  final AppColorScheme colors;

  const BusinessCard({super.key, required this.business, required this.colors});

  @override
  Widget build(BuildContext context) {
    final isDark = colors.isDark;
    final hasSubCategory = business.subCategory.isNotEmpty;
    final subText = hasSubCategory
        ? (business.subCategory.length <= 2
              ? business.subCategory.join(', ')
              : "${business.subCategory.take(2).join(', ')} +${business.subCategory.length - 2}")
        : '';
    final categoryText = subText.isNotEmpty
        ? "${business.category} • $subText"
        : business.category;

    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.business, arguments: {'userId': business.ownerId});
      },
      child: Container(
        width: 260.w,
        margin: EdgeInsets.only(
          right: AppSizes.spacingL.w,
          bottom: AppSizes.spacingS.h,
        ),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          border: Border.all(
            color: colors.isDark ? colors.divider : Colors.grey.shade200,
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover with primary gradient or banner
            Container(
              height: 75.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSizes.radiusM.r),
                ),
                gradient:
                    (business.businessBanner == null ||
                        business.businessBanner!.isEmpty)
                    ? LinearGradient(
                        colors: colors.primaryGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  if (business.businessBanner != null &&
                      business.businessBanner!.isNotEmpty)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(AppSizes.radiusM.r),
                        ),
                        child: Image.network(
                          _resolveUrl(business.businessBanner),
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
                              ),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: -16.h,
                    left: AppSizes.spacingM.w,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.card, width: 1.5),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            offset: Offset(0, 1.5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 16.r,
                        backgroundColor: colors.card,
                        child: ClipOval(
                          child:
                              (business.businessLogo != null &&
                                  business.businessLogo!.isNotEmpty &&
                                  business.businessLogo != 'null')
                              ? Image.network(
                                  _resolveUrl(business.businessLogo),
                                  width: 32.r,
                                  height: 32.r,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        PhosphorIcons.storefront(),
                                        color: colors.primary,
                                        size: 16.sp,
                                      ),
                                )
                              : Icon(
                                  PhosphorIcons.storefront(),
                                  color: colors.primary,
                                  size: 16.sp,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingM.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    business.name,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (business.ownerName.isNotEmpty) ...[
                    SizedBox(height: 1.h),
                    Text(
                      "By ${business.ownerName}",
                      style: GoogleFonts.outfit(
                        fontSize: 9.sp,
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingM.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
                ),
                child: Text(
                  categoryText,
                  style: GoogleFonts.outfit(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingM.w),
              child: Text(
                business.description,
                style: GoogleFonts.outfit(
                  fontSize: 11.sp,
                  color: colors.textSecondary,
                  height: 1.25,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            Divider(
              height: 1,
              color: isDark ? colors.divider : Colors.grey.shade200,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.spacingM.w,
                vertical: AppSizes.spacingS.h,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          PhosphorIcons.phone(),
                          size: 14.sp,
                          color: colors.primary,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            business.contact,
                            style: GoogleFonts.outfit(
                              fontSize: 10.sp,
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 14.h,
                    color: isDark ? colors.divider : Colors.grey.shade200,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          PhosphorIcons.mapPin(),
                          size: 14.sp,
                          color: colors.primary,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            business.city.isNotEmpty
                                ? business.city
                                : business.address,
                            style: GoogleFonts.outfit(
                              fontSize: 10.sp,
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
