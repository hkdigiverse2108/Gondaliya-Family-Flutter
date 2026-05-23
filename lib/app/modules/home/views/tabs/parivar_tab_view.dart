import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/values/colors.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/values/sizes.dart';

class ParivarTabView extends StatefulWidget {
  const ParivarTabView({super.key});

  @override
  State<ParivarTabView> createState() => _ParivarTabViewState();
}

class _ParivarTabViewState extends State<ParivarTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        SizedBox(
          height:
              Scaffold.of(context).appBarMaxHeight ??
              (MediaQuery.of(context).padding.top + kToolbarHeight),
        ),
        // Village Tabs
        Container(
          color: colors.card,
          child: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: colors.textSecondary,
            labelStyle: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: AppSizes.fontSizeBodyMedium.sp,
            ),
            tabs: const [
              Tab(text: 'Village 1'),
              Tab(text: 'Village 2'),
              Tab(text: 'Village 3'),
            ],
          ),
        ),

        // Search Bar
        Padding(
          padding: EdgeInsets.all(AppSizes.spacingL.w),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search by Name, Profession, or City...',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: isDark ? AppColors.cardDark : Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // Tab Views (List of Members)
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildMemberList(colors, 'Village 1'),
              _buildMemberList(colors, 'Village 2'),
              _buildMemberList(colors, 'Village 3'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMemberList(AppColorScheme colors, String villageName) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.spacingL.w,
        vertical: AppSizes.spacingS.h,
      ),
      itemCount: 10,
      separatorBuilder: (context, index) =>
          SizedBox(height: AppSizes.spacingM.h),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(AppSizes.spacingL.w),
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
              CircleAvatar(
                radius: 28.r,
                backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
                child: Icon(
                  Icons.person_rounded,
                  color: AppColors.primary,
                  size: AppSizes.radius3XL.r,
                ),
              ),
              SizedBox(width: AppSizes.spacingL.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Member Name $index',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: AppSizes.fontSizeBodyLarge.sp,
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingXS.h),
                    Row(
                      children: [
                        Icon(
                          Icons.work_outline,
                          size: AppSizes.fontSizeBodyMedium.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(width: AppSizes.spacingXS.w),
                        Text(
                          'Profession $index',
                          style: GoogleFonts.outfit(
                            fontSize: AppSizes.fontSizeBodySmall.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.spacingXXS.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: AppSizes.fontSizeBodyMedium.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(width: AppSizes.spacingXS.w),
                        Text(
                          '$villageName - City',
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
              IconButton(
                icon: const Icon(Icons.phone_rounded, color: Colors.green),
                onPressed: () {
                  // Make call
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
