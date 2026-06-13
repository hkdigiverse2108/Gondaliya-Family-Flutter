import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/values/sizes.dart';
import '../../../routes/app_pages.dart';
import '../../../global_widgets/glass_app_bar.dart';
import '../../home/widgets/marketplace_card.dart';
import '../controllers/my_listings_controller.dart';
import '../../../../core/utils/time_utils.dart';

class MyListingsView extends GetView<MyListingsController> {
  const MyListingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    return SafeArea(
      top: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: GlassAppBar(titleText: 'My Listings'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(Routes.listingForm);
          },
          backgroundColor: colors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: Stack(
          children: [
            // Background glows
            Positioned(
              top: -100.h,
              left: -80.w,
              child: Container(
                width: 280.w,
                height: 280.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colors.primary.withValues(alpha: isDark ? 0.15 : 0.2),
                      colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 100.h,
              right: -100.w,
              child: Container(
                width: 320.w,
                height: 320.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colors.secondary.withValues(alpha: isDark ? 0.12 : 0.18),
                      colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Obx(() {
              if (controller.isLoading.value && controller.myListings.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.myListings.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Icon(
                        Icons.storefront_outlined,
                        size: 80.sp,
                        color: colors.primary.withValues(alpha: 0.5),
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingL.h),
                    Text(
                      'No listings added yet',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingS.h),
                    Text(
                      'Tap the + button to create a new listing',
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  SizedBox(
                    height:
                        kToolbarHeight +
                        MediaQuery.of(context).padding.top +
                        AppSizes.spacingL.h,
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: controller.fetchMyListings,
                      color: colors.primary,
                      child: ListView.separated(
                        padding: EdgeInsets.only(
                          bottom: AppSizes.spacingXXL.h * 2,
                        ),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.myListings.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: AppSizes.spacingM.h),
                        itemBuilder: (context, index) {
                          final l = controller.myListings[index];
                          final availableDateStr =
                              '${l.availableFrom.day} ${TimeUtils.getMonthName(l.availableFrom.month)} ${l.availableFrom.year}';

                          return Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: AppSizes.spacingL.w,
                            ),
                            decoration: BoxDecoration(
                              color: colors.card,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusM.r,
                              ),
                              border: Border.all(
                                color: isDark
                                    ? colors.divider
                                    : Colors.grey.shade200,
                                width: 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: isDark ? 0.15 : 0.03,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(
                                      Routes.listingDetail,
                                      arguments: {'listing': l},
                                    );
                                  },
                                  child: IgnorePointer(
                                    child: MarketplaceCard(
                                      colors: colors,
                                      type: l.type,
                                      status: l.status,
                                      title: l.title,
                                      location:
                                          '${l.location.city} • ${l.location.pincode}',
                                      area: l.description,
                                      date: 'From $availableDateStr',
                                      price: '₹ ${l.price}',
                                      priceUnit: l.priceUnit == 'FIXED'
                                          ? 'Total'
                                          : l.priceUnit,
                                      contact: l.contactPhone,
                                      name: l.postedBy,
                                      isSale: l.type.toUpperCase() == 'SALE',
                                      imageUrl: l.photos?.isNotEmpty == true
                                          ? l.photos!.first
                                          : null,
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  color: isDark
                                      ? colors.divider
                                      : Colors.grey.shade200,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSizes.spacingM.w,
                                    vertical: AppSizes.spacingS.h,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                        icon: Icon(
                                          Icons.edit_outlined,
                                          size: 16.sp,
                                          color: colors.primary,
                                        ),
                                        label: Text(
                                          'Edit',
                                          style: GoogleFonts.outfit(
                                            fontSize: 12.sp,
                                            color: colors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.toNamed(
                                            Routes.listingForm,
                                            arguments: {'listing': l},
                                          );
                                        },
                                      ),
                                      SizedBox(width: AppSizes.spacingS.w),
                                      TextButton.icon(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          size: 16,
                                          color: Colors.redAccent,
                                        ),
                                        label: Text(
                                          'Delete',
                                          style: GoogleFonts.outfit(
                                            fontSize: 12.sp,
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.dialog(
                                            AlertDialog(
                                              backgroundColor: colors.card,
                                              title: Text(
                                                'Delete Listing',
                                                style: GoogleFonts.outfit(
                                                  color: colors.textPrimary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              content: Text(
                                                'Are you sure you want to delete "${l.title}"?',
                                                style: GoogleFonts.outfit(
                                                  color: colors.textSecondary,
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: Get.back,
                                                  child: Text(
                                                    'Cancel',
                                                    style: GoogleFonts.outfit(
                                                      color:
                                                          colors.textSecondary,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Get.back();
                                                    controller.deleteListing(
                                                      l.id,
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      color: Colors.redAccent,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
