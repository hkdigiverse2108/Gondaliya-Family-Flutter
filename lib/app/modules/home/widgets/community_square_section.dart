import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/utils/time_utils.dart';
import '../controllers/home_controller.dart';
import 'package:gondalia_family/core/values/sizes.dart';

class CommunitySquareSection extends StatelessWidget {
  final AppColorScheme colors;

  const CommunitySquareSection({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) {
        final announcements = controller.announcements;

        if (announcements.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.spacingL.w,
              vertical: AppSizes.spacingXL.h,
            ),
            child: Center(
              child: Text(
                'No community updates yet.',
                style: GoogleFonts.outfit(color: colors.textSecondary),
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingL.w),
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            final a = announcements[index];
            return Container(
              margin: EdgeInsets.only(bottom: AppSizes.spacingM.h),
              padding: EdgeInsets.all(AppSizes.spacingL.w),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                boxShadow: colors.neumorphicInsetShadow(blur: 4, distance: 2),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.05),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: AppSizes.radiusL.r,
                    backgroundColor: colors.accent.withValues(alpha: 0.1),
                    child: Icon(
                      PhosphorIcons.megaphone(),
                      color: colors.accent,
                      size: AppSizes.radiusL.r,
                    ),
                  ),
                  SizedBox(width: AppSizes.spacingM.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.title,
                          style: GoogleFonts.outfit(
                            fontSize: AppSizes.fontSizeBodyMedium.sp,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                        SizedBox(height: AppSizes.spacingXS.h),
                        Text(
                          a.description,
                          style: GoogleFonts.outfit(
                            fontSize: AppSizes.fontSizeInputHint.sp,
                            color: colors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: AppSizes.spacingS.h),
                        Row(
                          children: [
                            Text(
                              TimeUtils.getTimeAgo(a.createdAt),
                              style: GoogleFonts.outfit(
                                fontSize: AppSizes.fontSizeCaption.sp,
                                color: colors.textSecondary,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'View',
                              style: GoogleFonts.outfit(
                                fontSize: AppSizes.fontSizeBodySmall.sp,
                                fontWeight: FontWeight.bold,
                                color: colors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
