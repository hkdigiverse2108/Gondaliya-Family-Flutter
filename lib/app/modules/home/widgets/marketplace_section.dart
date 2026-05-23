import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/utils/time_utils.dart';
import '../controllers/home_controller.dart';
import 'marketplace_card.dart';

class MarketplaceSection extends StatelessWidget {
  final AppColorScheme colors;

  const MarketplaceSection({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (controller) {
        final listings = controller.listings;

        if (listings.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Center(
              child: Text(
                'No marketplace listings yet.',
                style: GoogleFonts.outfit(color: colors.textSecondary),
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: listings.length,
          itemBuilder: (context, index) {
            final l = listings[index];
            final availableDateStr =
                "${l.availableFrom.day} ${TimeUtils.getMonthName(l.availableFrom.month)} ${l.availableFrom.year}";

            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
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
          },
        );
      },
    );
  }
}
