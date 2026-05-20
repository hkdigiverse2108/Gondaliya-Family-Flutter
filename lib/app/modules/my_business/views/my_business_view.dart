import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/values/colors.dart';
import '../controllers/my_business_controller.dart';

class MyBusinessView extends GetView<MyBusinessController> {
  const MyBusinessView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Business',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14.sp),
            tabs: const [
              Tab(text: 'My Listings'),
              Tab(text: 'Inquiries'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMyListings(isDark),
            _buildInquiries(isDark),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Add new listing
          },
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: Text('Add Listing', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildMyListings(bool isDark) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(12.w),
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
          child: Row(
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.image_outlined, color: Colors.grey, size: 32.r),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Listing Item $index',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Rent • Active',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.remove_red_eye_outlined, size: 14.sp, color: Colors.grey),
                        SizedBox(width: 4.w),
                        Text(
                          '124 views',
                          style: GoogleFonts.outfit(fontSize: 12.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, color: AppColors.primary),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInquiries(bool isDark) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: 5,
      separatorBuilder: (context, index) => Divider(height: 32.h, color: Colors.grey.withValues(alpha: 0.2)),
      itemBuilder: (context, index) {
        return Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
              child: Icon(Icons.person_rounded, color: AppColors.secondary),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inquirer Name',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Interested in "My Listing Item $index"',
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'Reply',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
