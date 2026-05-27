import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/values/sizes.dart';
import '../../../global_widgets/glass_app_bar.dart';
import '../controllers/private_messages_controller.dart';
import '../widgets/conversation_tile.dart';

class PrivateMessagesView extends GetView<PrivateMessagesController> {
  const PrivateMessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;
    final RxString searchQuery = ''.obs;

    return Scaffold(
      backgroundColor: colors.background,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: GlassAppBar(
          titleText: 'Direct Messages',
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: colors.textPrimary),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      body: Stack(
        children: [
          // 1. Luxury ambient aura glows
          Positioned(
            top: -120.h,
            left: -80.w,
            child: Container(
              width: 300.w,
              height: 300.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colors.primary.withValues(alpha: isDark ? 0.12 : 0.16),
                    colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 60.h,
            right: -100.w,
            child: Container(
              width: 320.w,
              height: 320.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colors.accent.withValues(alpha: isDark ? 0.08 : 0.14),
                    colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 2. Main content list
          Column(
            children: [
              SizedBox(
                height:
                    kToolbarHeight +
                    MediaQuery.of(context).padding.top +
                    AppSizes.spacingS.h,
              ),
              Obx(() {
                if (controller.conversations.isNotEmpty) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSizes.spacingL.w,
                      AppSizes.spacingS.h,
                      AppSizes.spacingL.w,
                      AppSizes.spacingM.h,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.08),
                          width: 1.5,
                        ),
                        boxShadow: colors.neumorphicShadow(
                          blur: 10,
                          distance: 2,
                        ),
                      ),
                      child: TextField(
                        onChanged: (val) => searchQuery.value = val.trim(),
                        decoration: InputDecoration(
                          hintText: 'search_conversations'.tr.isEmpty
                              ? 'Search conversations...'
                              : 'search_conversations'.tr,
                          hintStyle: GoogleFonts.outfit(
                            color: colors.textSecondary.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(
                            PhosphorIcons.magnifyingGlass(
                              PhosphorIconsStyle.bold,
                            ),
                            color: colors.primary,
                            size: 18.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        style: GoogleFonts.outfit(
                          color: colors.textPrimary,
                          fontSize: AppSizes.fontSizeBodyMedium.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.conversations.isEmpty) {
                    return _buildShimmerLoading(context, colors);
                  }

                  final query = searchQuery.value.toLowerCase();
                  final filteredList = query.isEmpty
                      ? controller.conversations
                      : controller.conversations.where((c) {
                          return c.otherUser.name.toLowerCase().contains(
                                query,
                              ) ||
                              (c.lastMessage?.toLowerCase().contains(query) ??
                                  false);
                        }).toList();

                  if (filteredList.isEmpty) {
                    return _buildEmptyState(context, colors, query.isNotEmpty);
                  }

                  return RefreshIndicator(
                    onRefresh: controller.fetchConversations,
                    color: colors.primary,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spacingL.w,
                        vertical: AppSizes.spacingS.h,
                      ).copyWith(bottom: 80.h),
                      itemCount: filteredList.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: AppSizes.spacingM.h),
                      itemBuilder: (context, index) {
                        final convo = filteredList[index];
                        return ConversationTile(
                          conversation: convo,
                          onTap: () => Get.toNamed(
                            '/private-chat/${convo.conversationId}',
                            arguments: {'otherUser': convo.otherUser},
                          ),
                          onDelete: () => controller.deleteConversation(
                            convo.conversationId,
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     controller.loadSelectableUsers();
      //     _showNewChatBottomSheet(context, colors);
      //   },
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   highlightElevation: 0,
      //   child: Container(
      //     width: 56.r,
      //     height: 56.r,
      //     decoration: BoxDecoration(
      //       shape: BoxShape.circle,
      //       gradient: LinearGradient(
      //         colors: colors.primaryGradient,
      //         begin: Alignment.topLeft,
      //         end: Alignment.bottomRight,
      //       ),
      //       boxShadow: [
      //         BoxShadow(
      //           color: colors.primary.withValues(alpha: 0.4),
      //           blurRadius: 16,
      //           offset: const Offset(0, 6),
      //         ),
      //       ],
      //     ),
      //     child: Icon(
      //       PhosphorIcons.chatCircleText(PhosphorIconsStyle.fill),
      //       color: Colors.white,
      //       size: 26.sp,
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildShimmerLoading(BuildContext context, AppColorScheme colors) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.spacingL.w,
        vertical: AppSizes.spacingM.h,
      ),
      itemCount: 6,
      separatorBuilder: (context, index) =>
          SizedBox(height: AppSizes.spacingM.h),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: colors.isDark ? Colors.grey[800]! : Colors.grey[300]!,
          highlightColor: colors.isDark ? Colors.grey[700]! : Colors.grey[100]!,
          child: Container(
            height: 84.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    AppColorScheme colors,
    bool isSearching,
  ) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingXXL.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.spacingXXL.r),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.08),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  isSearching
                      ? PhosphorIcons.magnifyingGlass()
                      : PhosphorIcons.chatCircleDots(),
                  color: colors.primary.withValues(alpha: 0.5),
                  size: 60.w,
                ),
              ),
              SizedBox(height: AppSizes.spacingXL.h),
              Text(
                isSearching ? 'No results found' : 'No Messages Yet',
                style: GoogleFonts.outfit(
                  fontSize: AppSizes.fontSizeTitleSmall.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.spacingS.h),
              Text(
                isSearching
                    ? 'We couldn\'t find any conversations matching your search.'
                    : 'Start a private conversation with family members or village heads.',
                style: GoogleFonts.outfit(
                  fontSize: AppSizes.fontSizeBodyMedium.sp,
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              if (!isSearching) ...[
                SizedBox(height: AppSizes.spacingXL.h),
                InkWell(
                  onTap: () {
                    controller.loadSelectableUsers();
                    _showNewChatBottomSheet(context, colors);
                  },
                  borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: colors.primaryGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radiusM.r),
                      boxShadow: [
                        BoxShadow(
                          color: colors.primary.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          PhosphorIcons.chatCircle(PhosphorIconsStyle.bold),
                          color: Colors.white,
                          size: 18.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Start Chat',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: AppSizes.fontSizeBodySmall.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showNewChatBottomSheet(BuildContext context, AppColorScheme colors) {
    Get.bottomSheet(
      Container(
        height: 600.h,
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusXL.r),
          ),
          border: Border.all(
            color: colors.primary.withValues(alpha: 0.08),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: AppSizes.spacingM.h),
            // Bottom sheet drag handle
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: AppSizes.spacingL.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingL.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New Message',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      color: colors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: colors.textSecondary,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Glassy member search bar
            Padding(
              padding: EdgeInsets.all(AppSizes.spacingL.w),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: controller.userSearchController,
                  onChanged: (val) => controller.filterUsers(val),
                  decoration: InputDecoration(
                    hintText: 'Search members or villages...',
                    hintStyle: GoogleFonts.outfit(
                      color: colors.textSecondary.withValues(alpha: 0.5),
                    ),
                    prefixIcon: Icon(
                      PhosphorIcons.magnifyingGlass(),
                      color: colors.primary,
                      size: 20.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  style: GoogleFonts.outfit(
                    color: colors.textPrimary,
                    fontSize: AppSizes.fontSizeBodyMedium.sp,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isUsersLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        SizedBox(height: AppSizes.spacingM.h),
                        Text(
                          'Loading directory...',
                          style: GoogleFonts.outfit(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.filteredUsers.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spacingXL.w,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            PhosphorIcons.userMinus(),
                            color: colors.textSecondary.withValues(alpha: 0.6),
                            size: 48.w,
                          ),
                          SizedBox(height: AppSizes.spacingM.h),
                          Text(
                            'No members found',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Try entering a different name or village.',
                            style: GoogleFonts.outfit(
                              color: colors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.all(AppSizes.spacingL.w).copyWith(top: 0),
                  itemCount: controller.filteredUsers.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final u = controller.filteredUsers[index];
                    final initials = u.name.isNotEmpty
                        ? u.name
                              .trim()
                              .split(' ')
                              .map((l) => l[0])
                              .take(2)
                              .join()
                              .toUpperCase()
                        : '?';

                    return ListTile(
                      onTap: () {
                        Get.back();
                        controller.startNewChat(u);
                      },
                      leading: Container(
                        width: 44.r,
                        height: 44.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.primary.withValues(alpha: 0.08),
                          border: Border.all(
                            color: colors.primary.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        u.name,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                          fontSize: AppSizes.fontSizeBodyMedium.sp,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Icon(
                            PhosphorIcons.mapPin(),
                            color: colors.accent,
                            size: 12.sp,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              '${u.village} • ${u.relation.tr}',
                              style: GoogleFonts.outfit(
                                color: colors.textSecondary,
                                fontSize: AppSizes.fontSizeCaption.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(
                        PhosphorIcons.paperPlaneRight(),
                        color: colors.primary.withValues(alpha: 0.7),
                        size: 16.sp,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
