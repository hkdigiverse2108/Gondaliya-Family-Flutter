import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/utils/time_utils.dart';
import '../controllers/home_controller.dart';

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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
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
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            final a = announcements[index];
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(16.r),
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
                    radius: 16.r,
                    backgroundColor: colors.accent.withValues(alpha: 0.1),
                    child: Icon(
                      PhosphorIcons.megaphone(),
                      color: colors.accent,
                      size: 16.r,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.title,
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          a.description,
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            color: colors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Text(
                              TimeUtils.getTimeAgo(a.createdAt),
                              style: GoogleFonts.outfit(
                                fontSize: 11.sp,
                                color: colors.textSecondary,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'View',
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
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
