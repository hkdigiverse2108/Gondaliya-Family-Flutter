import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/values/colors.dart';
import '../controllers/announcements_controller.dart';

class AnnouncementsView extends GetView<AnnouncementsController> {
  const AnnouncementsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Announcements',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: 10,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final hasImage = index % 2 == 0;
          return Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16.r),
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
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary,
                        radius: 20.r,
                        child: Icon(Icons.campaign_rounded, color: Colors.white, size: 24.r),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Admin / Committee',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              '2 hours ago',
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
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
                  padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: hasImage ? 12.h : 16.h),
                  child: Text(
                    'This is an important announcement regarding the upcoming family gathering. Please make sure to RSVP by the end of the week!',
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
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
                        bottomLeft: Radius.circular(16.r),
                        bottomRight: Radius.circular(16.r),
                      ),
                    ),
                    child: Icon(Icons.image_outlined, color: Colors.grey, size: 60.r),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
