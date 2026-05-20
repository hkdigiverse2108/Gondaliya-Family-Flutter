import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/values/colors.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'General Chat',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => GestureDetector(
                    onTap: () => controller.chatMode.value = ChatMode.give,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: controller.chatMode.value == ChatMode.give
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12.r),
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
                  )),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Obx(() => GestureDetector(
                    onTap: () => controller.chatMode.value = ChatMode.take,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: controller.chatMode.value == ChatMode.take
                            ? AppColors.secondary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12.r),
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
                  )),
                ),
              ],
            ),
          ),

          // Message List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: 5,
              itemBuilder: (context, index) {
                final isMe = index % 2 == 0;
                final mode = index % 3 == 0 ? ChatMode.take : ChatMode.give;
                return _buildMessageBubble(isMe, isDark, mode);
              },
            ),
          ),

          // Input Area
          Container(
            padding: EdgeInsets.all(16.w).copyWith(bottom: 16.w + MediaQuery.of(context).padding.bottom),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
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
                    Text(
                      '32 messages remaining today',
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Reset at Midnight',
                      style: GoogleFonts.outfit(
                        fontSize: 10.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
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
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          filled: true,
                          fillColor: isDark ? Colors.black26 : Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.r),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 24.r,
                      child: IconButton(
                        icon: const Icon(Icons.send_rounded, color: Colors.white),
                        onPressed: () {},
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

  Widget _buildMessageBubble(bool isMe, bool isDark, ChatMode mode) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        constraints: BoxConstraints(maxWidth: 280.w),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isMe
              ? AppColors.primary
              : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(isMe ? 16.r : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) ...[
              Text(
                'Member Name',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              SizedBox(height: 4.h),
            ],
            // Mode Tag
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: mode == ChatMode.give ? Colors.green.withValues(alpha: 0.8) : Colors.orange.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                mode == ChatMode.give ? 'Give' : 'Take',
                style: GoogleFonts.outfit(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'This is a sample message in the general chat stream.',
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                color: isMe ? Colors.white : (isDark ? Colors.white : Colors.black87),
              ),
            ),
            SizedBox(height: 4.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '10:42 AM',
                style: GoogleFonts.outfit(
                  fontSize: 10.sp,
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
