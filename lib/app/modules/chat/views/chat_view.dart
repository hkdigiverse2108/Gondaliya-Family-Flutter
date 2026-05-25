import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gondalia_family/app/global_widgets/glass_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/values/colors.dart';
import '../../../data/models/chat.dart';
import '../controllers/chat_controller.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';
import 'package:gondalia_family/core/values/sizes.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    return Scaffold(
      appBar: GlassAppBar(
        titleText: 'General Chat',
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              // Show info about 32 message cap
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Give / Take Toggle
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.spacingL.w,
              vertical: AppSizes.spacingS.h,
            ),
            color: colors.card,
            child: Row(
              children: [
                Expanded(
                  child: Obx(
                    () => GestureDetector(
                      onTap: () => controller.chatMode.value = ChatMode.give,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSizes.spacingM.h,
                        ),
                        decoration: BoxDecoration(
                          color: controller.chatMode.value == ChatMode.give
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusM.r,
                          ),
                          border: Border.all(
                            color: controller.chatMode.value == ChatMode.give
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Give (Offer)',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            color: controller.chatMode.value == ChatMode.give
                                ? Colors.white
                                : (isDark ? Colors.white : Colors.black87),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.spacingM.w),
                Expanded(
                  child: Obx(
                    () => GestureDetector(
                      onTap: () => controller.chatMode.value = ChatMode.take,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSizes.spacingM.h,
                        ),
                        decoration: BoxDecoration(
                          color: controller.chatMode.value == ChatMode.take
                              ? AppColors.secondary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusM.r,
                          ),
                          border: Border.all(
                            color: controller.chatMode.value == ChatMode.take
                                ? AppColors.secondary
                                : Colors.grey.shade300,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Take (Request)',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            color: controller.chatMode.value == ChatMode.take
                                ? Colors.white
                                : (isDark ? Colors.white : Colors.black87),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Message List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.messages.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.messages.isEmpty) {
                return Center(
                  child: Text(
                    'No messages yet. Start the conversation!',
                    style: GoogleFonts.outfit(color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
                controller: controller.scrollController,
                padding: EdgeInsets.all(AppSizes.spacingL.w),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  final isMe = msg.senderId == controller.currentUserId;
                  return _buildMessageBubble(msg, isMe, isDark);
                },
              );
            }),
          ),

          // Input Area
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
              children: [
                // Counter info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text(
                        '${controller.remainingMessages.value} messages remaining today',
                        style: GoogleFonts.outfit(
                          fontSize: AppSizes.fontSizeBodySmall.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Text(
                      'Reset at Midnight',
                      style: GoogleFonts.outfit(
                        fontSize: AppSizes.fontSizeMicro.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.spacingS.h),
                // Input Field
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.attach_file_rounded),
                      onPressed: () {
                        // Media picker
                      },
                      color: AppColors.primary,
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller.messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          filled: true,
                          fillColor: isDark
                              ? Colors.black26
                              : Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusXXL.r,
                            ),
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
                      backgroundColor: AppColors.primary,
                      radius: AppSizes.radiusXXL.r,
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

  Widget _buildMessageBubble(Chat msg, bool isMe, bool isDark) {
    final timeString = msg.createdAt != null
        ? DateFormat('hh:mm a').format(msg.createdAt!.toLocal())
        : DateFormat('hh:mm a').format(DateTime.now());

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: AppSizes.spacingL.h),
        constraints: BoxConstraints(maxWidth: 280.w),
        padding: EdgeInsets.all(AppSizes.spacingM.w),
        decoration: BoxDecoration(
          color: isMe
              ? AppColors.primary
              : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSizes.radiusL.r),
            topRight: Radius.circular(AppSizes.radiusL.r),
            bottomLeft: Radius.circular(isMe ? AppSizes.radiusL.r : 0),
            bottomRight: Radius.circular(isMe ? 0 : AppSizes.radiusL.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) ...[
              Text(
                msg.senderName ??
                    'Member #${msg.senderId.length > 4 ? msg.senderId.substring(msg.senderId.length - 4) : msg.senderId}',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSizes.fontSizeBodySmall.sp,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              SizedBox(height: AppSizes.spacingXS.h),
            ],
            // Message Content
            Text(
              msg.isBlocked
                  ? '[Message blocked by administrator]'
                  : (msg.message ?? ''),
              style: GoogleFonts.outfit(
                fontSize: AppSizes.fontSizeBodyMedium.sp,
                fontStyle: msg.isBlocked ? FontStyle.italic : FontStyle.normal,
                color: msg.isBlocked
                    ? Colors.red
                    : (isMe
                          ? Colors.white
                          : (isDark ? Colors.white : Colors.black87)),
              ),
            ),
            SizedBox(height: AppSizes.spacingXS.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                isMe ? '$timeString • You' : timeString,
                style: GoogleFonts.outfit(
                  fontSize: AppSizes.fontSizeMicro.sp,
                  color: isMe ? Colors.white70 : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
