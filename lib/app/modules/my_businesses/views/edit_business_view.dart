import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import '../../../global_widgets/glass_app_bar.dart';
import '../../../global_widgets/neomorphic_button.dart';
import '../../../global_widgets/neomorphic_text_field.dart';
import '../../../global_widgets/neomorphic_dropdown_field.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/values/sizes.dart';
import '../../../../core/config/app_config.dart';
import '../../../data/models/enums.dart';
import '../controllers/edit_business_controller.dart';

class EditBusinessView extends GetView<EditBusinessController> {
  const EditBusinessView({super.key});

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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: GlassAppBar(
            titleText: controller.isEditMode ? 'Edit Business' : 'Add Business',
          ),
        ),
        body: Stack(
          children: [
            // Aurora background glow
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
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  SizedBox(
                    height: kToolbarHeight +
                        MediaQuery.of(context).padding.top +
                        AppSizes.spacingL.h,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spacingXL.w,
                        vertical: AppSizes.spacingS.h,
                      ),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildBusinessForm(context, colors),
                            SizedBox(height: AppSizes.spacingXXL.h),
                            NeomorphicButton(
                              text: 'save'.tr,
                              isGradient: true,
                              width: double.infinity,
                              onPressed: controller.saveBusiness,
                            ),
                            SizedBox(height: AppSizes.spacing3XL.h),
                          ],
                        ),
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

  Widget _buildBusinessForm(BuildContext context, AppColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Business Logo
        Center(
          child: Column(
            children: [
              Text(
                'Business Logo',
                style: GoogleFonts.outfit(
                  fontSize: AppSizes.fontSizeBodySmall.sp,
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSizes.spacingS.h),
              GestureDetector(
                onTap: controller.pickBusinessLogo,
                child: Obx(() {
                  final pickedPath = controller.pickedBusinessLogoPath.value;
                  final hasPicked = pickedPath.isNotEmpty;
                  final existingLogo = controller.existingBusinessLogo.value;
                  final hasExisting = existingLogo.isNotEmpty && existingLogo != 'null';

                  Widget displayWidget;
                  if (hasPicked) {
                    displayWidget = Image.file(
                      File(pickedPath),
                      fit: BoxFit.cover,
                    );
                  } else if (hasExisting) {
                    displayWidget = Image.network(
                      _resolveUrl(existingLogo),
                      fit: BoxFit.cover,
                    );
                  } else {
                    displayWidget = Icon(
                      Icons.storefront_outlined,
                      color: colors.primary,
                      size: 40.r,
                    );
                  }

                  return Container(
                    width: 90.r,
                    height: 90.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.card,
                      boxShadow: colors.neumorphicShadow(blur: 10, distance: 3),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.1),
                        width: 2,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Center(child: displayWidget),
                  );
                }),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSizes.spacingXL.h),

        // Business Banner
        Text(
          'Business Banner',
          style: GoogleFonts.outfit(
            fontSize: AppSizes.fontSizeBodySmall.sp,
            color: colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSizes.spacingS.h),
        GestureDetector(
          onTap: controller.pickBusinessBanner,
          child: Obx(() {
            final pickedPath = controller.pickedBusinessBannerPath.value;
            final hasPicked = pickedPath.isNotEmpty;
            final existingBanner = controller.existingBusinessBanner.value;
            final hasExisting = existingBanner.isNotEmpty && existingBanner != 'null';

            Widget displayWidget;
            if (hasPicked) {
              displayWidget = Image.file(
                File(pickedPath),
                fit: BoxFit.cover,
                width: double.infinity,
              );
            } else if (hasExisting) {
              displayWidget = Image.network(
                _resolveUrl(existingBanner),
                fit: BoxFit.cover,
                width: double.infinity,
              );
            } else {
              displayWidget = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined, color: colors.primary, size: 28.r),
                  SizedBox(height: 4.h),
                  Text(
                    'Upload Banner',
                    style: GoogleFonts.outfit(fontSize: 10.sp, color: colors.primary, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            }

            return Container(
              height: 110.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                boxShadow: colors.neumorphicShadow(blur: 10, distance: 3),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.1),
                  width: 1.5,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Center(child: displayWidget),
            );
          }),
        ),
        SizedBox(height: AppSizes.spacingXL.h),

        // Photos Gallery
        Text(
          'Business Gallery (Max 4)',
          style: GoogleFonts.outfit(
            fontSize: AppSizes.fontSizeBodySmall.sp,
            color: colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSizes.spacingS.h),
        SizedBox(
          height: 80.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Obx(() {
                final slot = controller.businessPhotosSlots[index];
                final hasImage = slot.hasImage;

                Widget imageWidget;
                if (slot.pickedPath != null && slot.pickedPath!.isNotEmpty) {
                  imageWidget = Image.file(
                    File(slot.pickedPath!),
                    fit: BoxFit.cover,
                    width: 70.w,
                    height: 70.w,
                  );
                } else if (slot.existingUrl != null && slot.existingUrl!.isNotEmpty) {
                  imageWidget = Image.network(
                    _resolveUrl(slot.existingUrl),
                    fit: BoxFit.cover,
                    width: 70.w,
                    height: 70.w,
                  );
                } else {
                  imageWidget = Icon(Icons.add_a_photo_outlined, color: colors.primary.withValues(alpha: 0.6), size: 24.r);
                }

                return Container(
                  margin: EdgeInsets.only(right: AppSizes.spacingM.w),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () => controller.pickBusinessPhoto(index),
                        child: Container(
                          width: 70.w,
                          height: 70.w,
                          decoration: BoxDecoration(
                            color: colors.card,
                            borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                            border: Border.all(color: colors.primary.withValues(alpha: 0.1), width: 1.5),
                            boxShadow: colors.neumorphicShadow(blur: 4, distance: 1),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                            child: Center(child: imageWidget),
                          ),
                        ),
                      ),
                      if (hasImage)
                        Positioned(
                          top: 2.r,
                          right: 2.r,
                          child: GestureDetector(
                            onTap: () => controller.removeBusinessPhoto(index),
                            child: Container(
                              padding: EdgeInsets.all(2.r),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close_rounded, color: Colors.white, size: 14),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              });
            },
          ),
        ),
        SizedBox(height: AppSizes.spacingXL.h),

        NeomorphicTextField(
          controller: controller.businessNameController,
          labelText: 'business_name'.tr,
          prefixIcon: Icon(Icons.storefront_outlined, color: colors.textPrimary),
          validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
        ),
        SizedBox(height: AppSizes.spacingL.h),

        Obx(() {
          final categories = AppEnums.jobCategories.keys.toList();
          final subCategories = controller.businessCategory.value.isEmpty
              ? <String>[]
              : AppEnums.jobCategories[controller.businessCategory.value] ?? <String>[];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NeomorphicDropdownField<String>(
                value: controller.businessCategory.value.isEmpty ? null : controller.businessCategory.value,
                labelText: 'category'.tr,
                prefixIcon: Icon(Icons.category_outlined, color: colors.textPrimary),
                items: categories.map((c) => NeomorphicDropdownItem(value: c, label: c)).toList(),
                onChanged: (val) {
                  if (val != null) {
                    controller.businessCategory.value = val;
                    controller.businessSubCategories.clear();
                  }
                },
              ),
              if (subCategories.isNotEmpty) ...[
                SizedBox(height: AppSizes.spacingL.h),
                Text(
                  'sub_category'.tr,
                  style: GoogleFonts.outfit(
                    fontSize: AppSizes.fontSizeBodySmall.sp,
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSizes.spacingS.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: subCategories.map((sub) {
                    final isSelected = controller.businessSubCategories.contains(sub);
                    return FilterChip(
                      selected: isSelected,
                      label: Text(
                        sub,
                        style: GoogleFonts.outfit(
                          color: isSelected ? colors.white : colors.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: AppSizes.fontSizeBodySmall.sp,
                        ),
                      ),
                      backgroundColor: colors.card,
                      selectedColor: colors.primary,
                      checkmarkColor: colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                        side: BorderSide(
                          color: isSelected ? colors.primary : colors.primary.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          controller.businessSubCategories.add(sub);
                        } else {
                          controller.businessSubCategories.remove(sub);
                        }
                      },
                    );
                  }).toList(),
                ),
              ],
              if (controller.businessSubCategories.contains('Other Jobs')) ...[
                SizedBox(height: AppSizes.spacingL.h),
                NeomorphicTextField(
                  controller: controller.businessSubCategoryOtherController,
                  labelText: 'other_category'.tr,
                  prefixIcon: Icon(Icons.class_outlined, color: colors.textPrimary),
                  validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                ),
              ],
            ],
          );
        }),
        SizedBox(height: AppSizes.spacingL.h),

        NeomorphicTextField(
          controller: controller.businessOwnerNameController,
          labelText: 'owner_name'.tr,
          prefixIcon: Icon(Icons.person_outline, color: colors.textPrimary),
        ),
        SizedBox(height: AppSizes.spacingL.h),

        NeomorphicTextField(
          controller: controller.businessDescriptionController,
          labelText: 'description'.tr,
          prefixIcon: Icon(Icons.description_outlined, color: colors.textPrimary),
          maxLines: 3,
        ),
        SizedBox(height: AppSizes.spacingL.h),

        NeomorphicTextField(
          controller: controller.businessAddressController,
          labelText: 'company_address'.tr,
          prefixIcon: Icon(Icons.location_on_outlined, color: colors.textPrimary),
          validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
        ),
        SizedBox(height: AppSizes.spacingL.h),

        Row(
          children: [
            Expanded(
              child: NeomorphicTextField(
                controller: controller.businessCityController,
                labelText: 'city'.tr,
                prefixIcon: Icon(Icons.location_city_outlined, color: colors.textPrimary),
              ),
            ),
            SizedBox(width: AppSizes.spacingM.w),
            Expanded(
              child: NeomorphicTextField(
                controller: controller.businessStateController,
                labelText: 'state'.tr,
                prefixIcon: Icon(Icons.map_outlined, color: colors.textPrimary),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.spacingL.h),

        Row(
          children: [
            Expanded(
              child: NeomorphicTextField(
                controller: controller.businessPincodeController,
                labelText: 'pincode'.tr,
                prefixIcon: Icon(Icons.pin_drop_outlined, color: colors.textPrimary),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: AppSizes.spacingM.w),
            Expanded(
              child: NeomorphicTextField(
                controller: controller.businessGoogleMapLinkController,
                labelText: 'map_link'.tr,
                prefixIcon: Icon(Icons.link, color: colors.textPrimary),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.spacingL.h),

        Row(
          children: [
            Expanded(
              child: NeomorphicTextField(
                controller: controller.businessMobile1Controller,
                labelText: 'mobile_1'.tr,
                prefixIcon: Icon(Icons.phone_outlined, color: colors.textPrimary),
                keyboardType: TextInputType.phone,
                validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
              ),
            ),
            SizedBox(width: AppSizes.spacingM.w),
            Expanded(
              child: NeomorphicTextField(
                controller: controller.businessMobile2Controller,
                labelText: 'mobile_2'.tr,
                prefixIcon: Icon(Icons.phone_outlined, color: colors.textPrimary),
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.spacingL.h),

        Row(
          children: [
            Expanded(
              child: NeomorphicTextField(
                controller: controller.businessEmailController,
                labelText: 'email'.tr,
                prefixIcon: Icon(Icons.email_outlined, color: colors.textPrimary),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(width: AppSizes.spacingM.w),
            Expanded(
              child: NeomorphicTextField(
                controller: controller.businessWebsiteController,
                labelText: 'website'.tr,
                prefixIcon: Icon(Icons.language, color: colors.textPrimary),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.spacingL.h),

        NeomorphicTextField(
          controller: controller.businessPortfolioLinkController,
          labelText: 'portfolio_website'.tr,
          prefixIcon: Icon(Icons.picture_in_picture_alt_outlined, color: colors.textPrimary),
        ),
      ],
    );
  }
}
