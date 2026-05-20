import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/values/colors.dart';
import '../../../../core/values/sizes.dart';
import '../../../global_widgets/neomorphic_text_field.dart';
import '../../../global_widgets/neomorphic_card.dart';
import '../controllers/register_controller.dart';

class ProfileStep extends StatelessWidget {
  final RegisterController controller;

  const ProfileStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.primaryLight,
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'field_required'.tr
                      : null,
                ),
                SizedBox(height: AppSizes.spacingM.h),
                NeomorphicTextField(
                  controller: controller.fatherNameController,
                  labelText: 'father_name'.tr,
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.primaryLight,
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'field_required'.tr
                      : null,
                ),
                SizedBox(height: AppSizes.spacingM.h),
                NeomorphicTextField(
                  controller: controller.surnameController,
                  labelText: 'surname'.tr,
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.primaryLight,
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'field_required'.tr
                      : null,
                ),
                SizedBox(height: AppSizes.spacingM.h),
                NeomorphicTextField(
                  controller: controller.currentAddressController,
                  labelText: 'current_address'.tr,
                  maxLines: 2,
                  prefixIcon: const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.primaryLight,
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'field_required'.tr
                      : null,
                ),
                SizedBox(height: AppSizes.spacingM.h),

                DropdownButtonFormField<String>(
                  initialValue: controller.houseType.value,
                  decoration: InputDecoration(
                    labelText: 'house_type'.tr,
                    prefixIcon: const Icon(
                      Icons.home_outlined,
                      color: AppColors.primaryLight,
                    ),
                  ),
                  dropdownColor: isDark
                      ? AppColors.cardDark
                      : AppColors.cardLight,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    color: isDark
                        ? AppColors.textDarkPrimary
                        : AppColors.textLightPrimary,
                  ),
                  items: [
                    DropdownMenuItem(value: 'Owned', child: Text('owned'.tr)),
                    DropdownMenuItem(value: 'Rented', child: Text('rented'.tr)),
                  ],
                  onChanged: (val) {
                    if (val != null) controller.houseType.value = val;
                  },
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
                Row(
                  children: [
                    Expanded(
                      child: NeomorphicTextField(
                        controller: controller.villageController,
                        labelText: 'village'.tr,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'field_required'.tr
                            : null,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: NeomorphicTextField(
                        controller: controller.pincodeController,
                        labelText: 'pincode'.tr,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'field_required'.tr
                            : null,
                      ),
                    ),
                  ],
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
