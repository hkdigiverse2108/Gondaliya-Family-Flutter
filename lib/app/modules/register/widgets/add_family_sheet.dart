import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/values/colors.dart';
import '../../../global_widgets/custom_text_field.dart';
import '../../../global_widgets/custom_button.dart';
import '../controllers/register_controller.dart';

void showAddFamilySheet(BuildContext context, RegisterController controller) {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final relationCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final occupCtrl = TextEditingController();
  final birthDateCtrl = TextEditingController();
  final eduCtrl = TextEditingController();
  final bloodCtrl = TextEditingController();
  final skillCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  var isMarriedVal = false.obs;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  Get.bottomSheet(
    SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 20.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
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
                SizedBox(height: 8.h),
                const Divider(),
                SizedBox(height: 12.h),
                CustomTextField(
                  controller: nameCtrl,
                  labelText: 'full_name'.tr,
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.primaryLight,
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'field_required'.tr
                      : null,
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: ageCtrl,
                        labelText: 'age'.tr,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        prefixIcon: const Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.primaryLight,
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'field_required'.tr
                            : null,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomTextField(
                        controller: relationCtrl,
                        labelText: 'relationship'.tr,
                        prefixIcon: const Icon(
                          Icons.family_restroom_rounded,
                          color: AppColors.primaryLight,
                        ),
                        hintText: 'Father, Son, etc.',
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'field_required'.tr
                            : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                CustomTextField(
                  controller: phoneCtrl,
                  labelText: 'phone_number'.tr,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(
                    Icons.phone_iphone_outlined,
                    color: AppColors.primaryLight,
                  ),
                  validator: (val) {
                    if (val != null && val.isNotEmpty && val.length != 10) {
                      return 'invalid_phone'.tr;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: birthDateCtrl,
                        labelText: 'birth_date'.tr,
                        prefixIcon: const Icon(
                          Icons.cake_outlined,
                          color: AppColors.primaryLight,
                        ),
                        hintText: 'DD/MM/YYYY',
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomTextField(
                        controller: eduCtrl,
                        labelText: 'education'.tr,
                        prefixIcon: const Icon(
                          Icons.school_outlined,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: occupCtrl,
                        labelText: 'occupation'.tr,
                        prefixIcon: const Icon(
                          Icons.work_outline_rounded,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomTextField(
                        controller: bloodCtrl,
                        labelText: 'blood_group'.tr,
                        prefixIcon: const Icon(
                          Icons.bloodtype_outlined,
                          color: AppColors.primaryLight,
                        ),
                        hintText: 'A+, B+, etc.',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                CustomTextField(
                  controller: skillCtrl,
                  labelText: 'skill'.tr,
                  prefixIcon: const Icon(
                    Icons.bolt_rounded,
                    color: AppColors.primaryLight,
                  ),
                ),
                SizedBox(height: 12.h),
                CustomTextField(
                  controller: notesCtrl,
                  labelText: 'notes'.tr,
                  maxLines: 2,
                  prefixIcon: const Icon(
                    Icons.notes_rounded,
                    color: AppColors.primaryLight,
                  ),
                ),
                SizedBox(height: 12.h),
                Obx(
                  () => SwitchListTile(
                    title: Text(
                      'married'.tr,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        color: isDark
                            ? AppColors.textDarkPrimary
                            : AppColors.textLightPrimary,
                      ),
                    ),
                    value: isMarriedVal.value,
                    onChanged: (val) => isMarriedVal.value = val,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.tealBridge,
                        AppColors.secondary,
                      ],
                    ),
                  ),
                  child: CustomButton(
                    text: 'add'.tr,
                    backgroundColor: AppColors.transparent,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        controller.addFamilyMemberDraft(
                          fullName: nameCtrl.text.trim(),
                          age: int.parse(ageCtrl.text.trim()),
                          relationship: relationCtrl.text.trim(),
                          phoneNumber: phoneCtrl.text.trim(),
                          occupation: occupCtrl.text.trim(),
                          birthDate: birthDateCtrl.text.trim(),
                          education: eduCtrl.text.trim(),
                          isMarried: isMarriedVal.value,
                          bloodGroup: bloodCtrl.text.trim(),
                          skill: skillCtrl.text.trim(),
                          notes: notesCtrl.text.trim(),
                        );
                        Get.back();
                      }
                    },
                  ),
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
