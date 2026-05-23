import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import '../controllers/profile_controller.dart';
import 'package:gondalia_family/core/values/sizes.dart';

class VerifiedBusinessesSection extends StatelessWidget {
  final AppColorScheme colors;

  const VerifiedBusinessesSection({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return GetX<ProfileController>(
      builder: (controller) {
        final businesses = controller.businesses;

        if (businesses.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.spacingL.w,
              vertical: AppSizes.spacingXL.h,
            ),
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
            padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingL.w),
            itemCount: businesses.length,
            itemBuilder: (context, index) {
              final b = businesses[index];
              return Container(
                width: 260.w,
                margin: EdgeInsets.only(
                  right: AppSizes.spacingL.w,
                  bottom: AppSizes.spacingS.h,
                ),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
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
                          top: Radius.circular(AppSizes.radiusL.r),
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
                            top: AppSizes.spacingS.h,
                            right: AppSizes.spacingS.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.spacingS.w,
                                vertical: AppSizes.spacingXS.h,
                              ),
                              decoration: BoxDecoration(
                                color: colors.warning.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusS.r,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    PhosphorIcons.checkCircle(
                                      PhosphorIconsStyle.fill,
                                    ),
                                    color: Colors.white,
                                    size: AppSizes.fontSizeBodySmall.sp,
                                  ),
                                  SizedBox(width: AppSizes.spacingXS.w),
                                  Text(
                                    'VERIFIED',
                                    style: GoogleFonts.outfit(
                                      fontSize: AppSizes.fontSizeMicro.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -AppSizes.spacingXL.h,
                            left: AppSizes.spacingM.w,
                            child: CircleAvatar(
                              radius: AppSizes.radiusXL.r,
                              backgroundColor: colors.card,
                              child: Icon(
                                PhosphorIcons.briefcase(),
                                color: colors.primary,
                                size: AppSizes.radiusXL.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingXXL.h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spacingM.w,
                      ),
                      child: Text(
                        b.name,
                        style: GoogleFonts.outfit(
                          fontSize: AppSizes.fontSizeBodyLarge.sp,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spacingM.w,
                      ),
                      child: Text(
                        b.description,
                        style: GoogleFonts.outfit(
                          fontSize: AppSizes.fontSizeBodySmall.sp,
                          color: colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spacingM.w,
                        vertical: AppSizes.spacingM.h,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            PhosphorIcons.star(PhosphorIconsStyle.fill),
                            color: colors.warning,
                            size: AppSizes.fontSizeBodyMedium.sp,
                          ),
                          SizedBox(width: AppSizes.spacingXS.w),
                          Text(
                            '4.8', // Mocked rating for now
                            style: GoogleFonts.outfit(
                              fontSize: AppSizes.fontSizeBodySmall.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                          SizedBox(width: AppSizes.spacingM.w),
                          Icon(
                            PhosphorIcons.mapPin(),
                            color: colors.textSecondary,
                            size: AppSizes.fontSizeBodyMedium.sp,
                          ),
                          SizedBox(width: AppSizes.spacingXS.w),
                          Expanded(
                            child: Text(
                              b.address,
                              style: GoogleFonts.outfit(
                                fontSize: AppSizes.fontSizeBodySmall.sp,
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
