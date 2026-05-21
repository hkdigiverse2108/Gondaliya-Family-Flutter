import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gondalia_family/app/data/models/location_model.dart';
import 'package:gondalia_family/app/data/models/enums.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/values/colors.dart';
import '../../../../core/values/sizes.dart';
import '../../../global_widgets/neomorphic_dropdown_field.dart';
import '../../../global_widgets/neomorphic_async_dropdown_field.dart';
import '../../../global_widgets/neomorphic_text_field.dart';
import '../../../global_widgets/neomorphic_card.dart';
import '../controllers/register_controller.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';

class ProfileStep extends StatelessWidget {
  final RegisterController controller;

  const ProfileStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NeomorphicCard(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: controller.profileFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                      initialDate: DateTime.now(),
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
                    value: controller.bloodGroup.value,
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
                SizedBox(height: 12.w),
                Obx(
                  () => NeomorphicDropdownField<String>(
                    value: controller.isMarried.value,
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
                SizedBox(height: AppSizes.spacingXL.h),

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
                    SizedBox(width: 12.w),
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
                Obx(
                  () => NeomorphicDropdownField<String>(
                    value: controller.houseType.value,
                    labelText: 'house_type'.tr,
                    prefixIcon: Icon(
                      Icons.home_outlined,
                      color: colors.textPrimary,
                    ),
                    items: AppEnums.houseTypes
                        .map(
                          (ht) =>
                              NeomorphicDropdownItem(value: ht, label: ht.tr),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) controller.houseType.value = val;
                    },
                  ),
                ),
                SizedBox(height: AppSizes.spacingXL.h),

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
                        controller.pincodeController.text = loc.pincode;

                        // Default native logic
                        controller.nativeVillageController.text = loc.village;
                        controller.nativeTalukaController.text = loc.taluka;
                        controller.nativeDistrictController.text = loc.district;
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
                    SizedBox(width: 12.w),
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
                SizedBox(height: AppSizes.spacingM.h),
                NeomorphicTextField(
                  controller: controller.pincodeController,
                  labelText: 'pincode'.tr,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'field_required'.tr
                      : null,
                ),

                SizedBox(height: AppSizes.spacingXL.h),
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
                    SizedBox(width: 12.w),
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
        ),
      ],
    );
  }
}
