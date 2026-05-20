import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../core/values/colors.dart';
import '../../../data/models/business.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.15) : AppColors.shadowLight,
            offset: const Offset(0, 6),
            blurRadius: 16,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top branding/Name & Category row
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(Icons.storefront_rounded, color: AppColors.primary, size: 24.w),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          business.name,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: isDark ? AppColors.white : AppColors.textLightPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          child: Text(
                            business.category,
                            style: GoogleFonts.outfit(
                              color: isDark ? AppColors.secondaryLight : AppColors.secondaryDark,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert_rounded, color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary),
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
                            SizedBox(width: 8.w),
                            Text('edit'.tr, style: GoogleFonts.outfit()),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete_rounded, color: AppColors.error, size: 18),
                            SizedBox(width: 8.w),
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
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                business.description,
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                ),
              ),
            ),
            SizedBox(height: 12.h),

            Container(
              height: 1,
              color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
            ),

            // Address Row
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: AppColors.coralAccent, size: 18),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      business.address,
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        color: isDark ? AppColors.white : AppColors.textLightPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Action Button Row at Bottom
            if (business.contact.isNotEmpty) ...[
              Container(
                height: 1,
                color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
              ),
              Container(
                width: double.infinity,
                color: isDark ? AppColors.primaryDeep : AppColors.bgLight,
                child: TextButton.icon(
                  onPressed: onCall,
                  icon: const Icon(Icons.phone_enabled_rounded, size: 16),
                  label: Text(
                    '${'call_now'.tr} (${business.contact})',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13.sp),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
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
