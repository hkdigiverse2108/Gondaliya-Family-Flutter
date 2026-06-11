import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../global_widgets/glass_app_bar.dart';
import '../../../../core/values/colors.dart';
import '../../../global_widgets/neomorphic_button.dart';
import '../widgets/account_step.dart';
import '../widgets/profile_step.dart';
import '../widgets/occupation_step.dart';
import '../widgets/family_step.dart';
import '../widgets/add_family_sheet.dart';
import '../controllers/register_controller.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/values/sizes.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    return SafeArea(
      top: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: GlassAppBar(titleText: 'register'.tr),
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
                      colors.tealBridge.withValues(alpha: isDark ? 0.15 : 0.25),
                      colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Obx(() {
              return Column(
                children: [
                  SizedBox(
                    height:
                        kToolbarHeight +
                        MediaQuery.of(context).padding.top +
                        AppSizes.spacingXL.h,
                  ),
                  _buildCustomStepperHeader(
                    controller.currentStep.value,
                    colors,
                    isDark,
                  ),
                  SizedBox(height: AppSizes.spacingL.h),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spacingXL.w,
                        vertical: AppSizes.spacingS.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildStepContent(
                            controller.currentStep.value,
                            controller,
                            context,
                          ),
                          SizedBox(height: AppSizes.spacing3XL.h),
                          _buildControls(controller, colors, isDark),
                          SizedBox(height: AppSizes.spacing3XL.h),
                        ],
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

  Widget _buildCustomStepperHeader(
    int currentStep,
    AppColorScheme colors,
    bool isDark,
  ) {
    final icons = [
      Icons.lock_outline_rounded,
      Icons.person_outline_rounded,
      Icons.work_outline_rounded,
      Icons.people_outline_rounded,
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.spacing3XL.w),
      child: Row(
        children: List.generate(icons.length * 2 - 1, (index) {
          if (index % 2 != 0) {
            // Connector line
            final stepIndex = index ~/ 2;
            final isActive = currentStep > stepIndex;
            return Expanded(
              child: Container(
                height: AppSizes.spacingXXS.h,
                color: isActive
                    ? AppColors.primary
                    : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
              ),
            );
          } else {
            // Step Icon
            final stepIndex = index ~/ 2;
            final isActive = currentStep >= stepIndex;
            final isCompleted = currentStep > stepIndex;

            return Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? AppColors.primary
                    : (isDark ? AppColors.cardDark : AppColors.cardLight),
                border: Border.all(
                  color: isActive
                      ? AppColors.primary
                      : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                  width: 2,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                isCompleted ? Icons.check_rounded : icons[stepIndex],
                color: isActive
                    ? Colors.white
                    : (isDark ? Colors.grey.shade500 : Colors.grey.shade400),
                size: AppSizes.spacingXL.w,
              ),
            );
          }
        }),
      ),
    );
  }

  Widget _buildStepContent(
    int currentStep,
    RegisterController controller,
    BuildContext context,
  ) {
    switch (currentStep) {
      case 0:
        return AccountStep(controller: controller);
      case 1:
        return ProfileStep(controller: controller);
      case 2:
        return OccupationStep(controller: controller);
      case 3:
        return FamilyStep(
          controller: controller,
          onAddMember: () => showAddFamilySheet(context, controller),
          onEditMember: (member) =>
              showAddFamilySheet(context, controller, memberToEdit: member),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildControls(
    RegisterController controller,
    AppColorScheme colors,
    bool isDark,
  ) {
    final isLastStep = controller.currentStep.value == 3;
    return Row(
      children: [
        if (controller.currentStep.value > 0)
          Expanded(
            child: NeomorphicButton(
              text: 'back'.tr,
              onPressed: controller.previousStep,
              backgroundColor: isDark
                  ? AppColors.cardDark
                  : AppColors.cardLight,
              textColor: isDark ? AppColors.white : AppColors.textLightPrimary,
            ),
          ),
        if (controller.currentStep.value > 0)
          SizedBox(width: AppSizes.spacingM.w),
        Expanded(
          child: Obx(
            () => NeomorphicButton(
              text: isLastStep ? 'sign_up'.tr : 'next'.tr,
              isLoading: controller.isLoading.value,
              onPressed: isLastStep
                  ? controller.submitRegistration
                  : controller.nextStep,
              isGradient: true,
              gradientColors: colors.primaryGradient,
              gradientBegin: Alignment.centerLeft,
              gradientEnd: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }
}
