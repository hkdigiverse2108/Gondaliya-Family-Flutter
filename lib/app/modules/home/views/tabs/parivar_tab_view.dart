import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/parivar_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../routes/app_pages.dart';
import '../../../../data/models/family_member.dart';

import '../../../../../core/values/colors.dart';
import '../../../../../core/theme/app_color_scheme.dart';
import '../../../../../core/values/sizes.dart';
import '../../../../data/models/parivar_directory.dart';
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
          // Search Input Row wrapped in its own Obx
          Obx(() {
            final isVillageGrid = controller.selectedVillage.value.isEmpty;
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.spacingL.w,
                vertical: AppSizes.spacingS.h,
              ),
              child: TextField(
                controller: controller.searchController,
                onChanged: (val) => controller.parivarSearchQuery.value = val,
                decoration: InputDecoration(
                  hintText: isVillageGrid
                      ? 'Search villages...'
                      : 'Search by Name, Profession, or Village...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: controller.parivarSearchQuery.value.isEmpty
                      ? null
                      : GestureDetector(
                          onTap: () {
                            controller.searchController.clear();
                            controller.parivarSearchQuery.value = '';
                          },
                          child: Icon(
                            Icons.clear_rounded,
                            color: colors.textSecondary,
                            size: 20.sp,
                          ),
                        ),
                  filled: true,
                  fillColor: isDark ? AppColors.cardDark : Colors.grey.shade100,
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
            );
          }),

          // Main Content Area wrapped in its own Obx
          Expanded(
            child: Obx(() {
              final isSearching = controller.parivarSearchQuery.value
                  .trim()
                  .isNotEmpty;
              final showGlobalSearch =
                  isSearching && controller.filteredVillages.isEmpty;
              final isVillageGrid =
                  controller.selectedVillage.value.isEmpty && !showGlobalSearch;

              if (controller.isParivarLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!controller.isApiSuccess.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Failed to load parivar details.',
                        style: GoogleFonts.outfit(color: colors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.fetchParivarData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (isVillageGrid) {
                // Render Village Grid View
                final villages = controller.filteredVillages;
                final itemCount = villages.length;

                if (itemCount == 0) {
                  return Center(
                    child: Text(
                      'No villages found.',
                      style: GoogleFonts.outfit(color: colors.textSecondary),
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.spacingL.w,
                    vertical: AppSizes.spacingS.h,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSizes.spacingM.w,
                    mainAxisSpacing: AppSizes.spacingM.h,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    final village = villages[index];
                    return VillageGridCard(
                      name: village,
                      colors: colors,
                      onTap: () => controller.selectVillage(village),
                    );
                  },
                );
              } else {
                // Render Members List of Selected Village
                final members = controller.filteredParivar;

                return Column(
                  children: [
                    // Sub-header selection row
                    if (controller.selectedVillage.value.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.spacingL.w,
                          vertical: AppSizes.spacingS.h,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: controller.clearVillageSelection,
                              child: Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.cardDark
                                      : Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                  boxShadow: colors.neumorphicShadow(
                                    blur: 6,
                                    distance: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  color: colors.textPrimary,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: AppSizes.spacingM.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${controller.selectedVillage.value} Village',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppSizes.fontSizeTitleSmall.sp,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                if (!controller.isDirectoryLoading.value)
                                  Text(
                                    'Showing ${members.length} ${members.length == 1 ? "family" : "families"}',
                                    style: GoogleFonts.outfit(
                                      fontSize: AppSizes.fontSizeCaption.sp,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.spacingL.w,
                          vertical: AppSizes.spacingS.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Global Search Results',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: AppSizes.fontSizeTitleSmall.sp,
                                color: colors.textPrimary,
                              ),
                            ),
                            if (!controller.isDirectoryLoading.value)
                              Text(
                                'Showing ${members.length} matching ${members.length == 1 ? "family" : "families"} across all villages',
                                style: GoogleFonts.outfit(
                                  fontSize: AppSizes.fontSizeCaption.sp,
                                  color: colors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                      ),

                    // The member cards list or loader
                    Expanded(
                      child: controller.isDirectoryLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : (members.isEmpty
                                ? Center(
                                    child: Text(
                                      'No parivar members found.',
                                      style: GoogleFonts.outfit(
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  )
                                : ListView.separated(
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
                                  )),
                    ),
                  ],
                );
              }
            }),
          ),
        ],
      ),
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
                onTap: () {
                  Get.toNamed(
                    Routes.family,
                    arguments: {'userId': widget.parivar.id},
                  );
                },
                borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.spacingL.w),
                  child: Row(
                    children: [
                      // Premium Avatar (Image or Initials)
                      Container(
                        width: 56.r,
                        height: 56.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient:
                              head.profilePhoto == null ||
                                  head.profilePhoto!.isEmpty
                              ? LinearGradient(
                                  colors: colors.primaryGradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child:
                            head.profilePhoto != null &&
                                head.profilePhoto!.isNotEmpty
                            ? Image.network(
                                head.profilePhoto!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(
                                      child: Text(
                                        initials,
                                        style: GoogleFonts.outfit(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                              )
                            : Center(
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
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
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
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusM.r,
                          ),
                          onTap: () {
                            final headName =
                                '${head.firstName} ${head.lastName}';
                            if (f.linkedUserId != null &&
                                f.linkedUserId!.isNotEmpty) {
                              Get.toNamed(
                                Routes.family,
                                arguments: {
                                  'userId': f.linkedUserId,
                                  'headName': headName,
                                },
                              );
                            } else {
                              final dummyMember = FamilyMember(
                                id: f.id,
                                firstName: f.firstName,
                                middleName: '',
                                lastName: f.lastName,
                                relation: f.relation,
                                dob: '',
                                education: '',
                                isMarried: '',
                                bloodGroup: '',
                                phoneNumber: f.phoneNumber ?? '',
                                occupation: f.workDetailsSummary,
                              );
                              Get.toNamed(
                                Routes.family,
                                arguments: {
                                  'member': dummyMember,
                                  'headName': headName,
                                },
                              );
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.spacingM.w,
                              vertical: AppSizes.spacingS.h,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36.r,
                                  height: 36.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        f.profilePhoto == null ||
                                            f.profilePhoto!.isEmpty
                                        ? colors.primary.withValues(alpha: 0.1)
                                        : null,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child:
                                      f.profilePhoto != null &&
                                          f.profilePhoto!.isNotEmpty
                                      ? Image.network(
                                          f.profilePhoto!,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Center(
                                                    child: Text(
                                                      memberInitials,
                                                      style: GoogleFonts.outfit(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: colors.primary,
                                                      ),
                                                    ),
                                                  ),
                                        )
                                      : Center(
                                          child: Text(
                                            memberInitials,
                                            style: GoogleFonts.outfit(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              color: colors.primary,
                                            ),
                                          ),
                                        ),
                                ),
                                SizedBox(width: AppSizes.spacingM.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${f.firstName} ${f.lastName}',
                                              style: GoogleFonts.outfit(
                                                fontWeight: FontWeight.w600,
                                                fontSize: AppSizes
                                                    .fontSizeBodyMedium
                                                    .sp,
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
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                                fontSize:
                                                    AppSizes.fontSizeCaption.sp,
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
                                                  fontSize: AppSizes
                                                      .fontSizeCaption
                                                      .sp,
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
                          ),
                        ),
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

class VillageGridCard extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final AppColorScheme colors;

  const VillageGridCard({
    super.key,
    required this.name,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusXL.r),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.08),
          width: 1.5,
        ),
        boxShadow: colors.neumorphicShadow(blur: 10, distance: 3),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusXL.r),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.spacingL.w,
              vertical: AppSizes.spacingM.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: colors.primaryGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colors.primary.withValues(alpha: 0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: Colors.white,
                        size: 14.r,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: colors.textSecondary.withValues(alpha: 0.3),
                      size: 10.r,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: AppSizes.fontSizeBodyLarge.sp,
                        color: colors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'members'.tr,
                      style: GoogleFonts.outfit(
                        fontSize: AppSizes.fontSizeCaption.sp,
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
