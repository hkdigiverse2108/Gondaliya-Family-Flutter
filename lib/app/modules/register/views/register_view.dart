import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/values/colors.dart';
import '../../../global_widgets/neomorphic_button.dart';
import '../widgets/account_step.dart';
import '../widgets/profile_step.dart';
import '../widgets/occupation_step.dart';
import '../widgets/family_step.dart';
import '../widgets/add_family_sheet.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Scaffold(
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
                    final isLastStep = controller.currentStep.value == 3;
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: Row(
                        children: [
                          if (controller.currentStep.value > 0)
                            Expanded(
                              child: NeomorphicButton(
                                text: 'back'.tr,
                                onPressed: controls.onStepCancel,
                                backgroundColor: isDark
                                    ? AppColors.cardDark
                                    : AppColors.cardLight,
                                textColor: isDark
                                    ? AppColors.white
                                    : AppColors.textLightPrimary,
                              ),
                            ),
                          if (controller.currentStep.value > 0)
                            SizedBox(width: 12.w),
                          Expanded(
                            child: Obx(
                              () => NeomorphicButton(
                                text: isLastStep ? 'sign_up'.tr : 'next'.tr,
                                isLoading: controller.isLoading.value,
                                onPressed: isLastStep
                                    ? controller.submitRegistration
                                    : controls.onStepContinue,
                                isGradient: true,
                                gradientColors: const [
                                  AppColors.primary,
                                  AppColors.tealBridge,
                                  AppColors.secondary,
                                ],
                                gradientBegin: Alignment.centerLeft,
                                gradientEnd: Alignment.centerRight,
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
                        Icons.work_outline,
                        color: controller.currentStep.value >= 2
                            ? (isDark
                                  ? AppColors.secondaryLight
                                  : AppColors.primary)
                            : (isDark ? Colors.grey.shade600 : Colors.grey),
                      ),
                      content: OccupationStep(controller: controller),
                      isActive: controller.currentStep.value >= 2,
                      state: controller.currentStep.value > 2
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: Icon(
                        Icons.people_outline_rounded,
                        color: controller.currentStep.value >= 3
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
                      isActive: controller.currentStep.value >= 3,
                      state: controller.currentStep.value == 3
                          ? StepState.editing
                          : StepState.indexed,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
