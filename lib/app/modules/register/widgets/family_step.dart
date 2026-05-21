import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/values/colors.dart';
import '../../../../core/values/sizes.dart';
import '../../../global_widgets/generation_avatar.dart';
import '../../../global_widgets/neomorphic_card.dart';
import '../controllers/register_controller.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';

class FamilyStep extends StatelessWidget {
  final RegisterController controller;
  final VoidCallback onAddMember;

  const FamilyStep({
    super.key,
    required this.controller,
    required this.onAddMember,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'family_details'.tr,
              style: GoogleFonts.outfit(
                fontSize: AppSizes.fontSizeTitleMedium.sp,
                fontWeight: FontWeight.bold,
                color: colors.accent,
              ),
            ),
            ElevatedButton.icon(
              onPressed: onAddMember,
              icon: const Icon(Icons.add, size: 16),
              label: Text(
                'add'.tr,
                style: GoogleFonts.outfit(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.spacingM.h),

        // List of Family Members styled as NeomorphicCards
        Obx(() {
          if (controller.familyMembers.isEmpty) {
            return NeomorphicCard(
              padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 16.w),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.people_alt_outlined,
                      size: 48,
                      color: isDark
                          ? AppColors.textDarkSecondary
                          : AppColors.textLightSecondary,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'no_members_yet'.tr,
                      style: GoogleFonts.outfit(
                        color: isDark
                            ? AppColors.textDarkSecondary
                            : AppColors.textLightSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.familyMembers.length,
            separatorBuilder: (context, index) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              final member = controller.familyMembers[index];
              final genColor = GenerationAvatar.getGenerationColor(
                member.relation,
                30,
              );

              return NeomorphicCard(
                padding: EdgeInsets.all(12.w),
                child: Row(
                  children: [
                    GenerationAvatar(
                      name: member.firstName,
                      color: genColor,
                      radius: 20,
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
                              fontSize: 15.sp,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textLightPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: genColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12.r),
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
                              SizedBox(width: 8.w),
                              Text(
                                '${member.dob} • ${member.occupation}',
                                style: GoogleFonts.outfit(
                                  fontSize: 11.sp,
                                  color: isDark
                                      ? AppColors.textDarkSecondary
                                      : AppColors.textLightSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.error,
                      ),
                      onPressed: () =>
                          controller.removeFamilyMemberDraft(member.id!),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
