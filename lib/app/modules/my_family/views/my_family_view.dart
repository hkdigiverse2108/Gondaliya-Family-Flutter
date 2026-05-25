import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/values/sizes.dart';
import 'package:gondalia_family/app/routes/app_pages.dart';
import 'package:gondalia_family/app/modules/home/controllers/profile_controller.dart';
import 'package:gondalia_family/app/modules/home/widgets/family_member_form_sheet.dart';

class MyFamilyView extends StatelessWidget {
  const MyFamilyView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final controller = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'family_members'.tr,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: colors.card,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final members = controller.familyMembers;

        if (members.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  PhosphorIcons.users(PhosphorIconsStyle.light),
                  size: 64.sp,
                  color: colors.textSecondary.withValues(alpha: 0.5),
                ),
                SizedBox(height: AppSizes.spacingL.h),
                Text(
                  'no_members_yet'.tr,
                  style: GoogleFonts.outfit(
                    color: colors.textSecondary,
                    fontSize: AppSizes.fontSizeBodyMedium.sp,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(AppSizes.spacingL.w),
          itemCount: members.length,
          separatorBuilder: (context, index) => SizedBox(height: AppSizes.spacingM.h),
          itemBuilder: (context, index) {
            final f = members[index];
            final initials = '${f.firstName.isNotEmpty ? f.firstName[0] : ''}${f.lastName.isNotEmpty ? f.lastName[0] : ''}'.toUpperCase();

            return Container(
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.08),
                  width: 1,
                ),
                boxShadow: colors.neumorphicShadow(blur: 10, distance: 3),
              ),
              child: InkWell(
                onTap: () {
                  Get.toNamed(
                    Routes.family,
                    arguments: {'member': f},
                  );
                },
                borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.spacingL.w),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22.r,
                        backgroundColor: colors.primary.withValues(alpha: 0.08),
                        child: Text(
                          initials,
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: colors.primary,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSizes.spacingL.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${f.firstName} ${f.lastName}',
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppSizes.fontSizeBodyLarge.sp,
                                      color: colors.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: AppSizes.spacingS.w),
                                // Relation tag
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: _getRelationColor(f.relation, colors).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(AppSizes.radiusS.r),
                                    border: Border.all(
                                      color: _getRelationColor(f.relation, colors).withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Text(
                                    f.relation,
                                    style: GoogleFonts.outfit(
                                      fontSize: AppSizes.fontSizeMicro.sp,
                                      fontWeight: FontWeight.bold,
                                      color: _getRelationColor(f.relation, colors),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (f.occupation != null && f.occupation!.isNotEmpty) ...[
                              SizedBox(height: 2.h),
                              Text(
                                f.occupation!,
                                style: GoogleFonts.outfit(
                                  fontSize: AppSizes.fontSizeBodySmall.sp,
                                  color: colors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            if (f.phoneNumber.isNotEmpty) ...[
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Icon(PhosphorIcons.phone(), size: 12.sp, color: colors.textSecondary),
                                  SizedBox(width: 4.w),
                                  Text(
                                    f.phoneNumber,
                                    style: GoogleFonts.outfit(
                                      fontSize: AppSizes.fontSizeCaption.sp,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Action buttons (Edit & Delete)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(PhosphorIcons.pencilSimple(), color: colors.accent, size: 18.sp),
                            onPressed: () {
                              showFamilyMemberFormSheet(context, controller: controller, member: f);
                            },
                          ),
                          IconButton(
                            icon: Icon(PhosphorIcons.trash(), color: Colors.redAccent, size: 18.sp),
                            onPressed: () => _confirmDelete(context, f.id ?? '', '${f.firstName} ${f.lastName}', controller, colors),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showFamilyMemberFormSheet(context, controller: controller);
        },
        backgroundColor: colors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'add_member'.tr,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    String id,
    String name,
    ProfileController controller,
    AppColorScheme colors,
  ) {
    Get.dialog(
      AlertDialog(
        backgroundColor: colors.card,
        title: Text(
          'delete'.tr,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: colors.textPrimary),
        ),
        content: Text(
          '${'delete_member_confirm'.tr}\n\n$name',
          style: GoogleFonts.outfit(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            child: Text('cancel'.tr, style: GoogleFonts.outfit(color: colors.textSecondary)),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: Text('delete'.tr, style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
            onPressed: () {
              controller.deleteFamilyMember(id);
              Get.back();
              Get.snackbar(
                'Deleted',
                'Family member deleted successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getRelationColor(String relation, AppColorScheme colors) {
    switch (relation.toLowerCase()) {
      case 'wife':
      case 'spouse':
        return Colors.purple;
      case 'son':
        return Colors.blue;
      case 'daughter':
        return Colors.pink;
      case 'father':
        return Colors.teal;
      case 'mother':
        return Colors.orange;
      default:
        return colors.primary;
    }
  }
}
