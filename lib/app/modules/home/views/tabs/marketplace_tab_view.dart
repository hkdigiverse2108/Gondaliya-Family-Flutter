import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gondalia_family/app/modules/home/controllers/marketplace_controller.dart';
import 'package:gondalia_family/app/modules/home/widgets/marketplace_card.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_color_scheme.dart';
import '../../../../../core/values/colors.dart';
import 'package:gondalia_family/core/values/sizes.dart';
import 'package:gondalia_family/core/utils/time_utils.dart';
import 'package:get/get.dart';
import '../../../../data/models/listing.dart';

class MarketplaceTabView extends StatefulWidget {
  const MarketplaceTabView({super.key});

  @override
  State<MarketplaceTabView> createState() => _MarketplaceTabViewState();
}

class _MarketplaceTabViewState extends State<MarketplaceTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ['All', 'Rent', 'Rent / Sale', 'Sale'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final controller = Get.find<MarketplaceController>();

    return SafeArea(
      child: Column(
        children: [
          // Filter Chips & Button
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.spacingL.w,
              vertical: AppSizes.spacingS.h,
            ),
            child: Row(
              children: [
                ...List.generate(_tabs.length, (index) {
                  final isSelected = index == _tabController.index;
                  return Padding(
                    padding: EdgeInsets.only(right: AppSizes.spacingS.w),
                    child: GestureDetector(
                      onTap: () {
                        _tabController.animateTo(index);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.spacingL.w,
                          vertical: AppSizes.spacingS.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusXL.r,
                          ),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : (colors.isDark
                                      ? AppColors.dividerDark
                                      : Colors.grey.shade300),
                          ),
                        ),
                        child: Text(
                          _tabs[index],
                          style: GoogleFonts.outfit(
                            color: isSelected
                                ? Colors.white
                                : (colors.isDark
                                      ? Colors.grey.shade300
                                      : Colors.grey.shade700),
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            fontSize: AppSizes.fontSizeBodySmall.sp,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(width: AppSizes.spacingS.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: AppSizes.spacingS.h,
                  ),
                  decoration: BoxDecoration(
                    color: colors.isDark
                        ? AppColors.cardDark
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(AppSizes.radiusXL.r),
                    border: Border.all(
                      color: colors.isDark
                          ? AppColors.dividerDark
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.filter_alt_outlined,
                        size: AppSizes.fontSizeBodyLarge.sp,
                        color: colors.isDark
                            ? Colors.grey.shade300
                            : Colors.grey.shade700,
                      ),
                      SizedBox(width: AppSizes.spacingXS.w),
                      Text(
                        'Filter',
                        style: GoogleFonts.outfit(
                          color: colors.isDark
                              ? Colors.grey.shade300
                              : Colors.grey.shade700,
                          fontSize: AppSizes.fontSizeBodySmall.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs
                  .map((tabName) => _buildListing(colors, tabName, controller))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListing(
    AppColorScheme colors,
    String category,
    MarketplaceController controller,
  ) {
    return Obx(() {
      final listings = controller.listings;
      final filteredList = category == 'All'
          ? listings
          : listings
                .where(
                  (item) =>
                      item.type.toUpperCase() == category.toUpperCase() ||
                      (category == 'Rent / Sale' &&
                          item.type.toUpperCase() == 'RENT / SALE'),
                )
                .toList();

      if (filteredList.isEmpty) {
        return Center(
          child: Text(
            'No marketplace listings yet.',
            style: GoogleFonts.outfit(color: colors.textSecondary),
          ),
        );
      }

      return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: AppSizes.spacingS.h),
        itemCount: filteredList.length,
        separatorBuilder: (context, index) =>
            SizedBox(height: AppSizes.spacingM.h),
        itemBuilder: (context, index) {
          final l = filteredList[index];
          return _buildCard(colors, l);
        },
      );
    });
  }

  Widget _buildCard(AppColorScheme colors, Listing l) {
    final availableDateStr =
        "${l.availableFrom.day} ${TimeUtils.getMonthName(l.availableFrom.month)} ${l.availableFrom.year}";

    return MarketplaceCard(
      colors: colors,
      type: l.type,
      status: l.status,
      title: l.title,
      location: '${l.location.city} • ${l.location.pincode}',
      area: l.description,
      date: 'From $availableDateStr',
      price: '₹ ${l.price}',
      priceUnit: l.priceUnit == 'FIXED' ? 'Total' : l.priceUnit,
      contact: l.contactPhone,
      name: l.postedBy,
      isSale: l.type.toUpperCase() == 'SALE',
      imageUrl: l.photos?.isNotEmpty == true ? l.photos!.first : null,
    );
  }
}
