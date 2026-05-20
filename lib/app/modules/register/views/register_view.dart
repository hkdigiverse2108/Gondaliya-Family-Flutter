import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/values/colors.dart';
import '../../../../core/values/sizes.dart';
import '../../../global_widgets/custom_button.dart';
import '../widgets/account_step.dart';
import '../widgets/profile_step.dart';
import '../widgets/family_step.dart';
import '../widgets/add_family_sheet.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'register'.tr,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Aurora gradients
          Positioned(
            top: -120.h,
            right: -100.w,
            child: Container(
              width: 300.w,
              height: 300.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.tealBridge.withValues(alpha: 0.25),
                    AppColors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Obx(() {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                  secondary: AppColors.secondary,
                ),
              ),
              child: Stepper(
                type: StepperType.horizontal,
                currentStep: controller.currentStep.value,
                onStepContinue: controller.nextStep,
                onStepCancel: controller.previousStep,
                controlsBuilder: (context, controls) {
                  final isLastStep = controller.currentStep.value == 2;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Row(
                      children: [
                        if (controller.currentStep.value > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: controls.onStepCancel,
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.radiusM,
                                  ),
                                ),
                                side: BorderSide(
                                  color: isDark
                                      ? AppColors.dividerDark
                                      : AppColors.dividerLight,
                                ),
                              ),
                              child: Text(
                                'back'.tr,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.textLightPrimary,
                                ),
                              ),
                            ),
                          ),
                        if (controller.currentStep.value > 0)
                          SizedBox(width: 12.w),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.tealBridge,
                                  AppColors.secondary,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: CustomButton(
                              text: isLastStep ? 'sign_up'.tr : 'next'.tr,
                              backgroundColor: AppColors.transparent,
                              isLoading: controller.isLoading.value,
                              onPressed: isLastStep
                                  ? controller.submitRegistration
                                  : controls.onStepContinue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                steps: [
                  Step(
                    title: Icon(
                      Icons.lock_outline_rounded,
                      color: controller.currentStep.value >= 0
                          ? (isDark
                                ? AppColors.secondaryLight
                                : AppColors.primary)
                          : (isDark ? Colors.grey.shade600 : Colors.grey),
                    ),
                    content: AccountStep(controller: controller),
                    isActive: controller.currentStep.value >= 0,
                    state: controller.currentStep.value > 0
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: Icon(
                      Icons.person_pin_circle_outlined,
                      color: controller.currentStep.value >= 1
                          ? (isDark
                                ? AppColors.secondaryLight
                                : AppColors.primary)
                          : (isDark ? Colors.grey.shade600 : Colors.grey),
                    ),
                    content: ProfileStep(controller: controller),
                    isActive: controller.currentStep.value >= 1,
                    state: controller.currentStep.value > 1
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: Icon(
                      Icons.people_outline_rounded,
                      color: controller.currentStep.value >= 2
                          ? (isDark
                                ? AppColors.secondaryLight
                                : AppColors.primary)
                          : (isDark ? Colors.grey.shade600 : Colors.grey),
                    ),
                    content: FamilyStep(
                      controller: controller,
                      onAddMember: () =>
                          showAddFamilySheet(context, controller),
                    ),
                    isActive: controller.currentStep.value >= 2,
                    state: controller.currentStep.value == 2
                        ? StepState.editing
                        : StepState.indexed,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
