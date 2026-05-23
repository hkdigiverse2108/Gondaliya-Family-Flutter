import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/values/colors.dart';
import '../../../global_widgets/neomorphic_text_field.dart';
import '../../../global_widgets/neomorphic_button.dart';
import '../controllers/register_controller.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import '../../../data/models/enums.dart';
import '../../../global_widgets/neomorphic_dropdown_field.dart';
import 'package:gondalia_family/core/values/sizes.dart';

void showAddFamilySheet(BuildContext context, RegisterController controller) {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final middleNameCtrl = TextEditingController();
  final surnameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final birthDateCtrl = TextEditingController();
  final eduCtrl = TextEditingController();
  var relationVal = AppEnums.relations.first.obs;
  var bloodVal = AppEnums.bloodGroups.first.obs;
  var isMarriedVal = AppEnums.maritalStatus.first.obs;
  final colors = context.appColors;
  final isDark = colors.isDark;

  Get.bottomSheet(
    SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          left: AppSizes.spacingL.w,
          right: AppSizes.spacingL.w,
          top: AppSizes.spacingXL.h,
          bottom:
              MediaQuery.of(context).viewInsets.bottom + AppSizes.spacingXL.h,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'add_family_member_to_table'.tr,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color: isDark
                        ? AppColors.secondaryLight
                        : AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSizes.spacingS.h),
                const Divider(),
                SizedBox(height: AppSizes.spacingM.h),
                NeomorphicTextField(
                  controller: nameCtrl,
                  labelText: 'first_name'.tr,
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
                  controller: middleNameCtrl,
                  labelText: 'middle_name'.tr,
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.spacingM.h),
                NeomorphicTextField(
                  controller: surnameCtrl,
                  labelText: 'last_name'.tr,
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
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
                      child: Obx(
                        () => NeomorphicDropdownField<String>(
                          value: relationVal.value,
                          labelText: 'relationship'.tr,
                          prefixIcon: Icon(
                            Icons.family_restroom_rounded,
                            color: colors.textPrimary,
                          ),
                          items: AppEnums.relations
                              .map(
                                (r) => NeomorphicDropdownItem(
                                  value: r,
                                  label: r.tr,
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) relationVal.value = val;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.spacingM.h),
                NeomorphicTextField(
                  controller: phoneCtrl,
                  labelText: 'phone_number'.tr,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icon(
                    Icons.phone_iphone_outlined,
                    color: colors.textPrimary,
                  ),
                  validator: (val) {
                    if (val != null && val.isNotEmpty && val.length != 10) {
                      return 'invalid_phone'.tr;
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSizes.spacingM.h),
                Obx(
                  () => NeomorphicDropdownField<String>(
                    value: isMarriedVal.value,
                    labelText: 'marital_status'.tr,
                    prefixIcon: Icon(
                      Icons.favorite_border_rounded,
                      color: colors.textPrimary,
                    ),
                    items: AppEnums.maritalStatus
                        .map(
                          (ms) =>
                              NeomorphicDropdownItem(value: ms, label: ms.tr),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) isMarriedVal.value = val;
                    },
                  ),
                ),
                SizedBox(height: AppSizes.spacingM.h),
                NeomorphicTextField(
                  controller: eduCtrl,
                  labelText: 'education'.tr,
                  prefixIcon: Icon(
                    Icons.school_outlined,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.spacingM.h),
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => NeomorphicDropdownField<String>(
                          value: bloodVal.value,
                          labelText: 'blood_group'.tr,
                          prefixIcon: Icon(
                            Icons.bloodtype_outlined,
                            color: colors.textPrimary,
                          ),
                          items: AppEnums.bloodGroups
                              .map(
                                (bg) => NeomorphicDropdownItem(
                                  value: bg,
                                  label: bg,
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) bloodVal.value = val;
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: AppSizes.spacingM.w),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            birthDateCtrl.text =
                                "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
                          }
                        },
                        child: IgnorePointer(
                          child: NeomorphicTextField(
                            controller: birthDateCtrl,
                            labelText: 'birth_date'.tr,
                            prefixIcon: Icon(
                              Icons.cake_outlined,
                              color: colors.textPrimary,
                            ),
                            hintText: 'DD/MM/YYYY',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.spacingXL.h),
                NeomorphicButton(
                  text: 'add'.tr,
                  isGradient: true,
                  gradientColors: colors.primaryGradient,
                  gradientBegin: Alignment.centerLeft,
                  gradientEnd: Alignment.centerRight,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      controller.addFamilyMemberDraft(
                        firstName: nameCtrl.text.trim(),
                        middleName: middleNameCtrl.text.trim(),
                        lastName: surnameCtrl.text.trim(),
                        relation: relationVal.value,
                        phoneNumber: phoneCtrl.text.trim(),
                        dob: birthDateCtrl.text.trim(),
                        education: eduCtrl.text.trim(),
                        isMarried: isMarriedVal.value,
                        bloodGroup: bloodVal.value,
                      );
                      Get.back();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    isScrollControlled: true,
  );
}
