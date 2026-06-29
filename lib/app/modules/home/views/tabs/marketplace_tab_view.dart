import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_color_scheme.dart';
import '../../../../../core/values/sizes.dart';

import '../../controllers/marketplace_controller.dart';
import '../../widgets/marketplace_card.dart';
import '../../../../../core/utils/time_utils.dart';
import 'package:get/get.dart';
import '../../../../data/models/listing.dart';
import '../../../../global_widgets/glass_app_bar.dart';
import '../../../../routes/app_pages.dart';

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
    // final controller = Get.find<MarketplaceController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const GlassAppBar(
        titleText: 'Marketplace',
        centerTitle: false,
        // bottom: TabBar(
        //   controller: _tabController,
        //   tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        //   labelStyle: GoogleFonts.outfit(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 14.sp,
        //   ),
        //   unselectedLabelStyle: GoogleFonts.outfit(
        //     fontWeight: FontWeight.w500,
        //     fontSize: 14.sp,
        //   ),
        //   labelColor: colors.primary,
        //   unselectedLabelColor: colors.textSecondary,
        //   indicatorColor: colors.primary,
        //   indicatorSize: TabBarIndicatorSize.tab,
        //   dividerColor: Colors.transparent,
        // ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingL.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 60.sp,
                color: colors.textSecondary,
              ),
              SizedBox(height: AppSizes.spacingM.h),
              Text(
                'Comming sone',
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
      // body: TabBarView(
      //   controller: _tabController,
      //   children: _tabs.map((tab) {
      //     return _buildListing(colors, tab, controller);
      //   }).toList(),
      // ),
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
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.spacingS.h,
          horizontal: 0,
        ),
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
        '${l.availableFrom.day} ${TimeUtils.getMonthName(l.availableFrom.month)} ${l.availableFrom.year}';

    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.listingDetail, arguments: {'listing': l});
      },
      child: MarketplaceCard(
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
      ),
    );
  }
}
