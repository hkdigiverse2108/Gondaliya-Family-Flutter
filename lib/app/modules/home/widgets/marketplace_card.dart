import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_color_scheme.dart';
import '../../../../../core/values/colors.dart';

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
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(12.r),
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
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 12.w),
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
                              SizedBox(width: 4.w),
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
                      SizedBox(height: 4.h),
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
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
                                    Icon(Icons.location_on_outlined, size: 12.sp, color: AppColors.primary),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(
                                        location,
                                        style: GoogleFonts.outfit(
                                          fontSize: 10.sp,
                                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                if (isSale) ...[
                                  Row(
                                    children: [
                                      Icon(Icons.crop_free, size: 12.sp, color: AppColors.success),
                                      SizedBox(width: 4.w),
                                      Text(
                                        area ?? '',
                                        style: GoogleFonts.outfit(
                                          fontSize: 10.sp,
                                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ] else ...[
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today_outlined, size: 12.sp, color: Colors.grey.shade600),
                                      SizedBox(width: 4.w),
                                      Expanded(
                                        child: Text(
                                          date ?? '',
                                          style: GoogleFonts.outfit(
                                            fontSize: 10.sp,
                                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
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
                                horizontal: 8.w,
                                vertical: 4.h,
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
                                  fontSize: 12.sp,
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
                                    fontSize: 14.sp,
                                    color: isDark ? Colors.white : Colors.black87,
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
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Row(
              children: [
                if (!isSale) ...[
                  Expanded(
                    flex: 4,
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.local_offer_outlined, size: 12.sp, color: AppColors.primary),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Price Unit', style: GoogleFonts.outfit(fontSize: 8.sp, color: Colors.grey)),
                              Text(priceUnit, style: GoogleFonts.outfit(fontSize: 10.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 16.h, color: isDark ? AppColors.dividerDark : Colors.grey.shade200),
                  SizedBox(width: 6.w),
                ],
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: isSale ? MainAxisAlignment.center : MainAxisAlignment.start,
                    children: [
                      Icon(Icons.call_outlined, size: 14.sp, color: AppColors.success),
                      SizedBox(width: 4.w),
                      Text(contact, style: GoogleFonts.outfit(fontSize: 10.sp, color: isDark ? Colors.white : Colors.black87)),
                    ],
                  ),
                ),
                Container(width: 1, height: 16.h, color: isDark ? AppColors.dividerDark : Colors.grey.shade200),
                SizedBox(width: 6.w),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: isSale ? MainAxisAlignment.center : MainAxisAlignment.start,
                    children: [
                      Icon(Icons.person_outline, size: 14.sp, color: AppColors.primary),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          name,
                          style: GoogleFonts.outfit(fontSize: 10.sp, color: isDark ? Colors.white : Colors.black87),
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
