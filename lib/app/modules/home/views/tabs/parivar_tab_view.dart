import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gondalia_family/app/modules/home/controllers/parivar_controller.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/values/colors.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/values/sizes.dart';

class ParivarTabView extends StatelessWidget {
  const ParivarTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;
    final controller = Get.find<ParivarController>();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.spacingL.w,
              vertical: AppSizes.spacingS.h,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) =>
                        controller.parivarSearchQuery.value = val,
                    decoration: InputDecoration(
                      hintText: 'Search by Name, Profession, or Village...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: isDark
                          ? AppColors.cardDark
                          : Colors.grey.shade100,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: AppSizes.spacingM.w,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.spacingS.w),
                GestureDetector(
                  onTap: () => _showVillageFilter(context, controller, colors),
                  child: Container(
                    padding: EdgeInsets.all(AppSizes.spacingM.w),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                    ),
                    child: Icon(
                      Icons.filter_list_rounded,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Selected Village Indicator
          Obx(() {
            if (controller.selectedVillage.value == 'All') {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.spacingL.w,
                vertical: AppSizes.spacingXS.h,
              ),
              child: Row(
                children: [
                  Text(
                    'Filtered by: ',
                    style: GoogleFonts.outfit(
                      color: colors.textSecondary,
                      fontSize: AppSizes.fontSizeBodySmall.sp,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.spacingS.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.selectedVillage.value,
                          style: GoogleFonts.outfit(
                            color: AppColors.primary,
                            fontSize: AppSizes.fontSizeBodySmall.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        GestureDetector(
                          onTap: () => controller.selectedVillage.value = 'All',
                          child: Icon(
                            Icons.close,
                            size: 14.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          // List of Members
          Expanded(
            child: Obx(() {
              if (controller.isParivarLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final members = controller.filteredParivar;
              if (members.isEmpty) {
                return Center(
                  child: Text(
                    'No parivar members found.',
                    style: GoogleFonts.outfit(color: colors.textSecondary),
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.spacingL.w,
                  vertical: AppSizes.spacingS.h,
                ),
                itemCount: members.length,
                separatorBuilder: (context, index) =>
                    SizedBox(height: AppSizes.spacingM.h),
                itemBuilder: (context, index) {
                  final member = members[index].head;
                  return Container(
                    padding: EdgeInsets.all(AppSizes.spacingL.w),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28.r,
                          backgroundColor: AppColors.primaryLight.withValues(
                            alpha: 0.2,
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            color: AppColors.primary,
                            size: AppSizes.radius3XL.r,
                          ),
                        ),
                        SizedBox(width: AppSizes.spacingL.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${member.firstName} ${member.lastName}',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppSizes.fontSizeBodyLarge.sp,
                                  color: colors.textPrimary,
                                ),
                              ),
                              if (member.workDetailsSummary != null &&
                                  member.workDetailsSummary!.isNotEmpty) ...[
                                SizedBox(height: AppSizes.spacingXS.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.work_outline,
                                      size: AppSizes.fontSizeBodyMedium.sp,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: AppSizes.spacingXS.w),
                                    Expanded(
                                      child: Text(
                                        member.workDetailsSummary!,
                                        style: GoogleFonts.outfit(
                                          fontSize:
                                              AppSizes.fontSizeBodySmall.sp,
                                          color: Colors.grey,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              SizedBox(height: AppSizes.spacingXXS.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: AppSizes.fontSizeBodyMedium.sp,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: AppSizes.spacingXS.w),
                                  Text(
                                    member.village,
                                    style: GoogleFonts.outfit(
                                      fontSize: AppSizes.fontSizeBodySmall.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.phone_rounded,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            // Make call using member.phoneNumber
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showVillageFilter(
    BuildContext context,
    ParivarController controller,
    AppColorScheme colors,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXL.r),
        ),
      ),
      builder: (context) {
        return Obx(() {
          final villages = controller.parivarVillages;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(AppSizes.spacingL.w),
                child: Text(
                  'Select Village',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: AppSizes.fontSizeTitleSmall.sp,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: villages.length,
                  itemBuilder: (context, index) {
                    final village = villages[index];
                    final isSelected =
                        controller.selectedVillage.value == village;
                    return ListTile(
                      title: Text(
                        village,
                        style: GoogleFonts.outfit(
                          color: isSelected
                              ? AppColors.primary
                              : colors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: AppColors.primary)
                          : null,
                      onTap: () {
                        controller.selectedVillage.value = village;
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
