import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/values/colors.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';

class ParivarTabView extends StatefulWidget {
  const ParivarTabView({super.key});

  @override
  State<ParivarTabView> createState() => _ParivarTabViewState();
}

class _ParivarTabViewState extends State<ParivarTabView> with SingleTickerProviderStateMixin {
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
        // Village Tabs
        Container(
          color: colors.card,
          child: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: colors.textSecondary,
            labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14.sp),
            tabs: const [
              Tab(text: 'Village 1'),
              Tab(text: 'Village 2'),
              Tab(text: 'Village 3'),
            ],
          ),
        ),

        // Search Bar
        Padding(
          padding: EdgeInsets.all(16.w),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search by Name, Profession, or City...',
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: 10,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: colors.card,
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
              CircleAvatar(
                radius: 28.r,
                backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
                child: Icon(Icons.person_rounded, color: AppColors.primary, size: 32.r),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Member Name $index',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.work_outline, size: 14.sp, color: Colors.grey),
                        SizedBox(width: 4.w),
                        Text(
                          'Profession $index',
                          style: GoogleFonts.outfit(fontSize: 12.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14.sp, color: Colors.grey),
                        SizedBox(width: 4.w),
                        Text(
                          '$villageName - City',
                          style: GoogleFonts.outfit(fontSize: 12.sp, color: Colors.grey),
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
