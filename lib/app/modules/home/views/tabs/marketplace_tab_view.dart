import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/values/colors.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';

class MarketplaceTabView extends StatefulWidget {
  const MarketplaceTabView({super.key});

  @override
  State<MarketplaceTabView> createState() => _MarketplaceTabViewState();
}

class _MarketplaceTabViewState extends State<MarketplaceTabView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    return Column(
      children: [
        // Add padding to account for the transparent AppBar and status bar
        SizedBox(height: Scaffold.of(context).appBarMaxHeight ?? (MediaQuery.of(context).padding.top + kToolbarHeight)),
        // Tabs
        Container(
          color: colors.card,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: colors.textSecondary,
            labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14.sp),
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Rent'),
              Tab(text: 'Seasonal'),
              Tab(text: '2nd Hand'),
            ],
          ),
        ),

        // Filter & Search Bar
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search marketplace...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: isDark ? AppColors.cardDark : Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(Icons.filter_list_rounded, color: AppColors.primary),
              ),
            ],
          ),
        ),

        // Tab Views (List of Items)
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildListing(colors, 'All'),
              _buildListing(colors, 'Rent'),
              _buildListing(colors, 'Seasonal'),
              _buildListing(colors, '2nd Hand'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListing(AppColorScheme colors, String category) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: 10,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final isSponsored = index == 0 && category == 'All'; // Mock sponsored highlight

        return Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(16.r),
            border: isSponsored ? Border.all(color: AppColors.secondary, width: 2) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item Image Placeholder
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.image_outlined, color: Colors.grey, size: 40.r),
              ),
              SizedBox(width: 16.w),
              
              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isSponsored)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        margin: EdgeInsets.only(bottom: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Sponsored',
                          style: GoogleFonts.outfit(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    Text(
                      '$category Item $index',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '₹${(index + 1) * 500}',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    
                    // Star Rating
                    Row(
                      children: [
                        Icon(Icons.star_rounded, color: Colors.amber, size: 16.sp),
                        Icon(Icons.star_rounded, color: Colors.amber, size: 16.sp),
                        Icon(Icons.star_rounded, color: Colors.amber, size: 16.sp),
                        Icon(Icons.star_rounded, color: Colors.amber, size: 16.sp),
                        Icon(Icons.star_half_rounded, color: Colors.amber, size: 16.sp),
                        SizedBox(width: 4.w),
                        Text(
                          '4.5 (24)',
                          style: GoogleFonts.outfit(fontSize: 12.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
