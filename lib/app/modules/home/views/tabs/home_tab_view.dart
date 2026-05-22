import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../../controllers/home_controller.dart';
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
          SizedBox(
            height:
                Scaffold.of(context).appBarMaxHeight ??
                (MediaQuery.of(context).padding.top + kToolbarHeight),
          ),

          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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

          SizedBox(height: 16.h),

          // Highlights / Stories Section (Announcements, Marketplace, Chat, Parivar)
          _buildStoriesSection(colors),

          SizedBox(height: 20.h),

          // Categories Filter Chips
          _buildCategoriesChips(colors),

          SizedBox(height: 24.h),

          // Main Social Feed
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Feed',
              style: GoogleFonts.outfit(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: 12.h),

          _buildFeedList(colors),

          SizedBox(height: 80.h), // Padding for bottom nav and FAB
        ],
      ),
    );
  }

  Widget _buildStoriesSection(AppColorScheme colors) {
    final stories = [
      {
        'title': 'Announcements',
        'icon': Icons.campaign_rounded,
        'color': Colors.orange,
        'route': Routes.announcements,
      },
      {
        'title': 'Market Place',
        'icon': Icons.storefront_rounded,
        'color': Colors.green,
        'tab': 2,
      },
      {
        'title': 'Parivar',
        'icon': Icons.people_rounded,
        'color': Colors.purple,
        'tab': 1,
      },
      {
        'title': 'Chat',
        'icon': Icons.chat_bubble_rounded,
        'color': colors.primary,
        'route': Routes.chat,
      },
    ];

    return SizedBox(
      height: 95.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return GestureDetector(
            onTap: () {
              if (story.containsKey('route')) {
                Get.toNamed(story['route'] as String);
              } else if (story.containsKey('tab')) {
                if (Get.isRegistered<HomeController>()) {
                  Get.find<HomeController>().changeTab(story['tab'] as int);
                }
              }
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: Column(
                children: [
                  Container(
                    width: 65.w,
                    height: 65.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          (story['color'] as Color).withValues(alpha: 0.7),
                          (story['color'] as Color),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (story['color'] as Color).withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(3.w), // White border effect
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.card,
                        ),
                        child: Icon(
                          story['icon'] as IconData,
                          color: story['color'] as Color,
                          size: 28.w,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    story['title'] as String,
                    style: GoogleFonts.outfit(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoriesChips(AppColorScheme colors) {
    final categories = [
      'All',
      'Business',
      'Jobs',
      'Rent',
      '2nd Hand',
      'Seasonal',
    ];

    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == 0; // Dummy logic for now

          return Container(
            margin: EdgeInsets.only(right: 12.w),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? colors.primary : colors.card,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected ? colors.primary : colors.divider,
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                categories[index],
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : colors.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeedList(AppColorScheme colors) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 24.h),
          decoration: BoxDecoration(
            color: colors.card,
            border: Border(
              bottom: BorderSide(
                color: colors.divider.withValues(alpha: 0.5),
                width: 4.h,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: colors.primary.withValues(alpha: 0.2),
                      child: Icon(Icons.person, color: colors.primary),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Name $index',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                              color: colors.textPrimary,
                            ),
                          ),
                          Text(
                            '${index + 1} hours ago',
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.more_horiz_rounded,
                        color: colors.textSecondary,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Post Content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'This is a sample post content. It could be an announcement, a marketplace listing, or someone asking for a job recommendation. Engaging content goes here!',
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    color: colors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Post Media (Optional, but included for dummy data)
              if (index % 2 == 0)
                Container(
                  width: double.infinity,
                  height: 200.h,
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 48.w,
                      color: colors.primary.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              if (index % 2 == 0) SizedBox(height: 16.h),

              // Post Footer (Like, Comment, Share)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildActionButton(
                          Icons.favorite_border_rounded,
                          'Like',
                          colors,
                        ),
                        SizedBox(width: 20.w),
                        _buildActionButton(
                          Icons.mode_comment_outlined,
                          'Comment',
                          colors,
                        ),
                      ],
                    ),
                    _buildActionButton(Icons.share_outlined, 'Share', colors),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    AppColorScheme colors,
  ) {
    return Row(
      children: [
        Icon(icon, size: 22.w, color: colors.textSecondary),
        SizedBox(width: 6.w),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
