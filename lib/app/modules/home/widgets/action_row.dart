import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../global_widgets/glass_card.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/values/sizes.dart';

/// A tappable action row with icon, title, subtitle, and a chevron indicator.
class ActionRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const ActionRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: GlassCard(
        borderRadius: 18.r,
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.spacingL.w,
          vertical: 14.h,
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
              ),
              padding: EdgeInsets.all(AppSizes.spacingM.w),
              child: Icon(icon, color: accentColor, size: 22.w),
            ),
            SizedBox(width: AppSizes.spacingL.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: AppSizes.fontSizeBodyMedium.sp,
                      color: colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSizes.spacingXXS.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: AppSizes.fontSizeCaption.sp,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colors.textSecondary,
              size: AppSizes.spacingXL.w,
            ),
          ],
        ),
      ),
    );
  }
}
