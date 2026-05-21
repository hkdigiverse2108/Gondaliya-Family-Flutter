import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../../controllers/home_controller.dart';
import '../../../../../core/values/colors.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add padding to account for the transparent AppBar and status bar
          SizedBox(height: kToolbarHeight + 40.h),

          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Container(
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black26
                        : Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search in Gondaliya Family...',
                  hintStyle: GoogleFonts.outfit(color: colors.textSecondary),
                  prefixIcon: Icon(Icons.search_rounded, color: colors.primary),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 14.h),
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
                final categories = [
                  'Business',
                  'Jobs',
                  'Rent',
                  '2nd Hand',
                  'Seasonal',
                ];
                final icons = [
                  Icons.business,
                  Icons.work,
                  Icons.house,
                  Icons.shopping_bag,
                  Icons.eco,
                ];
                return Container(
                  width: 85.w,
                  margin: EdgeInsets.only(right: 12.w, bottom: 8.h, top: 4.h),
                  decoration: BoxDecoration(
                    color: colors.card,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black12 : Colors.grey.shade200,
                        blurRadius: 6,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icons[index],
                          color: colors.primary,
                          size: 24.w,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        categories[index],
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                        ),
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
            child: _buildSectionHeader(
              'Announcements',
              isDark,
              onViewMore: () => Get.toNamed(Routes.announcements),
            ),
          ),
          _buildHorizontalList(
            height: 140.h,
            itemBuilder: (context, index) {
              final titles = [
                'Annual Gathering',
                'Blood Donation Camp',
                'Scholarship 2026',
                'Cricket Tournament',
              ];
              final subtitles = [
                'Join us this Sunday at the community hall.',
                'Donate blood, save lives. This weekend.',
                'Apply for the Gondalia Family Scholarship.',
                'Register your team for the annual cup.',
              ];
              return _buildPreviewCard(
                title: titles[index % titles.length],
                subtitle: subtitles[index % subtitles.length],
                icon: Icons.campaign_rounded,
                colors: colors,
                iconColor: Colors.orange,
              );
            },
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _buildSectionHeader(
              'Market Place',
              isDark,
              onViewMore: () {
                if (Get.isRegistered<HomeController>()) {
                  Get.find<HomeController>().changeTab(2);
                }
              },
            ),
          ),
          _buildHorizontalList(
            height: 160.h,
            itemBuilder: (context, index) {
              final titles = [
                'Honda City 2018',
                'Office Chair',
                'MacBook Air M1',
                'Shop for Rent',
              ];
              final subtitles = [
                '₹6,50,000 • 2nd Hand',
                '₹2,500 • 2nd Hand',
                '₹55,000 • 2nd Hand',
                '₹15,000/mo • Rent',
              ];
              return _buildPreviewCard(
                title: titles[index % titles.length],
                subtitle: subtitles[index % subtitles.length],
                icon: Icons.storefront_rounded,
                colors: colors,
                iconColor: Colors.green,
              );
            },
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _buildSectionHeader(
              'General Chat',
              isDark,
              onViewMore: () => Get.toNamed(Routes.chat),
            ),
          ),
          _buildHorizontalList(
            height: 140.h,
            itemBuilder: (context, index) {
              final titles = [
                'Need a Plumber',
                'Car Pooling to Surat',
                'Best School?',
                'Looking for Job',
              ];
              final subtitles = [
                'Any reliable plumber in Varachha?',
                'Leaving tomorrow morning.',
                'Suggestions for primary school?',
                'B.Com graduate seeking accounting job.',
              ];
              return _buildPreviewCard(
                title: titles[index % titles.length],
                subtitle: subtitles[index % subtitles.length],
                icon: Icons.chat_bubble_outline_rounded,
                colors: colors,
                iconColor: colors.primary,
              );
            },
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _buildSectionHeader(
              'Parivar',
              isDark,
              onViewMore: () {
                if (Get.isRegistered<HomeController>()) {
                  Get.find<HomeController>().changeTab(1);
                }
              },
            ),
          ),
          _buildHorizontalList(
            height: 140.h,
            itemBuilder: (context, index) {
              final names = [
                'Ramesh Gondalia',
                'Suresh Gondalia',
                'Dinesh Gondalia',
                'Mahesh Gondalia',
              ];
              final profes = [
                'Business • Surat',
                'Software Eng • Pune',
                'Doctor • Ahmedabad',
                'Student • Rajkot',
              ];
              return _buildPreviewCard(
                title: names[index % names.length],
                subtitle: profes[index % profes.length],
                icon: Icons.person_outline_rounded,
                colors: colors,
                iconColor: Colors.purple,
              );
            },
          ),

          SizedBox(height: 24.h),

          // Mixed Listing Feed Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _buildSectionHeader(
              'Recent Feed',
              isDark,
              onViewMore: () {
                if (Get.isRegistered<HomeController>()) {
                  Get.find<HomeController>().changeTab(
                    2,
                  ); // Maybe route to a Feed/Market view
                }
              },
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 4,
            itemBuilder: (context, index) {
              final titles = [
                '2BHK Flat for Rent',
                'Used iPhone 13',
                'Mangoes (Seasonal)',
                'Office Space',
              ];
              final prices = [
                '₹12,000 / mo',
                '₹35,000',
                '₹800 / box',
                '₹25,000 / mo',
              ];
              final types = ['Rent', '2nd Hand', 'Seasonal', 'Rent'];

              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black12 : Colors.grey.shade200,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 70.w,
                      height: 70.w,
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        color: colors.primary,
                        size: 30.w,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  titles[index % titles.length],
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                    color: colors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.accent.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  types[index % types.length],
                                  style: GoogleFonts.outfit(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                    color: colors.accent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            prices[index % prices.length],
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              color: colors.secondary,
                              fontWeight: FontWeight.w600,
                            ),
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

  Widget _buildSectionHeader(
    String title,
    bool isDark, {
    VoidCallback? onViewMore,
  }) {
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

  Widget _buildHorizontalList({
    required double height,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 12.w, bottom: 8.h, top: 4.h),
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
    required AppColorScheme colors,
    Color? iconColor,
  }) {
    return Container(
      width: 150.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colors.isDark ? Colors.black12 : Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor ?? colors.secondary, size: 28.w),
          const Spacer(),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
              color: colors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              color: colors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
