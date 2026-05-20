import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../core/values/colors.dart';
import '../../../data/services/translation_service.dart';
import '../controllers/home_controller.dart';

void showLanguageDialog(BuildContext context, HomeController controller) {
  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text(
        'select_language'.tr,
        style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('english'.tr, style: GoogleFonts.outfit()),
            leading: const Icon(Icons.abc_rounded, color: AppColors.primaryLight),
            trailing: !TranslationService.isGujarati
                ? const Icon(Icons.check_circle_rounded, color: AppColors.secondary)
                : null,
            onTap: () {
              controller.changeLanguage('en');
              Get.back();
            },
          ),
          ListTile(
            title: Text('gujarati'.tr, style: GoogleFonts.outfit()),
            leading: const Icon(Icons.font_download_rounded, color: AppColors.primaryLight),
            trailing: TranslationService.isGujarati
                ? const Icon(Icons.check_circle_rounded, color: AppColors.secondary)
                : null,
            onTap: () {
              controller.changeLanguage('gu');
              Get.back();
            },
          ),
        ],
      ),
    ),
  );
}

void showDeleteConfirmation(BuildContext context, {
  required HomeController controller,
  required bool isMember,
  required String id,
}) {
  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text(
        'delete'.tr,
        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.error),
      ),
      content: Text(
        isMember ? 'delete_member_confirm'.tr : 'delete_business_confirm'.tr,
        style: GoogleFonts.outfit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'cancel'.tr,
            style: GoogleFonts.outfit(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (isMember) {
              controller.deleteFamilyMember(id);
            } else {
              controller.deleteBusiness(id);
            }
            Get.back();
            Get.snackbar(
              'Success',
              'Item deleted successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.secondary.withValues(alpha: 0.9),
              colorText: AppColors.white,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          ),
          child: Text(
            'delete'.tr,
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
