import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gondalia_family/app/modules/home/controllers/parivar_controller.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/values/colors.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/values/sizes.dart';
import 'package:gondalia_family/app/data/models/parivar_directory.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  return PremiumParivarCard(
                    parivar: members[index],
                    colors: colors,
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

class PremiumParivarCard extends StatefulWidget {
  final ParivarDirectory parivar;
  final AppColorScheme colors;

  const PremiumParivarCard({
    super.key,
    required this.parivar,
    required this.colors,
  });

  @override
  State<PremiumParivarCard> createState() => _PremiumParivarCardState();
}

class _PremiumParivarCardState extends State<PremiumParivarCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    final head = widget.parivar.head;
    final family = widget.parivar.familyMembers;
    final hasFamily = family.isNotEmpty;

    final initials =
        '${head.firstName.isNotEmpty ? head.firstName[0] : ''}${head.lastName.isNotEmpty ? head.lastName[0] : ''}'
            .toUpperCase();

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: colors.neumorphicShadow(blur: 10, distance: 3),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              InkWell(
                onTap: hasFamily
                    ? () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      }
                    : null,
                borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.spacingL.w),
                  child: Row(
                    children: [
                      // Premium Initials Avatar
                      Container(
                        width: 56.r,
                        height: 56.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: colors.primaryGradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: GoogleFonts.outfit(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSizes.spacingL.w),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${head.firstName} ${head.lastName}',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: AppSizes.fontSizeTitleSmall.sp,
                                color: colors.textPrimary,
                              ),
                            ),
                            if (head.workDetailsSummary != null &&
                                head.workDetailsSummary!.isNotEmpty) ...[
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.work_outline_rounded,
                                    size: 14.sp,
                                    color: colors.textSecondary,
                                  ),
                                  SizedBox(width: 6.w),
                                  Expanded(
                                    child: Text(
                                      head.workDetailsSummary!,
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
                            ],
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 14.sp,
                                  color: colors.textSecondary,
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    head.village,
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
                          ],
                        ),
                      ),
                      // Phone Call Action
                      Container(
                        decoration: BoxDecoration(
                          color: colors.card,
                          shape: BoxShape.circle,
                          boxShadow: colors.neumorphicShadow(
                            blur: 6,
                            distance: 2,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.phone_rounded,
                            color: Colors.green,
                          ),
                          onPressed: () async {
                            final uri = Uri.parse('tel:${head.phoneNumber}');
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (hasFamily)
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: colors.textSecondary,
                      size: 22.r,
                    ),
                  ),
                ),
            ],
          ),
          // Expanded Family Members Section
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              padding: EdgeInsets.only(
                left: AppSizes.spacingL.w,
                right: AppSizes.spacingL.w,
                bottom: AppSizes.spacingL.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  SizedBox(height: AppSizes.spacingS.h),
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline_rounded,
                        size: 16.sp,
                        color: colors.primary,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'family_members'.tr,
                        style: GoogleFonts.outfit(
                          fontSize: AppSizes.fontSizeBodySmall.sp,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.spacingM.h),
                  ...family.map((f) {
                    final memberInitials =
                        '${f.firstName.isNotEmpty ? f.firstName[0] : ''}${f.lastName.isNotEmpty ? f.lastName[0] : ''}'
                            .toUpperCase();
                    return Container(
                      margin: EdgeInsets.only(bottom: AppSizes.spacingS.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spacingM.w,
                        vertical: AppSizes.spacingS.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.04),
                          width: 1,
                        ),
                        boxShadow: colors.neumorphicInsetShadow(
                          blur: 4,
                          distance: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18.r,
                            backgroundColor: colors.primary.withValues(
                              alpha: 0.1,
                            ),
                            child: Text(
                              memberInitials,
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: colors.primary,
                              ),
                            ),
                          ),
                          SizedBox(width: AppSizes.spacingM.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${f.firstName} ${f.lastName}',
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              AppSizes.fontSizeBodyMedium.sp,
                                          color: colors.textPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: AppSizes.spacingS.w),
                                    // Relation Chip
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getRelationColor(
                                          f.relation,
                                          colors,
                                        ).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(
                                          AppSizes.radiusS.r,
                                        ),
                                        border: Border.all(
                                          color: _getRelationColor(
                                            f.relation,
                                            colors,
                                          ).withValues(alpha: 0.2),
                                        ),
                                      ),
                                      child: Text(
                                        f.relation,
                                        style: GoogleFonts.outfit(
                                          fontSize: AppSizes.fontSizeCaption.sp,
                                          fontWeight: FontWeight.bold,
                                          color: _getRelationColor(
                                            f.relation,
                                            colors,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (f.workDetailsSummary != null &&
                                    f.workDetailsSummary!.isNotEmpty) ...[
                                  SizedBox(height: 2.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.work_outline_rounded,
                                        size: 12.sp,
                                        color: colors.textSecondary,
                                      ),
                                      SizedBox(width: 4.w),
                                      Expanded(
                                        child: Text(
                                          f.workDetailsSummary!,
                                          style: GoogleFonts.outfit(
                                            fontSize:
                                                AppSizes.fontSizeCaption.sp,
                                            color: colors.textSecondary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Color _getRelationColor(String relation, AppColorScheme colors) {
    switch (relation.toLowerCase()) {
      case 'wife':
      case 'spouse':
        return Colors.purple;
      case 'son':
        return Colors.blue;
      case 'daughter':
        return Colors.pink;
      case 'father':
        return Colors.teal;
      case 'mother':
        return Colors.orange;
      default:
        return colors.primary;
    }
  }
}
