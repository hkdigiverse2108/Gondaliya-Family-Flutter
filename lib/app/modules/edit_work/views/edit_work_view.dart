import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../global_widgets/glass_app_bar.dart';
import '../../../global_widgets/neomorphic_button.dart';
import '../../../global_widgets/neomorphic_text_field.dart';
import '../../../global_widgets/neomorphic_dropdown_field.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/values/sizes.dart';
import '../../../data/models/enums.dart';
import '../controllers/edit_work_controller.dart';

class EditWorkView extends GetView<EditWorkController> {
  const EditWorkView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    return SafeArea(
      top: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: GlassAppBar(titleText: 'Job Profile'),
        ),
        body: Stack(
          children: [
            // Aurora background glow
            Positioned(
              top: -100.h,
              left: -80.w,
              child: Container(
                width: 280.w,
                height: 280.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colors.primary.withValues(alpha: isDark ? 0.15 : 0.2),
                      colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 100.h,
              right: -100.w,
              child: Container(
                width: 320.w,
                height: 320.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colors.secondary.withValues(alpha: isDark ? 0.12 : 0.18),
                      colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  SizedBox(
                    height:
                        kToolbarHeight +
                        MediaQuery.of(context).padding.top +
                        AppSizes.spacingL.h,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spacingXL.w,
                        vertical: AppSizes.spacingS.h,
                      ),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Setup or update your professional job profile'.tr,
                              style: GoogleFonts.outfit(
                                fontSize: AppSizes.fontSizeBodyMedium.sp,
                                color: colors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: AppSizes.spacingXXL.h),

                            _buildJobForm(context, colors),

                            SizedBox(height: AppSizes.spacingXXL.h),
                            NeomorphicButton(
                              text: 'save'.tr,
                              isGradient: true,
                              width: double.infinity,
                              onPressed: controller.saveWorkDetails,
                            ),
                            SizedBox(height: AppSizes.spacingL.h),

                            // Option to clear job details if they exist
                            Obx(() {
                              final hasExistingJob = controller.jobCategory.value.isNotEmpty ||
                                  controller.companyNameController.text.isNotEmpty;
                              if (!hasExistingJob) return const SizedBox.shrink();

                              return NeomorphicButton(
                                text: 'Clear Job Profile',
                                isGradient: false,
                                width: double.infinity,
                                onPressed: () {
                                  Get.dialog(
                                    AlertDialog(
                                      backgroundColor: colors.card,
                                      title: Text('Clear Job Profile', style: GoogleFonts.outfit(color: colors.textPrimary, fontWeight: FontWeight.bold)),
                                      content: Text('Are you sure you want to clear your job profile details?', style: GoogleFonts.outfit(color: colors.textSecondary)),
                                      actions: [
                                        TextButton(
                                          onPressed: Get.back,
                                          child: Text('Cancel', style: GoogleFonts.outfit(color: colors.textSecondary)),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                            controller.clearJobDetails();
                                          },
                                          child: const Text('Clear', style: TextStyle(color: Colors.redAccent)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }),
                            SizedBox(height: AppSizes.spacing3XL.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildJobForm(BuildContext context, AppColorScheme colors) {
    return Column(
      children: [
        NeomorphicTextField(
          controller: controller.companyNameController,
          labelText: 'company_name'.tr,
          prefixIcon: Icon(Icons.business_outlined, color: colors.textPrimary),
          validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
        ),
        SizedBox(height: AppSizes.spacingL.h),
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
                controller.jobRole.value = '';
              }
            },
          ),
        ),
        SizedBox(height: AppSizes.spacingL.h),
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
                  if (val != null) {
                    controller.jobRole.value = val;
                  }
                },
              ),
              SizedBox(height: AppSizes.spacingL.h),
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
                SizedBox(height: AppSizes.spacingL.h),
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
