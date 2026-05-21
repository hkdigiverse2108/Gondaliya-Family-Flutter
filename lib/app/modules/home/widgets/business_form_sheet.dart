import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../core/values/colors.dart';
import '../../../global_widgets/custom_text_field.dart';
import '../../../global_widgets/custom_button.dart';
import '../../../data/models/business.dart';
import '../controllers/home_controller.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';

void showBusinessFormSheet(
  BuildContext context, {
  required HomeController controller,
  Business? business,
}) {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: business?.name);
  final categoryController = TextEditingController(text: business?.category);
  final addressController = TextEditingController(text: business?.address);
  final contactController = TextEditingController(text: business?.contact);
  final descriptionController = TextEditingController(
    text: business?.description,
  );

  final isEdit = business != null;
  final colors = context.appColors;

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
                isEdit ? 'edit_business'.tr : 'add_business'.tr,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: colors.accent,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              const Divider(),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: nameController,
                labelText: 'business_name'.tr,
                prefixIcon: Icon(
                  Icons.storefront_rounded,
                  color: colors.textPrimary,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'field_required'.tr
                    : null,
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: categoryController,
                labelText: 'business_category'.tr,
                prefixIcon: Icon(
                  Icons.category_outlined,
                  color: colors.textPrimary,
                ),
                hintText: 'e.g. IT Services, Textiles, Agriculture',
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'field_required'.tr
                    : null,
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: addressController,
                labelText: 'business_address'.tr,
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: colors.textPrimary,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'field_required'.tr
                    : null,
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: contactController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                labelText: 'business_contact'.tr,
                prefixIcon: Icon(
                  Icons.phone_iphone_outlined,
                  color: colors.textPrimary,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'field_required'.tr;
                  }
                  if (value.trim().length != 10) {
                    return 'invalid_phone'.tr;
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                controller: descriptionController,
                maxLines: 3,
                labelText: 'business_description'.tr,
                prefixIcon: Icon(
                  Icons.description_outlined,
                  color: colors.textPrimary,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'field_required'.tr
                    : null,
              ),
              SizedBox(height: 20.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: LinearGradient(colors: colors.primaryGradient),
                ),
                child: CustomButton(
                  text: 'save'.tr,
                  backgroundColor: AppColors.transparent,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (isEdit) {
                        controller.updateBusiness(
                          business.copyWith(
                            name: nameController.text.trim(),
                            category: categoryController.text.trim(),
                            address: addressController.text.trim(),
                            contact: contactController.text.trim(),
                            description: descriptionController.text.trim(),
                          ),
                        );
                      } else {
                        controller.addBusiness(
                          name: nameController.text.trim(),
                          category: categoryController.text.trim(),
                          address: addressController.text.trim(),
                          contact: contactController.text.trim(),
                          description: descriptionController.text.trim(),
                        );
                      }
                      Get.back();
                      Get.snackbar(
                        'Success',
                        isEdit
                            ? 'Business updated successfully'
                            : 'Business registered successfully',
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
