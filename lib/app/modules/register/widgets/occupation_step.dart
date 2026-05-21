// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/values/colors.dart';
import '../controllers/register_controller.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import '../../../data/models/enums.dart';
import '../../../global_widgets/neomorphic_dropdown_field.dart';
import '../../../global_widgets/neomorphic_text_field.dart';
import '../../../global_widgets/neomorphic_card.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
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
            'વ્યવસાયની વિગતો', // Occupation Details
            style: GoogleFonts.outfit(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'તમે શું કરો છો તે પસંદ કરો', // Choose what you do
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
                _buildOccupationTab(context, 'Business', 'વ્યવસાય', Icons.storefront_outlined, colors),
                _buildOccupationTab(context, 'Job', 'નોકરી', Icons.work_outline, colors),
                _buildOccupationTab(context, 'None', 'કોઈ નહિ', Icons.block, colors),
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

  Widget _buildOccupationTab(BuildContext context, String value, String label, IconData icon, AppColorScheme colors) {
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
                      )
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
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
          labelText: 'વ્યવસાયનું નામ (Business Name)',
          prefixIcon: Icon(Icons.storefront_outlined, color: colors.textPrimary),
          inputFormatters: [UpperCaseTextFormatter()],
          validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: NeomorphicTextField(
                controller: controller.businessCategoryController,
                labelText: 'શ્રેણી (Category)',
                prefixIcon: Icon(Icons.category_outlined, color: colors.textPrimary),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: NeomorphicTextField(
                controller: controller.businessSubCategoryController,
                labelText: 'પેટા શ્રેણી (Sub-Category)',
                prefixIcon: Icon(Icons.class_outlined, color: colors.textPrimary),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        NeomorphicTextField(
          controller: controller.businessOwnerNameController,
          labelText: 'માલિકનું નામ (Owner Name)',
          prefixIcon: Icon(Icons.person_outline, color: colors.textPrimary),
          inputFormatters: [UpperCaseTextFormatter()],
        ),
        SizedBox(height: 16.h),
        NeomorphicTextField(
          controller: controller.businessDescriptionController,
          labelText: 'વર્ણન (Description)',
          prefixIcon: Icon(Icons.description_outlined, color: colors.textPrimary),
          maxLines: 3,
        ),
        SizedBox(height: 16.h),
        NeomorphicTextField(
          controller: controller.businessAddressController,
          labelText: 'સરનામું (Shop Address)',
          prefixIcon: Icon(Icons.location_on_outlined, color: colors.textPrimary),
          inputFormatters: [UpperCaseTextFormatter()],
          validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: NeomorphicTextField(
                controller: controller.businessCityController,
                labelText: 'શહેર (City)',
                prefixIcon: Icon(Icons.location_city_outlined, color: colors.textPrimary),
                inputFormatters: [UpperCaseTextFormatter()],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: NeomorphicTextField(
                controller: controller.businessStateController,
                labelText: 'રાજ્ય (State)',
                prefixIcon: Icon(Icons.map_outlined, color: colors.textPrimary),
                inputFormatters: [UpperCaseTextFormatter()],
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
                labelText: 'પીનકોડ (Pincode)',
                prefixIcon: Icon(Icons.pin_drop_outlined, color: colors.textPrimary),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: NeomorphicTextField(
                controller: controller.businessGoogleMapLinkController,
                labelText: 'મેપ લિંક (Map Link)',
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
                labelText: 'મોબાઈલ 1 (Mobile 1)',
                prefixIcon: Icon(Icons.phone_outlined, color: colors.textPrimary),
                keyboardType: TextInputType.phone,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: NeomorphicTextField(
                controller: controller.businessMobile2Controller,
                labelText: 'મોબાઈલ 2 (Mobile 2)',
                prefixIcon: Icon(Icons.phone_outlined, color: colors.textPrimary),
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
                labelText: 'ઈમેલ (Email)',
                prefixIcon: Icon(Icons.email_outlined, color: colors.textPrimary),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: NeomorphicTextField(
                controller: controller.businessWebsiteController,
                labelText: 'વેબસાઇટ (Website)',
                prefixIcon: Icon(Icons.language, color: colors.textPrimary),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        NeomorphicTextField(
          controller: controller.businessPortfolioLinkController,
          labelText: 'પોર્ટફોલિયો લિંક (Portfolio Link)',
          prefixIcon: Icon(Icons.picture_in_picture_alt_outlined, color: colors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildJobForm(AppColorScheme colors) {
    return Column(
      children: [
        NeomorphicTextField(
          controller: controller.companyNameController,
          labelText: 'કંપનીનું નામ (Company Name)',
          prefixIcon: Icon(Icons.business_outlined, color: colors.textPrimary),
          inputFormatters: [UpperCaseTextFormatter()],
          validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
        ),
        SizedBox(height: 16.h),
        Obx(() => NeomorphicDropdownField<String>(
          value: controller.jobCategory.value.isEmpty ? null : controller.jobCategory.value,
          labelText: 'નોકરીની શ્રેણી (Job Category)',
          prefixIcon: Icon(Icons.category_outlined, color: colors.textPrimary),
          items: AppEnums.jobCategories.keys.map((c) => NeomorphicDropdownItem(value: c, label: c)).toList(),
          onChanged: (val) {
            if (val != null) {
              controller.jobCategory.value = val;
              controller.jobRole.value = ''; // reset role
            }
          },
        )),
        SizedBox(height: 16.h),
        Obx(() {
          if (controller.jobCategory.value.isEmpty) {
            return const SizedBox.shrink();
          }
          final roles = AppEnums.jobCategories[controller.jobCategory.value] ?? [];
          return Column(
            children: [
              NeomorphicDropdownField<String>(
                value: controller.jobRole.value.isEmpty ? null : controller.jobRole.value,
                labelText: 'નોકરીનો હોદ્દો (Job Role)',
                prefixIcon: Icon(Icons.work_outline, color: colors.textPrimary),
                items: roles.map((r) => NeomorphicDropdownItem(value: r, label: r)).toList(),
                onChanged: (val) {
                  if (val != null) controller.jobRole.value = val;
                },
              ),
              SizedBox(height: 16.h),
            ],
          );
        }),
        NeomorphicTextField(
          controller: controller.companyAddressController,
          labelText: 'કંપનીનું સરનામું (Company Address)',
          prefixIcon: Icon(Icons.location_city_outlined, color: colors.textPrimary),
          inputFormatters: [UpperCaseTextFormatter()],
          validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
        ),
      ],
    );
  }
}
