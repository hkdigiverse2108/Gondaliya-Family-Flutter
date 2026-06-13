import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/models/enums.dart';
import '../../../../../core/theme/app_color_scheme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../global_widgets/glass_app_bar.dart';
import '../../../../routes/app_pages.dart';
import 'package:get/get.dart';
import '../../../../global_widgets/neomorphic_text_field.dart';
import '../../widgets/verified_businesses_section.dart';
import '../../widgets/marketplace_section.dart';
import '../../controllers/navigation_controller.dart';
import '../../../../../core/values/sizes.dart';
import '../../../announcements/controllers/announcements_controller.dart';
import '../../../announcements/views/announcements_view.dart';
import '../../controllers/home_controller.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: Text(
          'app_name'.tr,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: colors.textPrimary,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'chat'.tr,
            icon: Icon(PhosphorIcons.chatCircle(), color: colors.textPrimary),
            onPressed: () {
              Get.toNamed(Routes.chat);
            },
          ),
          IconButton(
            tooltip: 'announcements'.tr,
            icon: Icon(PhosphorIcons.megaphone(), color: colors.textPrimary),
            onPressed: () {
              Get.toNamed(Routes.announcements);
            },
          ),
          IconButton(
            tooltip: 'notifications'.tr,
            icon: Icon(PhosphorIcons.bell(), color: colors.textPrimary),
            onPressed: () {
              Get.toNamed(Routes.notifications);
            },
          ),
          SizedBox(width: AppSizes.spacingS.w),
        ],
      ),
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 100) {
              if (controller.businessSearchQuery.value.trim().isNotEmpty ||
                  controller.showAllBusinessMode.value) {
                controller.searchBusinesses(
                  controller.businessSearchQuery.value,
                  loadMore: true,
                );
              }
            }
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total Data Counters
                // _buildStatsCounters(colors),
                SizedBox(height: AppSizes.spacingL.h),

                // Search Bar
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.spacingL.w,
                  ),
                  child: NeomorphicTextField(
                    controller: controller.businessSearchController,
                    hintText: 'search_placeholder'.tr,
                    prefixIcon: Icon(
                      PhosphorIcons.magnifyingGlass(),
                      color: colors.accent,
                    ),
                    showValidationIcon: false,
                    suffixIcon: Obx(() {
                      if (controller.businessSearchQuery.value.isNotEmpty ||
                          controller.showAllBusinessMode.value) {
                        return IconButton(
                          icon: Icon(Icons.clear, color: colors.textSecondary),
                          onPressed: () {
                            controller.businessSearchController.clear();
                            controller.businessSearchQuery.value = '';
                            controller.resetBusinessMode();
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ),
                ),

                SizedBox(height: AppSizes.spacingL.h),

                Obx(() {
                  if (controller.businessSearchQuery.value.trim().isEmpty &&
                      !controller.showAllBusinessMode.value) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStoriesSection(colors, controller, context),

                        SizedBox(height: 18.h),

                        _buildSectionHeader(
                          'verified_businesses'.tr,
                          'see_all'.tr,
                          colors,
                          onTap: controller.loadAllBusinesses,
                        ),
                        SizedBox(height: AppSizes.spacingM.h),
                        VerifiedBusinessesSection(colors: colors),

                        SizedBox(height: AppSizes.spacingXXL.h),

                        _buildSectionHeader(
                          'hot_on_marketplace'.tr,
                          'see_all'.tr,
                          colors,
                          onTap: () => Get.find<NavigationController>().changeTab(2),
                        ),
                        SizedBox(height: AppSizes.spacingM.h),
                        MarketplaceSection(colors: colors),

                        SizedBox(height: AppSizes.spacingXXL.h),

                        _buildSectionHeader(
                          'announcements'.tr,
                          'see_all'.tr,
                          colors,
                          onTap: () => Get.toNamed(Routes.announcements),
                        ),
                        SizedBox(height: AppSizes.spacingM.h),
                        GetX<AnnouncementsController>(
                          init: Get.find<AnnouncementsController>(),
                          builder: (annController) {
                            if (annController.isLoading.value &&
                                annController.announcements.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final list = annController.announcements
                                .take(2)
                                .toList();
                            if (list.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSizes.spacingL.w,
                                  vertical: AppSizes.spacingXL.h,
                                ),
                                child: Center(
                                  child: Text(
                                    'No announcements yet',
                                    style: GoogleFonts.outfit(
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSizes.spacingL.w,
                              ),
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                final a = list[index];
                                final hasImage =
                                    a.imageUrl != null &&
                                    a.imageUrl!.isNotEmpty;
                                return AnnouncementCard(
                                  announcement: a,
                                  colors: colors,
                                  isDark: colors.isDark,
                                  hasImage: hasImage,
                                  isExpandable: false,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    if (controller.isSearchLoading.value) {
                      return Padding(
                        padding: EdgeInsets.only(top: 50.h),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    final results = controller.searchBusinessesList;
                    if (results.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.only(top: 50.h),
                        child: Center(
                          child: Text(
                            controller.showAllBusinessMode.value
                                ? 'no_businesses_yet'.tr
                                : 'No businesses found matching your search.',
                            style: GoogleFonts.outfit(
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spacingL.w,
                        vertical: AppSizes.spacingM.h,
                      ),
                      itemCount:
                          results.length +
                          (controller.isLoadMoreLoading.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == results.length) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        final b = results[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: AppSizes.spacingM.h),
                          decoration: BoxDecoration(
                            color: colors.card,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusM.r,
                            ),
                            border: Border.all(
                              color: colors.isDark
                                  ? colors.divider
                                  : Colors.grey.shade200,
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: colors.isDark ? 0.15 : 0.03,
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusM.r,
                              ),
                              onTap: () {
                                Get.toNamed(
                                  Routes.business,
                                  arguments: {'userId': b.ownerId},
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.all(AppSizes.spacingM.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8.w),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: colors.primary.withValues(
                                              alpha: 0.1,
                                            ),
                                          ),
                                          child: Icon(
                                            PhosphorIcons.storefront(),
                                            color: colors.primary,
                                            size: 20.sp,
                                          ),
                                        ),
                                        SizedBox(width: AppSizes.spacingM.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                b.name,
                                                style: GoogleFonts.outfit(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.sp,
                                                  color: colors.textPrimary,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              if (b.ownerName.isNotEmpty) ...[
                                                SizedBox(height: 2.h),
                                                Text(
                                                  'By ${b.ownerName}',
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 11.sp,
                                                    color: colors.textSecondary,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 4.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: colors.primary.withValues(
                                                alpha: 0.08,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    AppSizes.radiusS.r,
                                                  ),
                                            ),
                                            child: Text(
                                              b.subCategory.isNotEmpty
                                                  ? (b.subCategory.length <= 2
                                                        ? b.subCategory.join(
                                                            ', ',
                                                          )
                                                        : "${b.subCategory.take(2).join(', ')} +${b.subCategory.length - 2}")
                                                  : b.category,
                                              style: GoogleFonts.outfit(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.bold,
                                                color: colors.primary,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: AppSizes.spacingM.h),
                                    Text(
                                      b.description,
                                      style: GoogleFonts.outfit(
                                        fontSize: 12.sp,
                                        color: colors.textSecondary,
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: AppSizes.spacingM.h),
                                    Divider(
                                      height: 1,
                                      color: colors.isDark
                                          ? colors.divider
                                          : Colors.grey.shade200,
                                    ),
                                    SizedBox(height: AppSizes.spacingS.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Icon(
                                                PhosphorIcons.phone(),
                                                size: 14.sp,
                                                color: colors.primary,
                                              ),
                                              SizedBox(width: 4.w),
                                              Expanded(
                                                child: Text(
                                                  b.contact,
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 11.sp,
                                                    color: colors.textSecondary,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 1,
                                          height: 14.h,
                                          color: colors.isDark
                                              ? colors.divider
                                              : Colors.grey.shade200,
                                        ),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Icon(
                                                PhosphorIcons.mapPin(),
                                                size: 14.sp,
                                                color: colors.primary,
                                              ),
                                              SizedBox(width: 4.w),
                                              Expanded(
                                                child: Text(
                                                  b.city.isNotEmpty
                                                      ? b.city
                                                      : b.address,
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 11.sp,
                                                    color: colors.textSecondary,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
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
                      },
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'IT & Software':
        return PhosphorIcons.desktop();
      case 'Accounting & Finance':
        return PhosphorIcons.calculator();
      case 'Sales & Marketing':
        return PhosphorIcons.trendUp();
      case 'Office & Administration':
        return PhosphorIcons.buildings();
      case 'Medical & Healthcare':
        return PhosphorIcons.firstAid();
      case 'Education & Training':
        return PhosphorIcons.graduationCap();
      case 'Engineering':
        return PhosphorIcons.hardHat();
      case 'Hotel & Restaurant':
        return PhosphorIcons.forkKnife();
      case 'Retail & Shopping':
        return PhosphorIcons.shoppingCart();
      case 'Automobile':
        return PhosphorIcons.car();
      case 'Beauty & Fashion':
        return PhosphorIcons.scissors();
      case 'Labour & Helper':
        return PhosphorIcons.users();
      case 'Security & Housekeeping':
        return PhosphorIcons.shield();
      case 'Delivery & Logistics':
        return PhosphorIcons.package();
      case 'Construction & Real Estate':
        return PhosphorIcons.crane();
      case 'Media & Entertainment':
        return PhosphorIcons.camera();
      case 'Agriculture & Farming':
        return PhosphorIcons.plant();
      case 'Freelance & Part Time':
        return PhosphorIcons.laptop();
      case 'Customer Support':
        return PhosphorIcons.headset();
      default:
        return PhosphorIcons.briefcase();
    }
  }

  Widget _buildStoriesSection(
    AppColorScheme colors,
    HomeController controller,
    BuildContext context,
  ) {
    final allCategories = AppEnums.jobCategories.keys.toList();
    final categoriesToShow = allCategories.take(7).toList();

    return SizedBox(
      height: 98.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingL.w),
        itemCount: categoriesToShow.length + 1,
        itemBuilder: (context, index) {
          final isMoreCard = index == categoriesToShow.length;
          final categoryName = isMoreCard ? 'See All' : categoriesToShow[index];
          final icon = isMoreCard
              ? PhosphorIcons.squaresFour()
              : _getCategoryIcon(categoryName);

          return GestureDetector(
            onTap: () {
              if (isMoreCard) {
                _showAllCategoriesBottomSheet(
                  context,
                  colors,
                  allCategories,
                  controller,
                );
              } else {
                controller.businessSearchController.text = categoryName;
              }
            },
            child: Padding(
              padding: EdgeInsets.only(right: AppSizes.spacingXL.w),
              child: SizedBox(
                width: 70.w,
                child: Column(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.card,
                        boxShadow: colors.neumorphicShadow(
                          blur: 8,
                          distance: 3,
                        ),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: colors.primaryGradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Icon(icon, color: Colors.white, size: 28.w),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingXS.h),
                    Text(
                      categoryName,
                      style: GoogleFonts.outfit(
                        fontSize: AppSizes.fontSizeMicro.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAllCategoriesBottomSheet(
    BuildContext context,
    AppColorScheme colors,
    List<String> allCategories,
    HomeController controller,
  ) {
    Get.bottomSheet(
      Container(
        height: 480.h,
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusXL.r),
          ),
          border: Border.all(
            color: colors.isDark ? colors.divider : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: AppSizes.spacingM.h),
            // Bottom Sheet Grab Handle
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: AppSizes.spacingL.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingL.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Categories',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      color: colors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: colors.textSecondary),
                    onPressed: Get.back,
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(AppSizes.spacingL.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: AppSizes.spacingM.w,
                  mainAxisSpacing: AppSizes.spacingL.h,
                  childAspectRatio: 0.85,
                ),
                itemCount: allCategories.length,
                itemBuilder: (context, index) {
                  final categoryName = allCategories[index];
                  final icon = _getCategoryIcon(categoryName);
                  return GestureDetector(
                    onTap: () {
                      Get.back();
                      controller.businessSearchController.text = categoryName;
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50.w,
                          height: 50.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.primary.withValues(alpha: 0.08),
                            border: Border.all(
                              color: colors.primary.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          child: Icon(icon, color: colors.primary, size: 22.w),
                        ),
                        SizedBox(height: AppSizes.spacingS.h),
                        Text(
                          categoryName,
                          style: GoogleFonts.outfit(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildSectionHeader(
    String title,
    String actionText,
    AppColorScheme colors, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingL.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              actionText,
              style: GoogleFonts.outfit(
                fontSize: AppSizes.fontSizeBodyMedium.sp,
                fontWeight: FontWeight.w600,
                color: colors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
