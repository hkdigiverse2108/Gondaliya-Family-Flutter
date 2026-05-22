// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/register_controller.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import '../../../data/models/enums.dart';
import '../../../global_widgets/neomorphic_dropdown_field.dart';
import '../../../global_widgets/neomorphic_text_field.dart';
import '../../../global_widgets/neomorphic_card.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class OccupationStep extends StatelessWidget {
  final RegisterController controller;

  const OccupationStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Form(
      key: controller.occupationFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'occupation_details'.tr,
            style: GoogleFonts.outfit(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'choose_occupation'.tr,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: 24.h),

          // Custom Segmented Control for Selection
          NeomorphicCard(
            borderRadius: 16.r,
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                _buildOccupationTab(
                  context,
                  'Business',
                  'business'.tr,
                  Icons.storefront_outlined,
                  colors,
                ),
                _buildOccupationTab(
                  context,
                  'Job',
                  'job'.tr,
                  Icons.work_outline,
                  colors,
                ),
                _buildOccupationTab(
                  context,
                  'None',
                  'none'.tr,
                  Icons.block,
                  colors,
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // Conditional Forms
          Obx(() {
            if (controller.occupationType.value == 'Business') {
              return _buildBusinessForm(colors);
            } else if (controller.occupationType.value == 'Job') {
              return _buildJobForm(colors);
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildOccupationTab(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    AppColorScheme colors,
  ) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.occupationType.value == value;
        return GestureDetector(
          onTap: () => controller.occupationType.value = value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: isSelected ? colors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: isSelected ? colors.white : colors.textSecondary,
                  size: 24.sp,
                ),
                SizedBox(height: 4.h),
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    color: isSelected ? colors.white : colors.textSecondary,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBusinessForm(AppColorScheme colors) {
    return Column(
      children: [
        NeomorphicTextField(
          controller: controller.businessNameController,
          labelText: 'business_name'.tr,
          prefixIcon: Icon(
            Icons.storefront_outlined,
            color: colors.textPrimary,
          ),
          validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
        ),
        SizedBox(height: 16.h),
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
                    controller.businessSubCategory.value =
                        ''; // reset sub category
                  }
                },
              ),
              SizedBox(height: 12.h),
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
                  if (val != null) controller.businessSubCategory.value = val;
                },
              ),
              if (controller.businessSubCategory.value == 'Other Jobs') ...[
                SizedBox(height: 12.h),
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
        SizedBox(height: 16.h),
        NeomorphicTextField(
          controller: controller.businessOwnerNameController,
          labelText: 'owner_name'.tr,
          prefixIcon: Icon(Icons.person_outline, color: colors.textPrimary),
        ),
        SizedBox(height: 16.h),
        NeomorphicTextField(
          controller: controller.businessDescriptionController,
          labelText: 'description'.tr,
          prefixIcon: Icon(
            Icons.description_outlined,
            color: colors.textPrimary,
          ),
          maxLines: 3,
        ),
        SizedBox(height: 16.h),
        NeomorphicTextField(
          controller: controller.businessAddressController,
          labelText: 'company_address'.tr,
          prefixIcon: Icon(
            Icons.location_on_outlined,
            color: colors.textPrimary,
          ),
          validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
        ),
        SizedBox(height: 16.h),
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
            SizedBox(width: 12.w),
            Expanded(
              child: NeomorphicTextField(
                controller: controller.businessStateController,
                labelText: 'state'.tr,
                prefixIcon: Icon(Icons.map_outlined, color: colors.textPrimary),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
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
            SizedBox(width: 12.w),
            Expanded(
              child: NeomorphicTextField(
                controller: controller.businessGoogleMapLinkController,
                labelText: 'map_link'.tr,
                prefixIcon: Icon(Icons.link, color: colors.textPrimary),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
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
            SizedBox(width: 12.w),
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
        SizedBox(height: 16.h),
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
            SizedBox(width: 12.w),
            Expanded(
              child: NeomorphicTextField(
                controller: controller.businessWebsiteController,
                labelText: 'website'.tr,
                prefixIcon: Icon(Icons.language, color: colors.textPrimary),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
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
        SizedBox(height: 16.h),
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
                controller.jobRole.value = ''; // reset role
              }
            },
          ),
        ),
        SizedBox(height: 16.h),
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
                  if (val != null) controller.jobRole.value = val;
                },
              ),
              SizedBox(height: 16.h),
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
                SizedBox(height: 16.h),
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
}
