import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gondalia_family/app/global_widgets/glass_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/values/colors.dart';
import '../controllers/announcements_controller.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/values/sizes.dart';

class AnnouncementsView extends GetView<AnnouncementsController> {
  const AnnouncementsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(titleText: 'Announcements', centerTitle: true),
      body: ListView.separated(
        padding: EdgeInsets.only(
          top:
              MediaQuery.of(context).padding.top +
              kToolbarHeight +
              AppSizes.spacingL.h,
          left: AppSizes.spacingL.w,
          right: AppSizes.spacingL.w,
          bottom: AppSizes.spacingL.h,
        ),
        itemCount: 10,
        separatorBuilder: (context, index) =>
            SizedBox(height: AppSizes.spacingL.h),
        itemBuilder: (context, index) {
          final hasImage = index % 2 == 0;
          return Container(
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.all(AppSizes.spacingL.w),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary,
                        radius: AppSizes.radiusXL.r,
                        child: Icon(
                          Icons.campaign_rounded,
                          color: Colors.white,
                          size: AppSizes.radiusXXL.r,
                        ),
                      ),
                      SizedBox(width: AppSizes.spacingM.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Admin / Committee',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: AppSizes.fontSizeBodyMedium.sp,
                              ),
                            ),
                            Text(
                              '2 hours ago',
                              style: GoogleFonts.outfit(
                                fontSize: AppSizes.fontSizeBodySmall.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingL.w)
                      .copyWith(
                        bottom: hasImage
                            ? AppSizes.spacingM.h
                            : AppSizes.spacingL.h,
                      ),
                  child: Text(
                    'This is an important announcement regarding the upcoming family gathering. Please make sure to RSVP by the end of the week!',
                    style: GoogleFonts.outfit(
                      fontSize: AppSizes.fontSizeBodyMedium.sp,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),

                // Image
                if (hasImage)
                  Container(
                    height: 180.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(AppSizes.radiusL.r),
                        bottomRight: Radius.circular(AppSizes.radiusL.r),
                      ),
                    ),
                    child: Icon(
                      Icons.image_outlined,
                      color: Colors.grey,
                      size: 60.r,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
