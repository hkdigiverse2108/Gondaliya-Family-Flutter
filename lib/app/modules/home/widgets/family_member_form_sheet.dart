import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../core/values/colors.dart';
import '../../../global_widgets/custom_text_field.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../data/models/family_member.dart';
import '../controllers/home_controller.dart';

void showFamilyMemberFormSheet(BuildContext context, {
  required HomeController controller,
  FamilyMember? member,
}) {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: member?.name);
  final surnameController = TextEditingController(text: member?.surname);
  final fatherNameController = TextEditingController(text: member?.fatherName);
  final ageController = TextEditingController(text: member != null ? '${member.age}' : '');
  final relationshipController = TextEditingController(text: member?.relationship);
  final phoneController = TextEditingController(text: member?.phoneNumber);
  final occupationController = TextEditingController(text: member?.occupation);
  final birthDateController = TextEditingController(text: member?.birthDate);
  final eduController = TextEditingController(text: member?.education);
  final bloodController = TextEditingController(text: member?.bloodGroup);
  final skillController = TextEditingController(text: member?.skill);
  final isMarriedRx = (member?.isMarried ?? false).obs;

  final isEdit = member != null;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  Get.bottomSheet(
    Container(
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
                isEdit ? 'edit_member'.tr : 'add_member'.tr,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: isDark ? AppColors.secondaryLight : AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              const Divider(),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: nameController,
                labelText: 'full_name'.tr,
                prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primaryLight),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'field_required'.tr : null,
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      labelText: 'age'.tr,
                      prefixIcon: const Icon(Icons.calendar_today_outlined, color: AppColors.primaryLight),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'field_required'.tr;
                        }
                        final parsedAge = int.tryParse(value);
                        if (parsedAge == null || parsedAge <= 0 || parsedAge > 120) {
                          return 'invalid_age'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 3,
                    child: CustomTextField(
                      controller: relationshipController,
                      labelText: 'relationship'.tr,
                      prefixIcon: const Icon(Icons.family_restroom_rounded, color: AppColors.primaryLight),
                      hintText: 'Father, Daughter, etc.',
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? 'field_required'.tr : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                labelText: 'phone_number'.tr,
                prefixIcon: const Icon(Icons.phone_iphone_outlined, color: AppColors.primaryLight),
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length != 10) {
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
                      controller: birthDateController,
                      labelText: 'birth_date'.tr,
                      prefixIcon: const Icon(Icons.cake_outlined, color: AppColors.primaryLight),
                      hintText: 'DD/MM/YYYY',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomTextField(
                      controller: eduController,
                      labelText: 'education'.tr,
                      prefixIcon: const Icon(Icons.school_outlined, color: AppColors.primaryLight),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: occupationController,
                      labelText: 'occupation'.tr,
                      prefixIcon: const Icon(Icons.work_outline_rounded, color: AppColors.primaryLight),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomTextField(
                      controller: bloodController,
                      labelText: 'blood_group'.tr,
                      prefixIcon: const Icon(Icons.bloodtype_outlined, color: AppColors.primaryLight),
                      hintText: 'A+, B+, etc.',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: skillController,
                labelText: 'skill'.tr,
                prefixIcon: const Icon(Icons.bolt_rounded, color: AppColors.primaryLight),
              ),
              SizedBox(height: 12.h),
              Obx(() => SwitchListTile(
                    title: Text('married'.tr, style: GoogleFonts.outfit(fontSize: 14.sp, color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary)),
                    value: isMarriedRx.value,
                    onChanged: (val) => isMarriedRx.value = val,
                    contentPadding: EdgeInsets.zero,
                  )),
              SizedBox(height: 20.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.tealBridge, AppColors.secondary],
                  ),
                ),
                child: CustomButton(
                  text: 'save'.tr,
                  backgroundColor: AppColors.transparent,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (isEdit) {
                        controller.updateFamilyMember(member.copyWith(
                          name: nameController.text.trim(),
                          surname: surnameController.text.trim(),
                          fatherName: fatherNameController.text.trim(),
                          age: int.parse(ageController.text.trim()),
                          relationship: relationshipController.text.trim(),
                          phoneNumber: phoneController.text.trim(),
                          occupation: occupationController.text.trim(),
                          birthDate: birthDateController.text.trim(),
                          education: eduController.text.trim(),
                          isMarried: isMarriedRx.value,
                          bloodGroup: bloodController.text.trim(),
                          skill: skillController.text.trim(),
                        ));
                      } else {
                        controller.addFamilyMember(
                          name: nameController.text.trim(),
                          surname: surnameController.text.trim(),
                          fatherName: fatherNameController.text.trim(),
                          age: int.parse(ageController.text.trim()),
                          relationship: relationshipController.text.trim(),
                          phoneNumber: phoneController.text.trim(),
                          occupation: occupationController.text.trim(),
                          birthDate: birthDateController.text.trim(),
                          education: eduController.text.trim(),
                          isMarried: isMarriedRx.value,
                          bloodGroup: bloodController.text.trim(),
                          skill: skillController.text.trim(),
                        );
                      }
                      Get.back();
                      Get.snackbar(
                        'Success',
                        isEdit ? 'Member updated successfully' : 'Member added successfully',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.secondary.withValues(alpha: 0.9),
                        colorText: AppColors.white,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    isScrollControlled: true,
  );
}
