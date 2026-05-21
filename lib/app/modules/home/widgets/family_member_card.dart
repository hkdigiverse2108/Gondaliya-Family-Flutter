import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../core/values/colors.dart';
import '../../../data/models/family_member.dart';
import '../../../global_widgets/generation_avatar.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';

class FamilyMemberCard extends StatelessWidget {
  final FamilyMember member;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onCall;

  const FamilyMemberCard({
    super.key,
    required this.member,
    required this.onEdit,
    required this.onDelete,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;
    final genColor = GenerationAvatar.getGenerationColor(
      member.relation,
      30, // Using default age for generation color for now since we only have DOB string
    );

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: colors.divider,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            offset: const Offset(0, 6),
            blurRadius: 16,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Column(
          children: [
            // Top Section (Generational avatar & Name)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  GenerationAvatar(
                    name: member.firstName,
                    color: genColor,
                    radius: 22,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${member.firstName} ${member.lastName}',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: isDark
                                ? AppColors.white
                                : AppColors.textLightPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: genColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              child: Text(
                                member.relation,
                                style: GoogleFonts.outfit(
                                  color: genColor,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (member.isMarried.toLowerCase() == 'married') ...[
                              SizedBox(width: 8.w),
                              Icon(
                                Icons.favorite_rounded,
                                color: AppColors.coralAccent,
                                size: 12.w,
                              ),
                            ],
                            if (member.bloodGroup.isNotEmpty) ...[
                              SizedBox(width: 8.w),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.coralAccent.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                child: Text(
                                  member.bloodGroup,
                                  style: GoogleFonts.outfit(
                                    color: AppColors.coralAccent,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: isDark
                          ? AppColors.textDarkSecondary
                          : AppColors.textLightSecondary,
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
                            SizedBox(width: 8.w),
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

            Container(
              height: 1,
              color: colors.divider,
            ),

            // Details section with icons & styling
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconDetail(
                    context,
                    Icons.cake_outlined,
                    'dob'.tr,
                    member.dob,
                  ),
                  _buildIconDetail(
                    context,
                    Icons.work_outline_rounded,
                    'occupation'.tr,
                    member.occupation ?? '',
                  ),
                  _buildIconDetail(
                    context,
                    Icons.school_outlined,
                    'education'.tr,
                    member.education,
                  ),
                ],
              ),
            ),

            if (member.phoneNumber.isNotEmpty) ...[
              Container(
                height: 1,
                color: colors.divider,
              ),
              Container(
                width: double.infinity,
                color: isDark ? AppColors.primaryDeep : AppColors.bgLight,
                child: TextButton.icon(
                  onPressed: onCall,
                  icon: const Icon(Icons.phone_enabled_rounded, size: 16),
                  label: Text(
                    '${'call_now'.tr} (${member.phoneNumber})',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryLight,
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

  Widget _buildIconDetail(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final colors = context.appColors;
    final isDark = colors.isDark;
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16.w, color: AppColors.primaryLight),
          SizedBox(width: 6.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 9.sp,
                    color: isDark
                        ? AppColors.textDarkSecondary
                        : AppColors.textLightSecondary,
                  ),
                ),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.white
                        : AppColors.textLightPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
