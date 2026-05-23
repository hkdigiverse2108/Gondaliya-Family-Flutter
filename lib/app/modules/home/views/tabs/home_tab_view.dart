import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/models/enums.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:gondalia_family/app/global_widgets/neomorphic_text_field.dart';
import '../../widgets/verified_businesses_section.dart';
import '../../widgets/marketplace_section.dart';
import '../../widgets/community_square_section.dart';
import 'package:gondalia_family/core/values/sizes.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
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

            // Total Data Counters
            // _buildStatsCounters(colors),
            // SizedBox(height: AppSizes.spacingL.h),

            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingL.w),
              child: NeomorphicTextField(
                hintText: 'Search in Gondaliya Family...',
                prefixIcon: Icon(
                  PhosphorIcons.magnifyingGlass(),
                  color: colors.accent,
                ),
              ),
            ),

            SizedBox(height: AppSizes.spacingL.h),

            _buildStoriesSection(colors),

            SizedBox(height: 18.h),

            _buildSectionHeader('Verified Businesses', 'See all', colors),
            SizedBox(height: AppSizes.spacingM.h),
            VerifiedBusinessesSection(colors: colors),

            SizedBox(height: AppSizes.spacingXXL.h),

            _buildSectionHeader('Hot on the Marketplace', 'See all', colors),
            SizedBox(height: AppSizes.spacingM.h),
            MarketplaceSection(colors: colors),

            _buildSectionHeader('The Community Square', 'See all', colors),
            SizedBox(height: AppSizes.spacingM.h),
            CommunitySquareSection(colors: colors),
          ],
        ),
      ),
    );
  }

  // Widget _buildStatsCounters(AppColorScheme colors) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingL.w, vertical: AppSizes.spacingS.h),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: _buildStatCard(
  //             'Active Members',
  //             '1,240',
  //             PhosphorIcons.users(PhosphorIconsStyle.fill),
  //             colors,
  //           ),
  //         ),
  //         SizedBox(width: AppSizes.spacingM.w),
  //         Expanded(
  //           child: _buildStatCard(
  //             'Businesses',
  //             '350',
  //             PhosphorIcons.briefcase(PhosphorIconsStyle.fill),
  //             colors,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildStatCard(
  //   String label,
  //   String count,
  //   IconData icon,
  //   AppColorScheme colors,
  // ) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingL.w, vertical: AppSizes.spacingM.h),
  //     decoration: BoxDecoration(
  //       color: colors.card,
  //       borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
  //       border: Border.all(
  //         color: colors.primary.withValues(alpha: 0.1),
  //         width: 1,
  //       ),
  //       boxShadow: colors.neumorphicShadow(blur: 6, distance: 2),
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           padding: EdgeInsets.all(AppSizes.spacingS.w),
  //           decoration: BoxDecoration(
  //             color: colors.primary.withValues(alpha: 0.1),
  //             shape: BoxShape.circle,
  //           ),
  //           child: ShaderMask(
  //             shaderCallback: (bounds) => LinearGradient(
  //               colors: colors.primaryGradient,
  //               begin: Alignment.topLeft,
  //               end: Alignment.bottomRight,
  //             ).createShader(bounds),
  //             child: Icon(icon, color: Colors.white, size: AppSizes.spacingXXL.w),
  //           ),
  //         ),
  //         SizedBox(width: AppSizes.spacingM.w),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 count,
  //                 style: GoogleFonts.outfit(
  //                   fontSize: 18.sp,
  //                   fontWeight: FontWeight.bold,
  //                   color: colors.textPrimary,
  //                 ),
  //               ),
  //               Text(
  //                 label,
  //                 style: GoogleFonts.outfit(
  //                   fontSize: AppSizes.fontSizeCaption.sp,
  //                   fontWeight: FontWeight.w500,
  //                   color: colors.textSecondary,
  //                 ),
  //                 maxLines: 1,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'IT & Software':
        return PhosphorIcons.desktop();
      case 'Accounting & Finance':
        return PhosphorIcons.calculator();
      case 'Sales & Marketing':
        return PhosphorIcons.trendUp();
      case 'Office & Administration':
        return PhosphorIcons.buildings();
      case 'Medical & Healthcare':
        return PhosphorIcons.firstAid();
      case 'Education & Training':
        return PhosphorIcons.graduationCap();
      case 'Engineering':
        return PhosphorIcons.hardHat();
      case 'Hotel & Restaurant':
        return PhosphorIcons.forkKnife();
      case 'Retail & Shopping':
        return PhosphorIcons.shoppingCart();
      case 'Automobile':
        return PhosphorIcons.car();
      case 'Beauty & Fashion':
        return PhosphorIcons.scissors();
      case 'Labour & Helper':
        return PhosphorIcons.users();
      case 'Security & Housekeeping':
        return PhosphorIcons.shield();
      case 'Delivery & Logistics':
        return PhosphorIcons.package();
      case 'Construction & Real Estate':
        return PhosphorIcons.crane();
      case 'Media & Entertainment':
        return PhosphorIcons.camera();
      case 'Agriculture & Farming':
        return PhosphorIcons.plant();
      case 'Freelance & Part Time':
        return PhosphorIcons.laptop();
      case 'Customer Support':
        return PhosphorIcons.headset();
      default:
        return PhosphorIcons.briefcase();
    }
  }

  Widget _buildStoriesSection(AppColorScheme colors) {
    final categories = AppEnums.jobCategories.keys.toList();

    return SizedBox(
      height: 98.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingL.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final categoryName = categories[index];
          final icon = _getCategoryIcon(categoryName);

          return GestureDetector(
            onTap: () {
              // TODO: Navigate or filter by category
            },
            child: Padding(
              padding: EdgeInsets.only(right: AppSizes.spacingXL.w),
              child: SizedBox(
                width: 70.w,
                child: Column(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.card,
                        boxShadow: colors.neumorphicShadow(
                          blur: 8,
                          distance: 3,
                        ),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: colors.primaryGradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Icon(icon, color: Colors.white, size: 28.w),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.spacingXS.h),
                    Text(
                      categoryName,
                      style: GoogleFonts.outfit(
                        fontSize: AppSizes.fontSizeMicro.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    String actionText,
    AppColorScheme colors,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingL.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              actionText,
              style: GoogleFonts.outfit(
                fontSize: AppSizes.fontSizeBodyMedium.sp,
                fontWeight: FontWeight.w600,
                color: colors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
