import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../core/values/colors.dart';
import '../../../global_widgets/custom_text_field.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../data/models/family_member.dart';
import '../controllers/profile_controller.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/values/sizes.dart';

void showFamilyMemberFormSheet(
  BuildContext context, {
  required ProfileController controller,
  FamilyMember? member,
}) {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: member?.firstName);
  final surnameController = TextEditingController(text: member?.lastName);
  final middleNameController = TextEditingController(text: member?.middleName);
  final relationshipController = TextEditingController(text: member?.relation);
  final phoneController = TextEditingController(text: member?.phoneNumber);
  final occupationController = TextEditingController(text: member?.occupation);
  final birthDateController = TextEditingController(text: member?.dob);
  final eduController = TextEditingController(text: member?.education);
  final bloodController = TextEditingController(text: member?.bloodGroup);
  final skillController = TextEditingController(text: member?.skills);
  final isMarriedRx =
      ((member?.isMarried.toLowerCase() == 'married') ||
              member?.isMarried == 'true')
          .obs;

  final isEdit = member != null;
  final colors = context.appColors;

  Get.bottomSheet(
    Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: AppSizes.spacingL.w,
        right: AppSizes.spacingL.w,
        top: AppSizes.spacingXL.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.spacingXL.h,
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
                  color: colors.accent,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.spacingS.h),
              const Divider(),
              SizedBox(height: AppSizes.spacingM.h),
              CustomTextField(
                controller: nameController,
                labelText: 'full_name'.tr,
                prefixIcon: Icon(
                  Icons.person_outline_rounded,
                  color: colors.textPrimary,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'field_required'.tr
                    : null,
              ),
              SizedBox(height: AppSizes.spacingM.h),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      controller: middleNameController,
                      labelText: 'Middle Name',
                      prefixIcon: Icon(
                        Icons.person_outline_rounded,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.spacingM.w),
                  Expanded(
                    flex: 3,
                    child: CustomTextField(
                      controller: relationshipController,
                      labelText: 'relationship'.tr,
                      prefixIcon: Icon(
                        Icons.family_restroom_rounded,
                        color: colors.textPrimary,
                      ),
                      hintText: 'Father, Daughter, etc.',
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'field_required'.tr
                          : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.spacingM.h),
              CustomTextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                labelText: 'phone_number'.tr,
                prefixIcon: Icon(
                  Icons.phone_iphone_outlined,
                  color: colors.textPrimary,
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length != 10) {
                    return 'invalid_phone'.tr;
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSizes.spacingM.h),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: birthDateController,
                      labelText: 'birth_date'.tr,
                      prefixIcon: Icon(
                        Icons.cake_outlined,
                        color: colors.textPrimary,
                      ),
                      hintText: 'DD/MM/YYYY',
                    ),
                  ),
                  SizedBox(width: AppSizes.spacingM.w),
                  Expanded(
                    child: CustomTextField(
                      controller: eduController,
                      labelText: 'education'.tr,
                      prefixIcon: Icon(
                        Icons.school_outlined,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.spacingM.h),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: occupationController,
                      labelText: 'occupation'.tr,
                      prefixIcon: Icon(
                        Icons.work_outline_rounded,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.spacingM.w),
                  Expanded(
                    child: CustomTextField(
                      controller: bloodController,
                      labelText: 'blood_group'.tr,
                      prefixIcon: Icon(
                        Icons.bloodtype_outlined,
                        color: colors.textPrimary,
                      ),
                      hintText: 'A+, B+, etc.',
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.spacingM.h),
              CustomTextField(
                controller: skillController,
                labelText: 'skill'.tr,
                prefixIcon: Icon(Icons.bolt_rounded, color: colors.textPrimary),
              ),
              SizedBox(height: AppSizes.spacingM.h),
              Obx(
                () => SwitchListTile(
                  title: Text(
                    'married'.tr,
                    style: GoogleFonts.outfit(
                      fontSize: AppSizes.fontSizeBodyMedium.sp,
                      color: colors.textPrimary,
                    ),
                  ),
                  value: isMarriedRx.value,
                  onChanged: (val) => isMarriedRx.value = val,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              SizedBox(height: AppSizes.spacingXL.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                  gradient: LinearGradient(colors: colors.primaryGradient),
                ),
                child: CustomButton(
                  text: 'save'.tr,
                  backgroundColor: AppColors.transparent,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (isEdit) {
                        controller.updateFamilyMember(
                          member.copyWith(
                            firstName: nameController.text.trim(),
                            middleName: middleNameController.text.trim(),
                            lastName: surnameController.text.trim(),
                            relation: relationshipController.text.trim(),
                            phoneNumber: phoneController.text.trim(),
                            occupation: occupationController.text.trim(),
                            dob: birthDateController.text.trim(),
                            education: eduController.text.trim(),
                            isMarried: isMarriedRx.value
                                ? 'married'
                                : 'unmarried',
                            bloodGroup: bloodController.text.trim(),
                            skills: skillController.text.trim(),
                          ),
                        );
                      } else {
                        controller.addFamilyMember(
                          firstName: nameController.text.trim(),
                          middleName: middleNameController.text.trim(),
                          lastName: surnameController.text.trim(),
                          relation: relationshipController.text.trim(),
                          phoneNumber: phoneController.text.trim(),
                          occupation: occupationController.text.trim(),
                          dob: birthDateController.text.trim(),
                          education: eduController.text.trim(),
                          isMarried: isMarriedRx.value
                              ? 'married'
                              : 'unmarried',
                          bloodGroup: bloodController.text.trim(),
                          skills: skillController.text.trim(),
                        );
                      }
                      Get.back();
                      Get.snackbar(
                        'Success',
                        isEdit
                            ? 'Member updated successfully'
                            : 'Member added successfully',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.secondary.withValues(
                          alpha: 0.9,
                        ),
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
