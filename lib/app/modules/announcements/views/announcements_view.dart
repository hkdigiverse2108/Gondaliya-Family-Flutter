import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gondalia_family/app/data/models/announcement.dart';
import 'package:gondalia_family/app/global_widgets/glass_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/announcements_controller.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/values/sizes.dart';
import 'package:gondalia_family/core/utils/time_utils.dart';

class AnnouncementsView extends GetView<AnnouncementsController> {
  const AnnouncementsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(titleText: 'Announcements', centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value && controller.announcements.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.announcements.isEmpty) {
          return Center(
            child: Text(
              'No announcements yet',
              style: GoogleFonts.outfit(
                fontSize: AppSizes.fontSizeBodyLarge.sp,
                color: colors.textSecondary,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshAnnouncements,
          color: colors.primary,
          child: ListView.separated(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              top:
                  MediaQuery.of(context).padding.top +
                  kToolbarHeight +
                  AppSizes.spacingL.h,
              left: AppSizes.spacingL.w,
              right: AppSizes.spacingL.w,
              bottom: AppSizes.spacingL.h + 100.h,
            ),
            itemCount:
                controller.announcements.length +
                (controller.isLoadMore.value ? 1 : 0),
            separatorBuilder: (context, index) =>
                SizedBox(height: AppSizes.spacingL.h),
            itemBuilder: (context, index) {
              if (index == controller.announcements.length) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.spacingM.w),
                    child: const CircularProgressIndicator(),
                  ),
                );
              }

              final announcement = controller.announcements[index];
              final hasImage =
                  announcement.imageUrl != null &&
                  announcement.imageUrl!.isNotEmpty;

              return AnnouncementCard(
                announcement: announcement,
                colors: colors,
                isDark: isDark,
                hasImage: hasImage,
              );
            },
          ),
        );
      }),
    );
  }
}

class AnnouncementCard extends StatefulWidget {
  final Announcement announcement;
  final AppColorScheme colors;
  final bool isDark;
  final bool hasImage;
  final bool isExpandable;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    required this.colors,
    required this.isDark,
    required this.hasImage,
    this.isExpandable = true,
  });

  @override
  State<AnnouncementCard> createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends State<AnnouncementCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final hasImage = widget.announcement.imageUrl != null &&
        widget.announcement.imageUrl!.trim().isNotEmpty;

    return GestureDetector(
      onTap: widget.isExpandable
          ? () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        margin: EdgeInsets.only(bottom: AppSizes.spacingL.h),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: widget.colors.card,
          borderRadius: BorderRadius.circular(AppSizes.radiusXL.r),
          boxShadow: widget.colors.neumorphicShadow(blur: 15, distance: 4),
          border: Border.all(
            color: Colors.white.withValues(alpha: widget.isDark ? 0.05 : 0.6),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expandable Image Section
            if (hasImage)
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity, height: 0),
                secondChild: Image.network(
                  widget.announcement.imageUrl!,
                  height: 220.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 220.h,
                      width: double.infinity,
                      color: widget.colors.primary.withValues(alpha: 0.05),
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: widget.colors.primary.withValues(alpha: 0.3),
                        size: 60.r,
                      ),
                    );
                  },
                ),
                crossFadeState: (!widget.isExpandable || _isExpanded)
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 400),
                sizeCurve: Curves.easeInOutCubic,
              ),

            // Card Content
            Padding(
              padding: EdgeInsets.only(
                top: AppSizes.spacingL.w,
                left: AppSizes.spacingL.w,
                right: AppSizes.spacingL.w,
                bottom: widget.isExpandable
                    ? AppSizes.spacingXXS.w
                    : AppSizes.spacingL.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Author & Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'By Committee', // Or widget.announcement.createdBy if you have user resolution
                        style: GoogleFonts.outfit(
                          fontSize: AppSizes.fontSizeCaption.sp,
                          color: widget.colors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        TimeUtils.getTimeAgo(widget.announcement.createdAt),
                        style: GoogleFonts.outfit(
                          fontSize: AppSizes.fontSizeCaption.sp,
                          color: widget.colors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.spacingM.h),

                  // Title
                  Text(
                    widget.announcement.title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: AppSizes.fontSizeTitleSmall.sp,
                      color: widget.colors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: AppSizes.spacingM.h),

                  // Description
                  AnimatedCrossFade(
                    firstChild: Text(
                      widget.announcement.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: AppSizes.fontSizeBodyMedium.sp,
                        color: widget.colors.textPrimary.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                    ),
                    secondChild: Text(
                      widget.announcement.description,
                      style: GoogleFonts.outfit(
                        fontSize: AppSizes.fontSizeBodyMedium.sp,
                        color: widget.colors.textPrimary.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    crossFadeState: (!widget.isExpandable || _isExpanded)
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 400),
                    sizeCurve: Curves.easeInOutCubic,
                  ),
                ],
              ),
            ),

            // Read More Button (Bottom Right Aligned)
            if (widget.isExpandable)
              Align(
                alignment: Alignment.bottomRight,
                child: AnimatedCrossFade(
                  firstChild: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = true;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spacingXL.w,
                        vertical: AppSizes.spacingM.h,
                      ),
                      decoration: BoxDecoration(
                        color: widget
                            .colors
                            .primary, // The red/accent color from the design
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppSizes.radiusXL.r),
                          bottomRight: Radius.circular(AppSizes.radiusXL.r),
                        ),
                      ),
                      child: Text(
                        'Read more',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: AppSizes.fontSizeBodySmall.sp,
                        ),
                      ),
                    ),
                  ),
                  secondChild: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spacingXL.w,
                        vertical: AppSizes.spacingM.h,
                      ),
                      decoration: BoxDecoration(
                        color: widget.colors.card,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppSizes.radiusXL.r),
                          bottomRight: Radius.circular(AppSizes.radiusXL.r),
                        ),
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withValues(
                              alpha: widget.isDark ? 0.05 : 0.6,
                            ),
                            width: 1.5,
                          ),
                          left: BorderSide(
                            color: Colors.white.withValues(
                              alpha: widget.isDark ? 0.05 : 0.6,
                            ),
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: Text(
                        'Show less',
                        style: GoogleFonts.outfit(
                          color: widget.colors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: AppSizes.fontSizeBodySmall.sp,
                        ),
                      ),
                    ),
                  ),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 400),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
