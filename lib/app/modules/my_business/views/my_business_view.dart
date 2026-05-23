import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gondalia_family/app/global_widgets/glass_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/values/colors.dart';
import '../controllers/my_business_controller.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/values/sizes.dart';

class MyBusinessView extends GetView<MyBusinessController> {
  const MyBusinessView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: GlassAppBar(
          titleText: 'My Business',
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: colors.textSecondary,
            labelStyle: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: AppSizes.fontSizeBodyMedium.sp,
            ),
            tabs: const [
              Tab(text: 'My Listings'),
              Tab(text: 'Inquiries'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMyListings(colors, context),
            _buildInquiries(colors, context),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Add new listing
          },
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: Text(
            'Add Listing',
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMyListings(AppColorScheme colors, BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(
        top:
            MediaQuery.of(context).padding.top +
            kToolbarHeight +
            kTextTabBarHeight +
            AppSizes.spacingL.h,
        left: AppSizes.spacingL.w,
        right: AppSizes.spacingL.w,
        bottom: AppSizes.spacingL.h,
      ),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: AppSizes.spacingL.h),
          padding: EdgeInsets.all(AppSizes.spacingM.w),
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
          child: Row(
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                ),
                child: Icon(
                  Icons.image_outlined,
                  color: Colors.grey,
                  size: AppSizes.radius3XL.r,
                ),
              ),
              SizedBox(width: AppSizes.spacingL.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Listing Item $index',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: AppSizes.fontSizeBodyLarge.sp,
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingXS.h),
                    Text(
                      'Rent • Active',
                      style: GoogleFonts.outfit(
                        fontSize: AppSizes.fontSizeBodySmall.sp,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingS.h),
                    Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye_outlined,
                          size: AppSizes.fontSizeBodyMedium.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(width: AppSizes.spacingXS.w),
                        Text(
                          '124 views',
                          style: GoogleFonts.outfit(
                            fontSize: AppSizes.fontSizeBodySmall.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit_rounded, color: colors.textPrimary),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                    ),
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

  Widget _buildInquiries(AppColorScheme colors, BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(
        top:
            MediaQuery.of(context).padding.top +
            kToolbarHeight +
            kTextTabBarHeight +
            AppSizes.spacingL.h,
        left: AppSizes.spacingL.w,
        right: AppSizes.spacingL.w,
        bottom: AppSizes.spacingL.h,
      ),
      itemCount: 5,
      separatorBuilder: (context, index) => Divider(
        height: AppSizes.spacing3XL.h,
        color: Colors.grey.withValues(alpha: 0.2),
      ),
      itemBuilder: (context, index) {
        return Row(
          children: [
            CircleAvatar(
              radius: AppSizes.radiusXXL.r,
              backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
              child: Icon(Icons.person_rounded, color: AppColors.secondary),
            ),
            SizedBox(width: AppSizes.spacingL.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inquirer Name',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: AppSizes.fontSizeBodyLarge.sp,
                    ),
                  ),
                  SizedBox(height: AppSizes.spacingXS.h),
                  Text(
                    'Interested in "My Listing Item $index"',
                    style: GoogleFonts.outfit(
                      fontSize: AppSizes.fontSizeBodyMedium.sp,
                      color: colors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.spacingM.w,
                vertical: AppSizes.spacingS.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSizes.radiusXL.r),
              ),
              child: Text(
                'Reply',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: AppSizes.fontSizeBodySmall.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
