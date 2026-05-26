import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gondalia_family/app/global_widgets/glass_app_bar.dart';
import 'package:gondalia_family/app/global_widgets/neomorphic_button.dart';
import 'package:gondalia_family/app/global_widgets/neomorphic_card.dart';
import 'package:gondalia_family/app/global_widgets/neomorphic_text_field.dart';
import 'package:gondalia_family/app/global_widgets/neomorphic_dropdown_field.dart';
import 'package:gondalia_family/app/global_widgets/neomorphic_async_dropdown_field.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/values/colors.dart';
import 'package:gondalia_family/core/values/sizes.dart';
import '../../../data/models/location_model.dart';
import '../../../data/models/enums.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    return SafeArea(
      top: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: GlassAppBar(titleText: 'edit_profile'.tr),
        body: Stack(
          children: [
            // Aurora gradients
            Positioned(
              top: -120.h,
              right: -100.w,
              child: Container(
                width: 300.w,
                height: 300.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colors.tealBridge.withValues(alpha: isDark ? 0.15 : 0.25),
                      colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Column(
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
                          NeomorphicCard(
                            padding: EdgeInsets.all(AppSizes.spacingL.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Personal Details Header
                                Text(
                                  'member_details'.tr,
                                  style: GoogleFonts.outfit(
                                    fontSize: AppSizes.fontSizeTitleMedium.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.secondaryLight
                                        : AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: AppSizes.spacingM.h),
                                
                                NeomorphicTextField(
                                  controller: controller.nameController,
                                  labelText: 'name'.tr,
                                  prefixIcon: Icon(
                                    Icons.person_outline_rounded,
                                    color: colors.textPrimary,
                                  ),
                                  validator: (val) => val == null || val.trim().isEmpty
                                      ? 'field_required'.tr
                                      : null,
                                ),
                                SizedBox(height: AppSizes.spacingM.h),
                                
                                NeomorphicTextField(
                                  controller: controller.fatherNameController,
                                  labelText: 'father_name'.tr,
                                  prefixIcon: Icon(
                                    Icons.person_outline_rounded,
                                    color: colors.textPrimary,
                                  ),
                                  validator: (val) => val == null || val.trim().isEmpty
                                      ? 'field_required'.tr
                                      : null,
                                ),
                                SizedBox(height: AppSizes.spacingM.h),
                                
                                NeomorphicTextField(
                                  controller: controller.surnameController,
                                  labelText: 'surname'.tr,
                                  prefixIcon: Icon(
                                    Icons.person_outline_rounded,
                                    color: colors.textPrimary,
                                  ),
                                  validator: (val) => val == null || val.trim().isEmpty
                                      ? 'field_required'.tr
                                      : null,
                                ),
                                SizedBox(height: AppSizes.spacingM.h),
                                
                                InkWell(
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                    );
                                    if (date != null) {
                                      controller.dobController.text =
                                          "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
                                    }
                                  },
                                  child: IgnorePointer(
                                    child: NeomorphicTextField(
                                      controller: controller.dobController,
                                      labelText: 'birth_date'.tr,
                                      prefixIcon: Icon(
                                        Icons.cake_outlined,
                                        color: colors.textPrimary,
                                      ),
                                      hintText: 'DD/MM/YYYY',
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSizes.spacingM.h),
                                
                                NeomorphicTextField(
                                  controller: controller.educationController,
                                  labelText: 'education'.tr,
                                  prefixIcon: Icon(
                                    Icons.school_outlined,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: AppSizes.spacingM.h),
                                
                                Obx(
                                  () => NeomorphicDropdownField<String>(
                                    value: controller.bloodGroup.value.isEmpty ? null : controller.bloodGroup.value,
                                    labelText: 'blood_group'.tr,
                                    prefixIcon: Icon(
                                      Icons.bloodtype_outlined,
                                      color: colors.textPrimary,
                                    ),
                                    items: AppEnums.bloodGroups
                                        .map(
                                          (bg) => NeomorphicDropdownItem(value: bg, label: bg),
                                        )
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null) controller.bloodGroup.value = val;
                                    },
                                  ),
                                ),
                                SizedBox(height: AppSizes.spacingM.h),
                                
                                Obx(
                                  () => NeomorphicDropdownField<String>(
                                    value: controller.isMarried.value.isEmpty ? null : controller.isMarried.value,
                                    labelText: 'marital_status'.tr,
                                    prefixIcon: Icon(
                                      Icons.favorite_border_rounded,
                                      color: colors.textPrimary,
                                    ),
                                    items: AppEnums.maritalStatus
                                        .map(
                                          (ms) => NeomorphicDropdownItem(
                                            value: ms,
                                            label: ms.tr.capitalizeFirst ?? ms,
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null) controller.isMarried.value = val;
                                    },
                                  ),
                                ),
                                SizedBox(height: AppSizes.spacingM.h),

                                NeomorphicTextField(
                                  controller: controller.phoneNumber2Controller,
                                  labelText: 'Alternate Mobile',
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  prefixIcon: Icon(
                                    Icons.phone_iphone_rounded,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: AppSizes.spacingXL.h),

                                // Current Residence Residence Header
                                Text(
                                  'current_residence'.tr,
                                  style: GoogleFonts.outfit(
                                    fontSize: AppSizes.fontSizeTitleMedium.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.secondaryLight
                                        : AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: AppSizes.spacingM.h),
                                
                                NeomorphicTextField(
                                  controller: controller.currentAddressController,
                                  labelText: 'current_address'.tr,
                                  maxLines: 2,
                                  prefixIcon: Icon(
                                    Icons.location_on_outlined,
                                    color: colors.textPrimary,
                                  ),
                                  validator: (val) => val == null || val.trim().isEmpty
                                      ? 'field_required'.tr
                                      : null,
                                ),
                                SizedBox(height: AppSizes.spacingM.h),
                                
                                Row(
                                  children: [
                                    Expanded(
                                      child: NeomorphicTextField(
                                        controller: controller.currentCityController,
                                        labelText: 'city'.tr,
                                        validator: (val) => val == null || val.trim().isEmpty
                                            ? 'field_required'.tr
                                            : null,
                                      ),
                                    ),
                                    SizedBox(width: AppSizes.spacingM.w),
                                    Expanded(
                                      child: NeomorphicTextField(
                                        controller: controller.currentStateController,
                                        labelText: 'state'.tr,
                                        validator: (val) => val == null || val.trim().isEmpty
                                            ? 'field_required'.tr
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSizes.spacingM.h),
                                
                                NeomorphicTextField(
                                  controller: controller.pincodeController,
                                  labelText: 'pincode'.tr,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(6),
                                  ],
                                  validator: (val) => val == null || val.trim().isEmpty
                                      ? 'field_required'.tr
                                      : null,
                                ),
                                SizedBox(height: AppSizes.spacingM.h),
                                
                                Obx(
                                  () => NeomorphicDropdownField<String>(
                                    value: controller.houseType.value.isEmpty ? null : controller.houseType.value,
                                    labelText: 'house_type'.tr,
                                    prefixIcon: Icon(
                                      Icons.home_outlined,
                                      color: colors.textPrimary,
                                    ),
                                    items: AppEnums.houseTypes
                                        .map(
                                          (ht) => NeomorphicDropdownItem(value: ht, label: ht.tr),
                                        )
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null) controller.houseType.value = val;
                                    },
                                  ),
                                ),
                                SizedBox(height: AppSizes.spacingXL.h),

                                // Native Place Header
                                Text(
                                  'native_place'.tr,
                                  style: GoogleFonts.outfit(
                                    fontSize: AppSizes.fontSizeTitleMedium.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.secondaryLight
                                        : AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: AppSizes.spacingM.h),
                                
                                Obx(
                                  () => NeomorphicAsyncDropdownField<LocationModel>(
                                    value: controller.selectedLocation.value,
                                    labelText: 'village'.tr,
                                    onSearch: controller.searchLocations,
                                    displayStringForValue: (loc) =>
                                        loc?.village ?? controller.villageController.text,
                                    validator: (val) =>
                                        controller.villageController.text.trim().isEmpty
                                            ? 'field_required'.tr
                                            : null,
                                    onChanged: (loc) {
                                      if (loc != null) {
                                        controller.selectedLocation.value = loc;
                                        controller.villageController.text = loc.village;
                                        controller.talukaController.text = loc.taluka;
                                        controller.districtController.text = loc.district;
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(height: AppSizes.spacingM.h),
                                
                                Row(
                                  children: [
                                    Expanded(
                                      child: NeomorphicTextField(
                                        controller: controller.talukaController,
                                        labelText: 'taluka'.tr,
                                        validator: (val) => val == null || val.trim().isEmpty
                                            ? 'field_required'.tr
                                            : null,
                                      ),
                                    ),
                                    SizedBox(width: AppSizes.spacingM.w),
                                    Expanded(
                                      child: NeomorphicTextField(
                                        controller: controller.districtController,
                                        labelText: 'district'.tr,
                                        validator: (val) => val == null || val.trim().isEmpty
                                            ? 'field_required'.tr
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSizes.spacingXL.h),

                                // Original Native Place Header
                                Text(
                                  'Original Native (if different)',
                                  style: GoogleFonts.outfit(
                                    fontSize: AppSizes.fontSizeTitleMedium.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.secondaryLight
                                        : AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: AppSizes.spacingM.h),
                                
                                NeomorphicTextField(
                                  controller: controller.nativeVillageController,
                                  labelText: 'Native Village',
                                ),
                                SizedBox(height: AppSizes.spacingM.h),
                                
                                Row(
                                  children: [
                                    Expanded(
                                      child: NeomorphicTextField(
                                        controller: controller.nativeTalukaController,
                                        labelText: 'Native Taluka',
                                      ),
                                    ),
                                    SizedBox(width: AppSizes.spacingM.w),
                                    Expanded(
                                      child: NeomorphicTextField(
                                        controller: controller.nativeDistrictController,
                                        labelText: 'Native District',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSizes.spacing3XL.h),
                          
                          Obx(
                            () => NeomorphicButton(
                              text: 'save'.tr.toUpperCase(),
                              isLoading: controller.isLoading.value,
                              onPressed: controller.saveProfile,
                              isGradient: true,
                              gradientColors: colors.primaryGradient,
                              gradientBegin: Alignment.centerLeft,
                              gradientEnd: Alignment.centerRight,
                            ),
                          ),
                          SizedBox(height: AppSizes.spacing3XL.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
