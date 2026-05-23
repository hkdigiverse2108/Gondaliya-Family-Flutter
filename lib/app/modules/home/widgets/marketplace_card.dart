import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_color_scheme.dart';
import '../../../../../core/values/colors.dart';
import 'package:gondalia_family/core/values/sizes.dart';

class MarketplaceCard extends StatelessWidget {
  final AppColorScheme colors;
  final String type;
  final String status;
  final String title;
  final String location;
  final String? area;
  final String? date;
  final String price;
  final String priceUnit;
  final String contact;
  final String name;
  final bool isSale;
  final String? imageUrl;

  const MarketplaceCard({
    super.key,
    required this.colors,
    required this.type,
    required this.status,
    required this.title,
    required this.location,
    this.area,
    this.date,
    required this.price,
    required this.priceUnit,
    required this.contact,
    required this.name,
    required this.isSale,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = colors.isDark;

    // Determine badge color based on type
    Color badgeColor;
    if (type.toUpperCase() == 'SALE') {
      badgeColor = AppColors.primary;
    } else if (type.toUpperCase() == 'RENT') {
      badgeColor = AppColors.primaryLight;
    } else {
      badgeColor = const Color(0xFF3B4468);
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.spacingL.w),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
        border: isDark
            ? Border.all(color: AppColors.dividerDark)
            : Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with badge
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        width: 100.w,
                        height: 95.w,
                        color: isDark ? AppColors.bgDark : Colors.grey.shade100,
                        child: imageUrl != null && imageUrl!.isNotEmpty
                            ? Image.network(
                                imageUrl!,
                                width: 100.w,
                                height: 95.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                      Icons.image_outlined,
                                      color: Colors.grey.shade400,
                                      size: 30.sp,
                                    ),
                              )
                            : Icon(
                                Icons.image_outlined,
                                color: Colors.grey.shade400,
                                size: 30.sp,
                              ),
                      ),
                    ),
                    Positioned(
                      top: 6.h,
                      left: 6.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          type.toUpperCase(),
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: AppSizes.fontSizeNano.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: AppSizes.spacingM.w),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 5.w,
                                height: 5.w,
                                decoration: const BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: AppSizes.spacingXS.w),
                              Text(
                                status.toUpperCase(),
                                style: GoogleFonts.outfit(
                                  color: AppColors.success,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.favorite_border_rounded,
                            size: 18.sp,
                            color: isDark
                                ? Colors.white
                                : AppColors.textLightSecondary,
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.spacingXS.h),
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.fontSizeInputHint.sp,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: AppSizes.fontSizeBodySmall.sp,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: AppSizes.spacingXS.w),
                                    Expanded(
                                      child: Text(
                                        location,
                                        style: GoogleFonts.outfit(
                                          fontSize: AppSizes.fontSizeMicro.sp,
                                          color: isDark
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSizes.spacingXS.h),
                                if (isSale) ...[
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.crop_free,
                                        size: AppSizes.fontSizeBodySmall.sp,
                                        color: AppColors.success,
                                      ),
                                      SizedBox(width: AppSizes.spacingXS.w),
                                      Text(
                                        area ?? '',
                                        style: GoogleFonts.outfit(
                                          fontSize: AppSizes.fontSizeMicro.sp,
                                          color: isDark
                                              ? Colors.grey.shade400
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ] else ...[
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        size: AppSizes.fontSizeBodySmall.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                      SizedBox(width: AppSizes.spacingXS.w),
                                      Expanded(
                                        child: Text(
                                          date ?? '',
                                          style: GoogleFonts.outfit(
                                            fontSize: AppSizes.fontSizeMicro.sp,
                                            color: isDark
                                                ? Colors.grey.shade400
                                                : Colors.grey.shade600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (isSale) ...[
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.spacingS.w,
                                vertical: AppSizes.spacingXS.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: colors.primaryGradient,
                                ),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                price,
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: AppSizes.fontSizeBodySmall.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ] else ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  price,
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppSizes.fontSizeBodyMedium.sp,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                Text(
                                  '/ $priceUnit',
                                  style: GoogleFonts.outfit(
                                    fontSize: 9.sp,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AppColors.dividerDark : Colors.grey.shade200,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: AppSizes.spacingS.h,
            ),
            child: Row(
              children: [
                if (!isSale) ...[
                  Expanded(
                    flex: 4,
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(AppSizes.spacingXS.w),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.local_offer_outlined,
                            size: AppSizes.fontSizeBodySmall.sp,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: AppSizes.spacingXS.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price Unit',
                                style: GoogleFonts.outfit(
                                  fontSize: AppSizes.fontSizeNano.sp,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                priceUnit,
                                style: GoogleFonts.outfit(
                                  fontSize: AppSizes.fontSizeMicro.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: AppSizes.spacingL.h,
                    color: isDark
                        ? AppColors.dividerDark
                        : Colors.grey.shade200,
                  ),
                  SizedBox(width: 6.w),
                ],
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: isSale
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.call_outlined,
                        size: AppSizes.fontSizeBodyMedium.sp,
                        color: AppColors.success,
                      ),
                      SizedBox(width: AppSizes.spacingXS.w),
                      Text(
                        contact,
                        style: GoogleFonts.outfit(
                          fontSize: AppSizes.fontSizeMicro.sp,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: AppSizes.spacingL.h,
                  color: isDark ? AppColors.dividerDark : Colors.grey.shade200,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: AppSizes.fontSizeBodyMedium.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: AppSizes.spacingXS.w),
                      Expanded(
                        child: Text(
                          name,
                          style: GoogleFonts.outfit(
                            fontSize: AppSizes.fontSizeMicro.sp,
                            color: isDark ? Colors.white : Colors.black87,
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
    );
  }
}
