import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import 'package:gondalia_family/app/global_widgets/glass_app_bar.dart';
import 'package:gondalia_family/app/global_widgets/neomorphic_card.dart';
import 'package:gondalia_family/app/global_widgets/neomorphic_button.dart';
import 'package:gondalia_family/app/global_widgets/neomorphic_text_field.dart';
import 'package:gondalia_family/app/global_widgets/neomorphic_dropdown_field.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/values/sizes.dart';
import 'package:gondalia_family/app/data/models/enums.dart';
import '../controllers/edit_work_controller.dart';

class EditWorkView extends GetView<EditWorkController> {
  const EditWorkView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    return SafeArea(
      top: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: GlassAppBar(
          titleText: 'occupation_details'.tr.isEmpty
              ? 'Work Profile'
              : 'occupation_details'.tr,
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
                    height:
                        kToolbarHeight +
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
                            Text(
                              'choose_occupation'.tr,
                              style: GoogleFonts.outfit(
                                fontSize: AppSizes.fontSizeBodyMedium.sp,
                                color: colors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: AppSizes.spacingXL.h),

                            // Segmented selection
                            NeomorphicCard(
                              borderRadius: AppSizes.radiusL.r,
                              padding: EdgeInsets.all(AppSizes.spacingXS.w),
                              child: Row(
                                children: [
                                  _buildOccupationTab(
                                    context,
                                    'Business',
                                    'business'.tr,
                                    colors,
                                  ),
                                  _buildOccupationTab(
                                    context,
                                    'Job',
                                    'job'.tr,
                                    colors,
                                  ),
                                  _buildOccupationTab(
                                    context,
                                    'None',
                                    'none'.tr,
                                    colors,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: AppSizes.spacingXXL.h),

                            // Display forms
                            Obx(() {
                              if (controller.occupationType.value ==
                                  'Business') {
                                return _buildBusinessForm(colors);
                              } else if (controller.occupationType.value ==
                                  'Job') {
                                return _buildJobForm(colors);
                              }
                              return _buildNoneForm(colors);
                            }),

                            SizedBox(height: AppSizes.spacingXXL.h),
                            NeomorphicButton(
                              text: 'save'.tr,
                              isGradient: true,
                              width: double.infinity,
                              onPressed: controller.saveWorkDetails,
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

  Widget _buildOccupationTab(
    BuildContext context,
    String value,
    String label,
    AppColorScheme colors,
  ) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.occupationType.value == value;
        return GestureDetector(
          onTap: () => controller.occupationType.value = value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(vertical: AppSizes.spacingM.h),
            decoration: BoxDecoration(
              color: isSelected ? colors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
            ),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.outfit(
                  color: isSelected ? colors.white : colors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: AppSizes.fontSizeBodySmall.sp,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBusinessForm(AppColorScheme colors) {
    return Column(
      children: [
        // Business Logo / Document Picker
        Center(
          child: Column(
            children: [
              Text(
                'Business Logo / Document',
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
                    if (pickedPath.toLowerCase().endsWith('.pdf')) {
                      displayWidget = Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent, size: 40.r),
                          SizedBox(height: 4.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Text(
                              pickedPath.split('/').last,
                              style: GoogleFonts.outfit(
                                fontSize: 10.sp,
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    } else {
                      displayWidget = ClipRRect(
                        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                        child: Image.file(
                          File(pickedPath),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      );
                    }
                  } else if (hasExisting) {
                    if (existingLogo.toLowerCase().endsWith('.pdf')) {
                      displayWidget = Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent, size: 40.r),
                          SizedBox(height: 4.h),
                          Text(
                            'View PDF Document',
                            style: GoogleFonts.outfit(
                              fontSize: 10.sp,
                              color: colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      );
                    } else {
                      displayWidget = ClipRRect(
                        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                        child: Image.network(
                          existingLogo,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.broken_image_outlined,
                            color: colors.textSecondary,
                            size: 32.r,
                          ),
                        ),
                      );
                    }
                  } else {
                    displayWidget = Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          color: colors.primary,
                          size: 36.r,
                        ),
                        SizedBox(height: AppSizes.spacingXS.h),
                        Text(
                          'Upload Image or PDF',
                          style: GoogleFonts.outfit(
                            fontSize: AppSizes.fontSizeCaption.sp,
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }

                  return Container(
                    width: 140.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                      boxShadow: colors.neumorphicShadow(blur: 8, distance: 2),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.1),
                        width: 2,
                      ),
                    ),
                    child: Center(child: displayWidget),
                  );
                }),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSizes.spacingXL.h),

        NeomorphicTextField(
          controller: controller.businessNameController,
          labelText: 'business_name'.tr,
          prefixIcon: Icon(
            Icons.storefront_outlined,
            color: colors.textPrimary,
          ),
          validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
        ),
        SizedBox(height: AppSizes.spacingL.h),
        Obx(() {
          final categories = AppEnums.jobCategories.keys.toList();
          final subCategories = controller.businessCategory.value.isEmpty
              ? <String>[]
              : AppEnums.jobCategories[controller.businessCategory.value] ??
                    <String>[];

          return Column(
            children: [
              NeomorphicDropdownField<String>(
                value: controller.businessCategory.value.isEmpty
                    ? null
                    : controller.businessCategory.value,
                labelText: 'category'.tr,
                prefixIcon: Icon(
                  Icons.category_outlined,
                  color: colors.textPrimary,
                ),
                items: categories
                    .map((c) => NeomorphicDropdownItem(value: c, label: c))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    controller.businessCategory.value = val;
                    controller.businessSubCategory.value = '';
                  }
                },
              ),
              SizedBox(height: AppSizes.spacingL.h),
              NeomorphicDropdownField<String>(
                value: controller.businessSubCategory.value.isEmpty
                    ? null
                    : controller.businessSubCategory.value,
                labelText: 'sub_category'.tr,
                prefixIcon: Icon(
                  Icons.class_outlined,
                  color: colors.textPrimary,
                ),
                items: subCategories
                    .map((c) => NeomorphicDropdownItem(value: c, label: c))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    controller.businessSubCategory.value = val;
                  }
                },
              ),
              if (controller.businessSubCategory.value == 'Other Jobs') ...[
                SizedBox(height: AppSizes.spacingL.h),
                NeomorphicTextField(
                  controller: controller.businessSubCategoryOtherController,
                  labelText: 'other_category'.tr,
                  prefixIcon: Icon(
                    Icons.class_outlined,
                    color: colors.textPrimary,
                  ),
                  validator: (val) =>
                      (val == null || val.isEmpty) ? 'Required' : null,
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
          prefixIcon: Icon(
            Icons.description_outlined,
            color: colors.textPrimary,
          ),
          maxLines: 3,
        ),
        SizedBox(height: AppSizes.spacingL.h),
        NeomorphicTextField(
          controller: controller.businessAddressController,
          labelText: 'company_address'.tr,
          prefixIcon: Icon(
            Icons.location_on_outlined,
            color: colors.textPrimary,
          ),
          validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
        ),
        SizedBox(height: AppSizes.spacingL.h),
        Row(
          children: [
            Expanded(
              child: NeomorphicTextField(
                controller: controller.businessCityController,
                labelText: 'city'.tr,
                prefixIcon: Icon(
                  Icons.location_city_outlined,
                  color: colors.textPrimary,
                ),
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
                prefixIcon: Icon(
                  Icons.pin_drop_outlined,
                  color: colors.textPrimary,
                ),
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
                prefixIcon: Icon(
                  Icons.phone_outlined,
                  color: colors.textPrimary,
                ),
                keyboardType: TextInputType.phone,
                validator: (val) =>
                    (val == null || val.isEmpty) ? 'Required' : null,
              ),
            ),
            SizedBox(width: AppSizes.spacingM.w),
            Expanded(
              child: NeomorphicTextField(
                controller: controller.businessMobile2Controller,
                labelText: 'mobile_2'.tr,
                prefixIcon: Icon(
                  Icons.phone_outlined,
                  color: colors.textPrimary,
                ),
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
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: colors.textPrimary,
                ),
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
          prefixIcon: Icon(
            Icons.picture_in_picture_alt_outlined,
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildJobForm(AppColorScheme colors) {
    return Column(
      children: [
        NeomorphicTextField(
          controller: controller.companyNameController,
          labelText: 'company_name'.tr,
          prefixIcon: Icon(Icons.business_outlined, color: colors.textPrimary),
          validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
        ),
        SizedBox(height: AppSizes.spacingL.h),
        Obx(
          () => NeomorphicDropdownField<String>(
            value: controller.jobCategory.value.isEmpty
                ? null
                : controller.jobCategory.value,
            labelText: 'category'.tr,
            prefixIcon: Icon(
              Icons.category_outlined,
              color: colors.textPrimary,
            ),
            items: AppEnums.jobCategories.keys
                .map((c) => NeomorphicDropdownItem(value: c, label: c))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                controller.jobCategory.value = val;
                controller.jobRole.value = '';
              }
            },
          ),
        ),
        SizedBox(height: AppSizes.spacingL.h),
        Obx(() {
          if (controller.jobCategory.value.isEmpty) {
            return const SizedBox.shrink();
          }
          final roles =
              AppEnums.jobCategories[controller.jobCategory.value] ?? [];
          return Column(
            children: [
              NeomorphicDropdownField<String>(
                value: controller.jobRole.value.isEmpty
                    ? null
                    : controller.jobRole.value,
                labelText: 'job_role'.tr,
                prefixIcon: Icon(Icons.work_outline, color: colors.textPrimary),
                items: roles
                    .map((r) => NeomorphicDropdownItem(value: r, label: r))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    controller.jobRole.value = val;
                  }
                },
              ),
              SizedBox(height: AppSizes.spacingL.h),
              if (controller.jobRole.value == 'Other Jobs') ...[
                NeomorphicTextField(
                  controller: controller.jobRoleOtherController,
                  labelText: 'other_role'.tr,
                  prefixIcon: Icon(
                    Icons.work_outline,
                    color: colors.textPrimary,
                  ),
                  validator: (val) =>
                      (val == null || val.isEmpty) ? 'Required' : null,
                ),
                SizedBox(height: AppSizes.spacingL.h),
              ],
            ],
          );
        }),
        NeomorphicTextField(
          controller: controller.companyAddressController,
          labelText: 'company_address'.tr,
          prefixIcon: Icon(
            Icons.location_city_outlined,
            color: colors.textPrimary,
          ),
          validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildNoneForm(AppColorScheme colors) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.spacingXL.h,
        horizontal: AppSizes.spacingL.w,
      ),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        border: Border.all(color: colors.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Icon(Icons.info_outline_rounded, color: colors.primary, size: 36.r),
          SizedBox(height: AppSizes.spacingM.h),
          Text(
            'No Work Details Set',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: AppSizes.fontSizeBodyLarge.sp,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.spacingS.h),
          Text(
            'Please select Business or Job above to enter your professional details.',
            style: GoogleFonts.outfit(
              fontSize: AppSizes.fontSizeBodySmall.sp,
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
