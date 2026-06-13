import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/values/sizes.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../global_widgets/custom_text_field.dart';
import '../../../global_widgets/glass_app_bar.dart';
import '../controllers/listing_form_controller.dart';
import '../../../../core/utils/time_utils.dart';

class ListingFormView extends GetView<ListingFormController> {
  const ListingFormView({super.key});

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
          child: Obx(
            () => GlassAppBar(
              titleText: controller.isEditMode.value
                  ? 'Edit Listing'
                  : 'Add Listing',
            ),
          ),
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
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppSizes.spacingL.w,
                kToolbarHeight +
                    MediaQuery.of(context).padding.top +
                    AppSizes.spacingL.h,
                AppSizes.spacingL.w,
                AppSizes.spacingXXL.h,
              ),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionTitle('Basic Information', colors),
                    SizedBox(height: AppSizes.spacingM.h),

                    _buildDropdown(
                      label: 'Type',
                      valueRx: controller.type,
                      options: controller.typeOptions,
                      onChanged: (v) => controller.type.value = v!,
                      colors: colors,
                      isDark: isDark,
                    ),
                    SizedBox(height: AppSizes.spacingM.h),

                    CustomTextField(
                      labelText: 'Title',
                      hintText: 'e.g. 2 BHK Flat for Sale',
                      controller: controller.titleController,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Title is required' : null,
                    ),
                    SizedBox(height: AppSizes.spacingM.h),

                    CustomTextField(
                      labelText: 'Description',
                      hintText: 'Provide details about the listing',
                      controller: controller.descriptionController,
                      maxLines: 4,
                      validator: (v) => v == null || v.isEmpty
                          ? 'Description is required'
                          : null,
                    ),
                    SizedBox(height: AppSizes.spacingL.h),

                    _buildSectionTitle('Pricing & Availability', colors),
                    SizedBox(height: AppSizes.spacingM.h),

                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CustomTextField(
                            labelText: 'Price (₹)',
                            hintText: '0',
                            controller: controller.priceController,
                            keyboardType: TextInputType.number,
                            validator: (v) => v == null || v.isEmpty
                                ? 'Price required'
                                : null,
                          ),
                        ),
                        SizedBox(width: AppSizes.spacingM.w),
                        Expanded(
                          flex: 1,
                          child: _buildDropdown(
                            label: 'Unit',
                            valueRx: controller.priceUnit,
                            options: [
                              'FIXED',
                              'PER_MONTH',
                              'PER_SQFT',
                              'PER_YEAR',
                            ],
                            onChanged: (v) => controller.priceUnit.value = v!,
                            colors: colors,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.spacingM.h),

                    Row(
                      children: [
                        Expanded(
                          child: _buildDateSelector(
                            label: 'Available From',
                            dateRx: controller.availableFrom,
                            onTap: () =>
                                controller.pickDate(context, isFromDate: true),
                            colors: colors,
                          ),
                        ),
                        SizedBox(width: AppSizes.spacingM.w),
                        Expanded(
                          child: _buildDateSelector(
                            label: 'Available To (Optional)',
                            dateRx: controller.availableTo,
                            onTap: () =>
                                controller.pickDate(context, isFromDate: false),
                            colors: colors,
                            canClear: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.spacingL.h),

                    _buildSectionTitle('Location & Contact', colors),
                    SizedBox(height: AppSizes.spacingM.h),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            labelText: 'City',
                            hintText: 'e.g. Surat',
                            controller: controller.cityController,
                            validator: (v) =>
                                v == null || v.isEmpty ? 'City required' : null,
                          ),
                        ),
                        SizedBox(width: AppSizes.spacingM.w),
                        Expanded(
                          child: CustomTextField(
                            labelText: 'Pincode',
                            hintText: 'e.g. 395004',
                            controller: controller.pincodeController,
                            keyboardType: TextInputType.number,
                            validator: (v) => v == null || v.isEmpty
                                ? 'Pincode required'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.spacingM.h),

                    CustomTextField(
                      labelText: 'Contact Phone',
                      hintText: 'e.g. +91 9876543210',
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Phone required' : null,
                    ),
                    SizedBox(height: AppSizes.spacingL.h),

                    Obx(() {
                      if (controller.isEditMode.value) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildSectionTitle('Status', colors),
                            SizedBox(height: AppSizes.spacingM.h),
                            _buildDropdown(
                              label: 'Listing Status',
                              valueRx: controller.status,
                              options: controller.statusOptions,
                              onChanged: (v) => controller.status.value = v!,
                              colors: colors,
                              isDark: isDark,
                            ),
                            SizedBox(height: AppSizes.spacingL.h),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    _buildSectionTitle('Photos', colors),
                    SizedBox(height: AppSizes.spacingS.h),
                    Text(
                      'Add photos of the property, item or service',
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        color: colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingM.h),

                    _buildPhotoGallery(colors, isDark),
                    SizedBox(height: AppSizes.spacingXXL.h),

                    Obx(
                      () => CustomButton(
                        text: controller.isEditMode.value
                            ? 'Save Changes'
                            : 'Create Listing',
                        isLoading: controller.isLoading.value,
                        onPressed: controller.saveListing,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, AppColorScheme colors) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: colors.primary,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required RxString valueRx,
    required List<String> options,
    required Function(String?) onChanged,
    required AppColorScheme colors,
    required bool isDark,
  }) {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: valueRx.value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.outfit(color: colors.textSecondary),
          filled: true,
          fillColor: isDark ? colors.card : colors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
            borderSide: BorderSide(
              color: isDark ? colors.divider : Colors.grey.shade300,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
            borderSide: BorderSide(
              color: isDark ? colors.divider : Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
            borderSide: BorderSide(color: colors.primary, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSizes.spacingM.w,
            vertical: AppSizes.spacingM.h,
          ),
        ),
        dropdownColor: colors.card,
        items: options.map((String val) {
          return DropdownMenuItem<String>(
            value: val,
            child: Text(
              val,
              style: GoogleFonts.outfit(
                color: colors.textPrimary,
                fontSize: 15.sp,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDateSelector({
    required String label,
    required Rx<DateTime?> dateRx,
    required VoidCallback onTap,
    required AppColorScheme colors,
    bool canClear = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12.sp,
            color: colors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.spacingM.w,
              vertical: AppSizes.spacingM.h,
            ),
            decoration: BoxDecoration(
              color: colors.isDark ? colors.card : colors.background,
              borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
              border: Border.all(
                color: colors.isDark ? colors.divider : Colors.grey.shade300,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Obx(() {
                    final date = dateRx.value;
                    return Text(
                      date != null
                          ? '${date.day} ${TimeUtils.getMonthName(date.month)} ${date.year}'
                          : 'Select Date',
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        color: date != null
                            ? colors.textPrimary
                            : colors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
                ),
                if (canClear)
                  Obx(() {
                    return dateRx.value != null
                        ? GestureDetector(
                            onTap: () => dateRx.value = null,
                            child: Icon(
                              Icons.close,
                              size: 20.sp,
                              color: colors.textSecondary,
                            ),
                          )
                        : Icon(
                            Icons.calendar_today_outlined,
                            size: 20.sp,
                            color: colors.primary,
                          );
                  })
                else
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 20.sp,
                    color: colors.primary,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoGallery(AppColorScheme colors, bool isDark) {
    return Obx(() {
      final existingCount = controller.existingPhotos.length;
      final newCount = controller.newPhotoPaths.length;
      final totalCount = existingCount + newCount;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (totalCount > 0)
            SizedBox(
              height: 100.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: totalCount + 1, // +1 for the add button
                separatorBuilder: (context, index) =>
                    SizedBox(width: AppSizes.spacingM.w),
                itemBuilder: (context, index) {
                  if (index == totalCount) {
                    return _buildAddPhotoButton(colors, isDark);
                  }

                  if (index < existingCount) {
                    final url = controller.existingPhotos[index];
                    return _buildPhotoItem(
                      imageProvider: NetworkImage(url),
                      onRemove: () => controller.removeExistingPhoto(index),
                      colors: colors,
                      isDark: isDark,
                    );
                  } else {
                    final pathIndex = index - existingCount;
                    final path = controller.newPhotoPaths[pathIndex];
                    return _buildPhotoItem(
                      imageProvider: FileImage(File(path)),
                      onRemove: () => controller.removeNewPhoto(pathIndex),
                      colors: colors,
                      isDark: isDark,
                    );
                  }
                },
              ),
            )
          else
            _buildAddPhotoPlaceholder(colors, isDark),
        ],
      );
    });
  }

  Widget _buildAddPhotoButton(AppColorScheme colors, bool isDark) {
    return GestureDetector(
      onTap: controller.pickPhotos,
      child: Container(
        width: 100.h,
        height: 100.h,
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          border: Border.all(
            color: colors.primary.withValues(alpha: 0.3),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: colors.primary,
              size: 32.sp,
            ),
            SizedBox(height: 4.h),
            Text(
              'Add More',
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                color: colors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPhotoPlaceholder(AppColorScheme colors, bool isDark) {
    return GestureDetector(
      onTap: controller.pickPhotos,
      child: Container(
        height: 120.h,
        decoration: BoxDecoration(
          color: isDark ? colors.card : colors.background,
          borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
          border: Border.all(
            color: isDark ? colors.divider : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: colors.textSecondary,
              size: 40.sp,
            ),
            SizedBox(height: AppSizes.spacingS.h),
            Text(
              'Tap to add photos',
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoItem({
    required ImageProvider imageProvider,
    required VoidCallback onRemove,
    required AppColorScheme colors,
    required bool isDark,
  }) {
    return Stack(
      children: [
        Container(
          width: 100.h,
          height: 100.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
            border: Border.all(
              color: isDark ? colors.divider : Colors.grey.shade300,
            ),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 4.h,
          right: 4.w,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 14.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
