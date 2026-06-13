import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/values/sizes.dart';
import '../../../../core/config/app_config.dart';
import '../../../routes/app_pages.dart';
import '../../../global_widgets/glass_app_bar.dart';
import '../controllers/my_businesses_controller.dart';

class MyBusinessesView extends GetView<MyBusinessesController> {
  const MyBusinessesView({super.key});

  String _resolveUrl(String? url) {
    if (url == null || url.isEmpty || url == 'null') return '';
    if (url.startsWith('/uploads')) {
      return '${AppConfig.baseUrl}$url';
    }
    if (url.contains('localhost:5000')) {
      return url.replaceAll('http://localhost:5000', AppConfig.baseUrl);
    }
    if (url.contains('127.0.0.1:5000')) {
      return url.replaceAll('http://127.0.0.1:5000', AppConfig.baseUrl);
    }
    return url;
  }

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
          child: GlassAppBar(titleText: 'My Businesses'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(Routes.editBusiness),
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
              if (controller.isLoading.value && controller.myBusinesses.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.myBusinesses.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Icon(
                        PhosphorIcons.storefront(),
                        size: 80.sp,
                        color: colors.primary.withValues(alpha: 0.5),
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingL.h),
                    Text(
                      'No businesses added yet'.tr,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingS.h),
                    Text(
                      'Tap the + button to create a business listing'.tr,
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
                    height: kToolbarHeight +
                        MediaQuery.of(context).padding.top +
                        AppSizes.spacingL.h,
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: controller.fetchMyBusinesses,
                      color: colors.primary,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.spacingXL.w,
                        ),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.myBusinesses.length,
                        itemBuilder: (context, index) {
                          final business = controller.myBusinesses[index];
                          final hasSubCategory = business.subCategory.isNotEmpty;
                          final subText = hasSubCategory
                              ? (business.subCategory.length <= 2
                                  ? business.subCategory.join(', ')
                                  : "${business.subCategory.take(2).join(', ')} +${business.subCategory.length - 2}")
                              : '';
                          final categoryText = subText.isNotEmpty
                              ? '${business.category} • $subText'
                              : business.category;

                          return Container(
                            margin: EdgeInsets.only(bottom: AppSizes.spacingM.h),
                            decoration: BoxDecoration(
                              color: colors.card,
                              borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                              border: Border.all(
                                color: colors.isDark ? colors.divider : Colors.grey.shade200,
                                width: 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                                onTap: () {
                                  Get.toNamed(
                                    Routes.business,
                                    arguments: {
                                      'businessId': business.id,
                                      'userId': business.ownerId,
                                    },
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(AppSizes.spacingM.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 48.r,
                                            height: 48.r,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: colors.primary.withValues(alpha: 0.1),
                                            ),
                                            child: ClipOval(
                                              child: (business.businessLogo != null &&
                                                      business.businessLogo!.isNotEmpty &&
                                                      business.businessLogo != 'null')
                                                  ? Image.network(
                                                      _resolveUrl(business.businessLogo),
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) => Icon(
                                                        PhosphorIcons.storefront(),
                                                        color: colors.primary,
                                                        size: 24.sp,
                                                      ),
                                                    )
                                                  : Icon(
                                                      PhosphorIcons.storefront(),
                                                      color: colors.primary,
                                                      size: 24.sp,
                                                    ),
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
                                                    fontSize: 16.sp,
                                                    color: colors.textPrimary,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 2.h),
                                                Text(
                                                  categoryText,
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 12.sp,
                                                    color: colors.primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (business.description.isNotEmpty) ...[
                                        SizedBox(height: AppSizes.spacingS.h),
                                        Text(
                                          business.description,
                                          style: GoogleFonts.outfit(
                                            fontSize: 12.sp,
                                            color: colors.textSecondary,
                                            height: 1.3,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                      Divider(
                                        height: 24.h,
                                        color: colors.isDark ? colors.divider : Colors.grey.shade200,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          TextButton.icon(
                                            icon: Icon(Icons.edit_outlined, size: 16.sp, color: colors.primary),
                                            label: Text('Edit', style: GoogleFonts.outfit(fontSize: 12.sp, color: colors.primary, fontWeight: FontWeight.bold)),
                                            onPressed: () => Get.toNamed(
                                              Routes.editBusiness,
                                              arguments: {'business': business},
                                            ),
                                          ),
                                          SizedBox(width: AppSizes.spacingS.w),
                                          TextButton.icon(
                                            icon: const Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                                            label: Text('Delete', style: GoogleFonts.outfit(fontSize: 12.sp, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                                            onPressed: () {
                                              Get.dialog(
                                                AlertDialog(
                                                  backgroundColor: colors.card,
                                                  title: Text(
                                                    'Delete Business',
                                                    style: GoogleFonts.outfit(
                                                      color: colors.textPrimary,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    'Are you sure you want to delete "${business.name}"?',
                                                    style: GoogleFonts.outfit(color: colors.textSecondary),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: Get.back,
                                                      child: Text('Cancel', style: GoogleFonts.outfit(color: colors.textSecondary)),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Get.back();
                                                        controller.deleteBusiness(business.id);
                                                      },
                                                      child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
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
