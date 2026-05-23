import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../core/values/colors.dart';
import '../../../data/models/business.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/values/sizes.dart';

class BusinessCard extends StatelessWidget {
  final Business business;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onCall;

  const BusinessCard({
    super.key,
    required this.business,
    required this.onEdit,
    required this.onDelete,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusXL.r),
        border: Border.all(color: colors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            offset: const Offset(0, 6),
            blurRadius: 16,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusXL.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top branding/Name & Category row
            Padding(
              padding: EdgeInsets.all(AppSizes.spacingL.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(
                      Icons.storefront_rounded,
                      color: AppColors.primary,
                      size: AppSizes.spacingXXL.w,
                    ),
                  ),
                  SizedBox(width: AppSizes.spacingM.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          business.name,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: AppSizes.fontSizeBodyLarge.sp,
                            color: colors.textPrimary,
                          ),
                        ),
                        SizedBox(height: AppSizes.spacingXS.h),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusS.r,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.spacingS.w,
                            vertical: AppSizes.spacingXXS.h,
                          ),
                          child: Text(
                            business.category,
                            style: GoogleFonts.outfit(
                              color: colors.secondary,
                              fontSize: AppSizes.fontSizeMicro.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: colors.textSecondary,
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit_rounded, size: 18),
                            SizedBox(width: AppSizes.spacingS.w),
                            Text('edit'.tr, style: GoogleFonts.outfit()),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete_rounded,
                              color: AppColors.error,
                              size: 18,
                            ),
                            SizedBox(width: AppSizes.spacingS.w),
                            Text(
                              'delete'.tr,
                              style: GoogleFonts.outfit(color: AppColors.error),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Description block
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingL.w),
              child: Text(
                business.description,
                style: GoogleFonts.outfit(
                  fontSize: AppSizes.fontSizeInputHint.sp,
                  color: colors.textSecondary,
                ),
              ),
            ),
            SizedBox(height: AppSizes.spacingM.h),

            Container(height: 1, color: colors.divider),

            // Address Row
            Padding(
              padding: EdgeInsets.all(AppSizes.spacingM.w),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.coralAccent,
                    size: 18,
                  ),
                  SizedBox(width: AppSizes.spacingS.w),
                  Expanded(
                    child: Text(
                      business.address,
                      style: GoogleFonts.outfit(
                        fontSize: AppSizes.fontSizeBodySmall.sp,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Action Button Row at Bottom
            if (business.contact.isNotEmpty) ...[
              Container(height: 1, color: colors.divider),
              Container(
                width: double.infinity,
                color: isDark ? AppColors.primaryDeep : AppColors.bgLight,
                child: TextButton.icon(
                  onPressed: onCall,
                  icon: const Icon(Icons.phone_enabled_rounded, size: 16),
                  label: Text(
                    '${'call_now'.tr} (${business.contact})',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: AppSizes.fontSizeInputHint.sp,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.spacingM.h,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
