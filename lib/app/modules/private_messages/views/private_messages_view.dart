import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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

    return Scaffold(
      backgroundColor: colors.background,
      appBar: GlassAppBar(
        titleText: 'Direct Messages',
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.conversations.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.fetchConversations,
          color: colors.primary,
          child: controller.conversations.isEmpty
              ? _buildEmptyState(colors)
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.spacingL.w,
                    vertical: AppSizes.spacingM.h,
                  ),
                  itemCount: controller.conversations.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: AppSizes.spacingS.h),
                  itemBuilder: (context, index) {
                    final convo = controller.conversations[index];
                    return ConversationTile(
                      conversation: convo,
                      onTap: () => Get.toNamed(
                        '/private-chat/${convo.conversationId}',
                        arguments: {'otherUser': convo.otherUser},
                      ),
                      onDelete: () =>
                          controller.deleteConversation(convo.conversationId),
                    );
                  },
                ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openUserPicker(context, colors),
        backgroundColor: colors.primary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusXL.r),
        ),
        child: Icon(PhosphorIcons.plus(), color: Colors.white, size: 24.w),
      ),
    );
  }

  Widget _buildEmptyState(AppColorScheme colors) {
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
                ),
                child: Icon(
                  PhosphorIcons.chatCircleDots(),
                  color: colors.primary.withValues(alpha: 0.5),
                  size: 64.w,
                ),
              ),
              SizedBox(height: AppSizes.spacingXL.h),
              Text(
                'No Messages Yet',
                style: GoogleFonts.outfit(
                  fontSize: AppSizes.fontSizeTitleSmall.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.spacingS.h),
              Text(
                'Start a private conversation with family members or village heads.',
                style: GoogleFonts.outfit(
                  fontSize: AppSizes.fontSizeBodyMedium.sp,
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.spacingXL.h),
            ],
          ),
        ),
      ),
    );
  }

  void _openUserPicker(BuildContext context, AppColorScheme colors) {
    // Fetch selectable users when bottom sheet is opened
    controller.loadSelectableUsers();

    Get.bottomSheet(
      Container(
        height: 0.8.sh,
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          children: [
            // Handle Bar
            Container(
              margin: EdgeInsets.symmetric(vertical: AppSizes.spacingM.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colors.textSecondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingL.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New Conversation',
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Get.back(),
                    color: colors.textSecondary,
                  ),
                ],
              ),
            ),

            // Search Box
            Padding(
              padding: EdgeInsets.all(AppSizes.spacingL.w),
              child: TextField(
                controller: controller.userSearchController,
                onChanged: controller.filterUsers,
                decoration: InputDecoration(
                  hintText: 'Search by name or village...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: colors.isDark
                      ? Colors.black26
                      : Colors.grey.shade100,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: AppSizes.spacingM.w,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Users List
            Expanded(
              child: Obx(() {
                if (controller.isUsersLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredUsers.isEmpty) {
                  return Center(
                    child: Text(
                      'No members found.',
                      style: GoogleFonts.outfit(color: colors.textSecondary),
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.only(
                    left: AppSizes.spacingL.w,
                    right: AppSizes.spacingL.w,
                    bottom: AppSizes.spacingXXL.h,
                  ),
                  itemCount: controller.filteredUsers.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final user = controller.filteredUsers[index];
                    final initials = user.name.isNotEmpty
                        ? user.name
                              .split(' ')
                              .map((l) => l[0])
                              .take(2)
                              .join()
                              .toUpperCase()
                        : '?';

                    return ListTile(
                      onTap: () {
                        Get.back(); // Dismiss bottom sheet
                        controller.startNewChat(user);
                      },
                      contentPadding: EdgeInsets.symmetric(
                        vertical: AppSizes.spacingS.h,
                        horizontal: AppSizes.spacingS.w,
                      ),
                      leading: CircleAvatar(
                        radius: 22.r,
                        backgroundColor: colors.primary.withValues(alpha: 0.1),
                        child: Text(
                          initials,
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: colors.primary,
                          ),
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w600,
                          fontSize: AppSizes.fontSizeBodyLarge.sp,
                          color: colors.textPrimary,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 12.sp,
                            color: colors.textSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            user.village,
                            style: GoogleFonts.outfit(
                              fontSize: AppSizes.fontSizeCaption.sp,
                              color: colors.textSecondary,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            width: 3.w,
                            height: 3.h,
                            decoration: BoxDecoration(
                              color: colors.textSecondary.withValues(
                                alpha: 0.5,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              user.relation,
                              style: GoogleFonts.outfit(
                                fontSize: AppSizes.fontSizeCaption.sp,
                                color: colors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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
      barrierColor: Colors.black.withValues(alpha: 0.5),
    );
  }
}
