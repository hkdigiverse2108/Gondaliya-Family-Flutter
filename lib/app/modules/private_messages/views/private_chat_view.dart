import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/values/sizes.dart';
import '../controllers/private_chat_controller.dart';
import '../widgets/private_message_bubble.dart';

class PrivateChatView extends GetView<PrivateChatController> {
  const PrivateChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          final other = controller.otherUser.value;
          final otherName = other?.name ?? 'Chat';
          final initials = otherName.isNotEmpty
              ? otherName
                    .split(' ')
                    .map((l) => l[0])
                    .take(2)
                    .join()
                    .toUpperCase()
              : '?';

          return Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: colors.primary.withValues(alpha: 0.1),
                child: Text(
                  initials,
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
              ),
              SizedBox(width: AppSizes.spacingM.w),
              Expanded(
                child: Text(
                  otherName,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: AppSizes.fontSizeBodyLarge.sp,
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        }),
      ),
      body: Column(
        children: [
          // Message List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.messages.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.messages.isEmpty) {
                return Center(
                  child: Text(
                    'No messages yet. Say hello!',
                    style: GoogleFonts.outfit(color: colors.textSecondary),
                  ),
                );
              }

              final listCount =
                  controller.messages.length +
                  (controller.isLoadingMore.value ? 1 : 0);

              return ListView.builder(
                controller: controller.scrollController,
                reverse: true, // Show newest at the bottom
                padding: EdgeInsets.all(AppSizes.spacingL.w),
                itemCount: listCount,
                itemBuilder: (context, index) {
                  // Render a loading spinner at the top of the reversed list
                  if (index == controller.messages.length) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  final msg = controller.messages[index];
                  final isMe = msg.senderId == controller.currentUserId;
                  return PrivateMessageBubble(message: msg, isMe: isMe);
                },
              );
            }),
          ),

          // Message Input Area
          Container(
            padding: EdgeInsets.all(AppSizes.spacingL.w).copyWith(
              bottom:
                  AppSizes.spacingL.w + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: colors.card,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text Input and Send Button
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.messageController,
                        maxLines: 4,
                        minLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          filled: true,
                          fillColor: isDark
                              ? Colors.black26
                              : Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.r),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppSizes.spacingL.w,
                            vertical: AppSizes.spacingM.h,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSizes.spacingS.w),
                    CircleAvatar(
                      backgroundColor: colors.primary,
                      radius: 24.r,
                      child: IconButton(
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                        onPressed: controller.sendMessage,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
