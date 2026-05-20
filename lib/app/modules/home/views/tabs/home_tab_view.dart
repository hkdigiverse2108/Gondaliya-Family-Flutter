import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../../controllers/home_controller.dart';
import '../../../../../core/values/colors.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search in Gondaliya Family...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: isDark ? AppColors.cardDark : Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Categories Grid
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Categories',
              style: GoogleFonts.outfit(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: 5,
              itemBuilder: (context, index) {
                final categories = ['Business', 'Jobs', 'Rent', '2nd Hand', 'Seasonal'];
                final icons = [Icons.business, Icons.work, Icons.house, Icons.shopping_bag, Icons.eco];
                return Container(
                  width: 80.w,
                  margin: EdgeInsets.only(right: 12.w),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icons[index], color: AppColors.primary, size: 28.w),
                      SizedBox(height: 8.h),
                      Text(
                        categories[index],
                        style: GoogleFonts.outfit(fontSize: 12.sp),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 24.h),

          // Embedded Previews
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _buildSectionHeader('Announcements', isDark, onViewMore: () => Get.toNamed(Routes.announcements)),
          ),
          _buildHorizontalList(
            height: 120.h,
            itemBuilder: (context, index) => _buildPreviewCard(
              title: 'Announcement $index',
              subtitle: 'Important update for the family.',
              icon: Icons.campaign_rounded,
              isDark: isDark,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _buildSectionHeader('Market Place', isDark, onViewMore: () {
              if (Get.isRegistered<HomeController>()) {
                Get.find<HomeController>().changeTab(2);
              }
            }),
          ),
          _buildHorizontalList(
            height: 160.h,
            itemBuilder: (context, index) => _buildPreviewCard(
              title: 'Item $index',
              subtitle: '₹500 • For Sale',
              icon: Icons.storefront_rounded,
              isDark: isDark,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _buildSectionHeader('General Chat', isDark, onViewMore: () => Get.toNamed(Routes.chat)),
          ),
          _buildHorizontalList(
            height: 100.h,
            itemBuilder: (context, index) => _buildPreviewCard(
              title: 'Need Plumber',
              subtitle: 'Give/Take Request',
              icon: Icons.chat_bubble_outline_rounded,
              isDark: isDark,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _buildSectionHeader('Parivar', isDark, onViewMore: () {
              if (Get.isRegistered<HomeController>()) {
                Get.find<HomeController>().changeTab(1);
              }
            }),
          ),
          _buildHorizontalList(
            height: 100.h,
            itemBuilder: (context, index) => _buildPreviewCard(
              title: 'Member Name',
              subtitle: 'Profession • City',
              icon: Icons.person_outline_rounded,
              isDark: isDark,
            ),
          ),

          SizedBox(height: 24.h),

          // Feed Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Recent Feed',
              style: GoogleFonts.outfit(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(Icons.image, color: Colors.grey),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Feed Item $index',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Description of the feed item (Rent, 2nd Hand, etc.)',
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark, {VoidCallback? onViewMore}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: onViewMore,
          child: Text(
            'View More',
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalList({required double height, required Widget Function(BuildContext, int) itemBuilder}) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: itemBuilder(context, index),
          );
        },
      ),
    );
  }

  Widget _buildPreviewCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      width: 140.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.secondary, size: 28.w),
          const Spacer(),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: GoogleFonts.outfit(
              fontSize: 11.sp,
              color: Colors.grey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
