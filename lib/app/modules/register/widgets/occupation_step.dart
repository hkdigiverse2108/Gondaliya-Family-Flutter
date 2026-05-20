// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/values/colors.dart';
import '../controllers/register_controller.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
              color: isDark ? AppColors.white : AppColors.textLightPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'તમે શું કરો છો તે પસંદ કરો', // Choose what you do
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 24.h),

          // Radio Buttons for Selection
          Obx(() => Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: Text('વ્યવસાય', style: GoogleFonts.outfit()),
                  value: 'Business',
                  groupValue: controller.occupationType.value,
                  onChanged: (val) => controller.occupationType.value = val!,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.primary,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: Text('નોકરી', style: GoogleFonts.outfit()),
                  value: 'Job',
                  groupValue: controller.occupationType.value,
                  onChanged: (val) => controller.occupationType.value = val!,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.primary,
                ),
              ),
            ],
          )),
          Obx(() => RadioListTile<String>(
            title: Text('કોઈ નહિ', style: GoogleFonts.outfit()),
            value: 'None',
            groupValue: controller.occupationType.value,
            onChanged: (val) => controller.occupationType.value = val!,
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.primary,
          )),

          SizedBox(height: 16.h),

          // Conditional Forms
          Obx(() {
            if (controller.occupationType.value == 'Business') {
              return Column(
                children: [
                  _buildTextField(
                    controller: controller.businessNameController,
                    label: 'વ્યવસાયનું નામ',
                    icon: Icons.storefront_outlined,
                    isDark: isDark,
                  ),
                  SizedBox(height: 16.h),
                  _buildTextField(
                    controller: controller.businessCategoryController,
                    label: 'વ્યવસાયની શ્રેણી',
                    icon: Icons.category_outlined,
                    isDark: isDark,
                  ),
                  SizedBox(height: 16.h),
                  _buildTextField(
                    controller: controller.businessAddressController,
                    label: 'વ્યવસાયનું સરનામું',
                    icon: Icons.location_on_outlined,
                    isDark: isDark,
                  ),
                ],
              );
            } else if (controller.occupationType.value == 'Job') {
              return Column(
                children: [
                  _buildTextField(
                    controller: controller.companyNameController,
                    label: 'કંપનીનું નામ',
                    icon: Icons.business_outlined,
                    isDark: isDark,
                  ),
                  SizedBox(height: 16.h),
                  _buildTextField(
                    controller: controller.jobRoleController,
                    label: 'નોકરીનો હોદ્દો',
                    icon: Icons.work_outline,
                    isDark: isDark,
                  ),
                  SizedBox(height: 16.h),
                  _buildTextField(
                    controller: controller.companyAddressController,
                    label: 'કંપનીનું સરનામું',
                    icon: Icons.location_city_outlined,
                    isDark: isDark,
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
  }) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.characters,
      inputFormatters: [UpperCaseTextFormatter()],
      style: GoogleFonts.outfit(
        color: isDark ? AppColors.white : AppColors.textLightPrimary,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'કૃપા કરીને $label દાખલ કરો'; // Please enter $label
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.outfit(
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
        prefixIcon: Icon(
          icon,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
        filled: true,
        fillColor: isDark ? AppColors.cardDark : Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
      ),
    );
  }
}
