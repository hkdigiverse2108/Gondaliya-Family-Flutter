import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gondalia_family/app/modules/home/widgets/marketplace_card.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_color_scheme.dart';
import '../../../../../core/values/colors.dart';
import 'package:gondalia_family/core/values/sizes.dart';

class MarketplaceTabView extends StatefulWidget {
  const MarketplaceTabView({super.key});

  @override
  State<MarketplaceTabView> createState() => _MarketplaceTabViewState();
}

class _MarketplaceTabViewState extends State<MarketplaceTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ['All', 'Rent', 'Rent / Sale', 'Sale'];

  final List<Map<String, dynamic>> _mockListings = [
    {
      'type': 'RENT',
      'status': 'ACTIVE',
      'title': '2 BHK Fully Furnished Flat',
      'location': 'Surat • 395007',
      'date': 'From 25 May 2025',
      'price': '₹ 18,000',
      'priceUnit': 'Month',
      'contact': '98765 43210',
      'name': 'Gondaliya Family',
      'image': 'assets/images/flat1.jpg',
      'isSale': false,
    },
    {
      'type': 'RENT',
      'status': 'ACTIVE',
      'title': '1 BHK Semi Furnished Flat',
      'location': 'Surat • 394210',
      'date': 'From 10 Jun 2025',
      'price': '₹ 12,000',
      'priceUnit': 'Month',
      'contact': '91234 56789',
      'name': 'Patel Meet',
      'image': 'assets/images/flat2.jpg',
      'isSale': false,
    },
    {
      'type': 'RENT / SALE',
      'status': 'ACTIVE',
      'title': 'Shop for Rent / Sale',
      'location': 'Surat • 395010',
      'date': 'From 01 Jun 2025',
      'price': '₹ 25,000',
      'priceUnit': 'Month',
      'contact': '98980 12345',
      'name': 'Vora Hardik',
      'image': 'assets/images/shop.jpg',
      'isSale': false,
    },
    {
      'type': 'SALE',
      'status': 'ACTIVE',
      'title': 'Residential Plot for Sale',
      'location': 'Surat • 395006',
      'area': '1200 Sq.ft',
      'price': '₹ 26,00,000',
      'contact': '90123 45678',
      'name': 'Shah Dhaval',
      'image': 'assets/images/plot.jpg',
      'isSale': true,
    },
  ];

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

    return SafeArea(
      top: false,
      child: Column(
        children: [
          // Add padding to account for the transparent AppBar and status bar
          SizedBox(
            height:
                Scaffold.of(context).appBarMaxHeight ??
                (MediaQuery.of(context).padding.top + kToolbarHeight),
          ),

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

          // Tab Views (List of Items)
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs
                  .map((tabName) => _buildListing(colors, tabName))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListing(AppColorScheme colors, String category) {
    // Filter list by category if not 'All'
    final filteredList = category == 'All'
        ? _mockListings
        : _mockListings
              .where(
                (item) =>
                    item['type'] == category.toUpperCase() ||
                    (category == 'Rent / Sale' &&
                        item['type'] == 'RENT / SALE'),
              )
              .toList();

    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: AppSizes.spacingS.h),
      itemCount: filteredList.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: AppSizes.spacingM.h),
      itemBuilder: (context, index) {
        final item = filteredList[index];
        return _buildCard(colors, item);
      },
    );
  }

  Widget _buildCard(AppColorScheme colors, Map<String, dynamic> item) {
    return MarketplaceCard(
      colors: colors,
      type: item['type'],
      status: item['status'],
      title: item['title'],
      location: item['location'],
      area: item['area'],
      date: item['date'],
      price: item['price'],
      priceUnit: item['priceUnit'] ?? '',
      contact: item['contact'],
      name: item['name'],
      isSale: item['isSale'] ?? false,
      imageUrl: item['image'],
    );
  }
}
