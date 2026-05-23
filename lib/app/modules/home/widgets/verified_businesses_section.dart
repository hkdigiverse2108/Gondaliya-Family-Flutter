import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import '../controllers/home_controller.dart';

class VerifiedBusinessesSection extends StatelessWidget {
  final AppColorScheme colors;

  const VerifiedBusinessesSection({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) {
        final businesses = controller.businesses;

        if (businesses.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Center(
              child: Text(
                'No verified businesses yet.',
                style: GoogleFonts.outfit(color: colors.textSecondary),
              ),
            ),
          );
        }

        return SizedBox(
          height: 260.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: businesses.length,
            itemBuilder: (context, index) {
              final b = businesses[index];
              return Container(
                width: 260.w,
                margin: EdgeInsets.only(right: 16.w, bottom: 8.h),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: colors.neumorphicShadow(blur: 8, distance: 3),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cover Placeholder
                    Container(
                      height: 90.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.r),
                        ),
                        gradient: LinearGradient(
                          colors: colors.primaryGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 8.h,
                            right: 8.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: colors.warning.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    PhosphorIcons.checkCircle(
                                      PhosphorIconsStyle.fill,
                                    ),
                                    color: Colors.white,
                                    size: 12.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'VERIFIED',
                                    style: GoogleFonts.outfit(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -20.h,
                            left: 12.w,
                            child: CircleAvatar(
                              radius: 20.r,
                              backgroundColor: colors.card,
                              child: Icon(
                                PhosphorIcons.briefcase(),
                                color: colors.primary,
                                size: 20.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        b.name,
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        b.description,
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          color: colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            PhosphorIcons.star(PhosphorIconsStyle.fill),
                            color: colors.warning,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '4.8', // Mocked rating for now
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Icon(
                            PhosphorIcons.mapPin(),
                            color: colors.textSecondary,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              b.address,
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
                                color: colors.textSecondary,
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
              );
            },
          ),
        );
      },
    );
  }
}
