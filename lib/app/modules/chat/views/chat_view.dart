import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gondalia_family/app/global_widgets/glass_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/values/colors.dart';
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
            child: ListView.builder(
              padding: EdgeInsets.all(AppSizes.spacingL.w),
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
                    Text(
                      '32 messages remaining today',
                      style: GoogleFonts.outfit(
                        fontSize: AppSizes.fontSizeBodySmall.sp,
                        color: Colors.grey,
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
                'Member Name',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSizes.fontSizeBodySmall.sp,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              SizedBox(height: AppSizes.spacingXS.h),
            ],
            // Mode Tag
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 6.w,
                vertical: AppSizes.spacingXXS.h,
              ),
              decoration: BoxDecoration(
                color: mode == ChatMode.give
                    ? Colors.green.withValues(alpha: 0.8)
                    : Colors.orange.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(AppSizes.radiusXS.r),
              ),
              child: Text(
                mode == ChatMode.give ? 'Give' : 'Take',
                style: GoogleFonts.outfit(
                  fontSize: AppSizes.fontSizeMicro.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'This is a sample message in the general chat stream.',
              style: GoogleFonts.outfit(
                fontSize: AppSizes.fontSizeBodyMedium.sp,
                color: isMe
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black87),
              ),
            ),
            SizedBox(height: AppSizes.spacingXS.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '10:42 AM',
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
