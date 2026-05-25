import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/values/sizes.dart';

// Comments: Unused imports commented out to preserve them for the next update
/*
import 'package:gondalia_family/app/modules/home/controllers/marketplace_controller.dart';
import 'package:gondalia_family/app/modules/home/widgets/marketplace_card.dart';
import 'package:gondalia_family/core/utils/time_utils.dart';
import 'package:get/get.dart';
import '../../../../data/models/listing.dart';
import 'package:gondalia_family/app/routes/app_pages.dart';
*/

class MarketplaceTabView extends StatefulWidget {
  const MarketplaceTabView({super.key});

  @override
  State<MarketplaceTabView> createState() => _MarketplaceTabViewState();
}

class _MarketplaceTabViewState extends State<MarketplaceTabView>
    with SingleTickerProviderStateMixin {
  // Comments: State logic and tabs commented out to preserve for the next update
  /*
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
  */

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingXL.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.15),
                    width: 2,
                  ),
                ),
                child: Icon(
                  PhosphorIcons.storefront(PhosphorIconsStyle.fill),
                  color: colors.primary,
                  size: 48.sp,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Coming Soon',
                style: GoogleFonts.outfit(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'This feature is going to be added in the next update.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  color: colors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Comments: Card and listing builders commented out to preserve them for the next update
  /*
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
  */
}
