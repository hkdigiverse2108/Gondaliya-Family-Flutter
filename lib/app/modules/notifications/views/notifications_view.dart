import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../data/models/notification_model.dart';
import '../../../global_widgets/glass_app_bar.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/time_utils.dart';
import '../../../../core/values/sizes.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        titleText: 'Notifications',
        centerTitle: true,
        actions: [
          Obx(() {
            if (controller.unreadCount == 0) return const SizedBox.shrink();
            return IconButton(
              tooltip: 'Mark all as read',
              icon: controller.isMarkingAllRead.value
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.primary,
                      ),
                    )
                  : Icon(
                      PhosphorIcons.checks(),
                      color: colors.primary,
                      size: 22.w,
                    ),
              onPressed: controller.isMarkingAllRead.value
                  ? null
                  : controller.markAllAsRead,
            );
          }),
          SizedBox(width: 4.w),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return _buildEmptyState(colors);
        }

        return RefreshIndicator(
          onRefresh: controller.refreshNotifications,
          color: colors.primary,
          child: ListView.builder(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              top:
                  MediaQuery.of(context).padding.top +
                  kToolbarHeight +
                  AppSizes.spacingM.h,
              left: AppSizes.spacingL.w,
              right: AppSizes.spacingL.w,
              bottom: AppSizes.spacingXXL.h + 80.h,
            ),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              // Show a date header when the date changes
              final showDateHeader =
                  index == 0 ||
                  !_isSameDay(
                    controller.notifications[index - 1].createdAt,
                    notification.createdAt,
                  );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showDateHeader)
                    _buildDateHeader(notification.createdAt, colors),
                  _NotificationCard(notification: notification, colors: colors),
                  SizedBox(height: AppSizes.spacingM.h),
                ],
              );
            },
          ),
        );
      }),
    );
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildDateHeader(DateTime? date, AppColorScheme colors) {
    if (date == null) return const SizedBox.shrink();
    final now = DateTime.now();
    String label;
    if (_isSameDay(date, now)) {
      label = 'Today';
    } else if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      label = 'Yesterday';
    } else {
      label = '${date.day} ${TimeUtils.getMonthName(date.month)} ${date.year}';
    }
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSizes.spacingM.h,
        top: AppSizes.spacingS.h,
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: AppSizes.fontSizeCaption.sp,
          fontWeight: FontWeight.w700,
          color: colors.textSecondary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppColorScheme colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88.w,
            height: 88.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.card,
              boxShadow: colors.neumorphicShadow(blur: 18, distance: 6),
            ),
            child: Center(
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: colors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Icon(
                  PhosphorIcons.bellSlash(),
                  color: Colors.white,
                  size: 38.w,
                ),
              ),
            ),
          ),
          SizedBox(height: AppSizes.spacingXL.h),
          Text(
            'No Notifications',
            style: GoogleFonts.outfit(
              fontSize: AppSizes.fontSizeTitleSmall.sp,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.spacingS.h),
          Text(
            "You're all caught up!\nNew notifications will appear here.",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: AppSizes.fontSizeBodyMedium.sp,
              color: colors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final AppColorScheme colors;

  const _NotificationCard({required this.notification, required this.colors});

  IconData _iconForType(String type) {
    switch (type.toLowerCase()) {
      case 'announcement':
        return PhosphorIcons.megaphone();
      case 'message':
      case 'chat':
        return PhosphorIcons.chatCircle();
      case 'job':
      case 'listing':
        return PhosphorIcons.briefcase();
      case 'family':
        return PhosphorIcons.users();
      case 'business':
        return PhosphorIcons.buildings();
      default:
        return PhosphorIcons.bell();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = colors.isDark;
    final isUnread = !notification.isRead;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(AppSizes.spacingL.w),
      decoration: BoxDecoration(
        color: isUnread
            ? colors.primary.withValues(alpha: isDark ? 0.08 : 0.05)
            : colors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusXL.r),
        boxShadow: colors.neumorphicShadow(
          blur: isUnread ? 12 : 8,
          distance: isUnread ? 4 : 2,
        ),
        border: Border.all(
          color: isUnread
              ? colors.primary.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: isDark ? 0.05 : 0.6),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon badge
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isUnread
                  ? LinearGradient(
                      colors: colors.primaryGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isUnread ? null : colors.primary.withValues(alpha: 0.1),
            ),
            child: Center(
              child: Icon(
                _iconForType(notification.type),
                color: isUnread
                    ? Colors.white
                    : colors.primary.withValues(alpha: 0.7),
                size: 20.w,
              ),
            ),
          ),
          SizedBox(width: AppSizes.spacingM.w),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: GoogleFonts.outfit(
                          fontSize: AppSizes.fontSizeBodyMedium.sp,
                          fontWeight: isUnread
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: colors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8.w,
                        height: 8.w,
                        margin: EdgeInsets.only(top: 4.h, left: 6.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: colors.primaryGradient,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: AppSizes.spacingXS.h),
                Text(
                  notification.body,
                  style: GoogleFonts.outfit(
                    fontSize: AppSizes.fontSizeBodySmall.sp,
                    color: colors.textSecondary,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSizes.spacingXS.h),
                Text(
                  TimeUtils.getTimeAgo(notification.createdAt),
                  style: GoogleFonts.outfit(
                    fontSize: AppSizes.fontSizeCaption.sp,
                    color: colors.primary.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
