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
          // // Give / Take Toggle
          // Container(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: AppSizes.spacingL.w,
          //     vertical: AppSizes.spacingS.h,
          //   ),
          //   color: colors.card,
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: Obx(
          //           () => GestureDetector(
          //             onTap: () => controller.chatMode.value = ChatMode.give,
          //             child: Container(
          //               padding: EdgeInsets.symmetric(
          //                 vertical: AppSizes.spacingM.h,
          //               ),
          //               decoration: BoxDecoration(
          //                 color: controller.chatMode.value == ChatMode.give
          //                     ? AppColors.primary
          //                     : Colors.transparent,
          //                 borderRadius: BorderRadius.circular(
          //                   AppSizes.radiusM.r,
          //                 ),
          //                 border: Border.all(
          //                   color: controller.chatMode.value == ChatMode.give
          //                       ? AppColors.primary
          //                       : Colors.grey.shade300,
          //                 ),
          //               ),
          //               alignment: Alignment.center,
          //               child: Text(
          //                 'Give (Offer)',
          //                 style: GoogleFonts.outfit(
          //                   fontWeight: FontWeight.bold,
          //                   color: controller.chatMode.value == ChatMode.give
          //                       ? Colors.white
          //                       : (isDark ? Colors.white : Colors.black87),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //       SizedBox(width: AppSizes.spacingM.w),
          //       Expanded(
          //         child: Obx(
          //           () => GestureDetector(
          //             onTap: () => controller.chatMode.value = ChatMode.take,
          //             child: Container(
          //               padding: EdgeInsets.symmetric(
          //                 vertical: AppSizes.spacingM.h,
          //               ),
          //               decoration: BoxDecoration(
          //                 color: controller.chatMode.value == ChatMode.take
          //                     ? AppColors.secondary
          //                     : Colors.transparent,
          //                 borderRadius: BorderRadius.circular(
          //                   AppSizes.radiusM.r,
          //                 ),
          //                 border: Border.all(
          //                   color: controller.chatMode.value == ChatMode.take
          //                       ? AppColors.secondary
          //                       : Colors.grey.shade300,
          //                 ),
          //               ),
          //               alignment: Alignment.center,
          //               child: Text(
          //                 'Take (Request)',
          //                 style: GoogleFonts.outfit(
          //                   fontWeight: FontWeight.bold,
          //                   color: controller.chatMode.value == ChatMode.take
          //                       ? Colors.white
          //                       : (isDark ? Colors.white : Colors.black87),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

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
                  return _buildMessageBubble(msg, isMe, isDark, colors);
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

                // Type Selector Toggle: "Give" | "Take"
                Obx(
                  () => Container(
                    margin: EdgeInsets.only(bottom: AppSizes.spacingM.h),
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black26 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        _buildTypeTab(
                          context: context,
                          colors: colors,
                          type: 'give',
                          label: 'Give',
                          activeColor: colors.secondary, // Green
                        ),
                        _buildTypeTab(
                          context: context,
                          colors: colors,
                          type: 'take',
                          label: 'Take',
                          activeColor: colors.goldAccent, // Orange
                        ),
                      ],
                    ),
                  ),
                ),

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
                    Obx(() {
                      final activeColor = controller.messageType.value == 'give'
                          ? colors.secondary
                          : controller.messageType.value == 'take'
                          ? colors.goldAccent
                          : colors.primary;

                      return CircleAvatar(
                        backgroundColor: activeColor,
                        radius: AppSizes.radiusXXL.r,
                        child: IconButton(
                          icon: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                          ),
                          onPressed: controller.sendMessage,
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    Chat msg,
    bool isMe,
    bool isDark,
    AppColorScheme colors,
  ) {
    final timeString = msg.createdAt != null
        ? DateFormat('hh:mm a').format(msg.createdAt!.toLocal())
        : DateFormat('hh:mm a').format(DateTime.now());

    Color bubbleColor;
    Color? borderLeftColor;
    String? typeTag;
    Color? tagColor;

    if (msg.messageType == 'give') {
      bubbleColor = isDark
          ? Colors.green.shade900.withValues(alpha: 0.25)
          : Colors.green.shade50;
      borderLeftColor = colors.secondary;
      typeTag = 'GIVE';
      tagColor = colors.secondary;
    } else if (msg.messageType == 'take') {
      bubbleColor = isDark
          ? Colors.orange.shade900.withValues(alpha: 0.2)
          : Colors.orange.shade50;
      borderLeftColor = colors.goldAccent;
      typeTag = 'TAKE';
      tagColor = colors.goldAccent;
    } else {
      bubbleColor = isMe
          ? colors.primary
          : (isDark ? Colors.grey.shade800 : Colors.grey.shade200);
    }

    final textStyle = GoogleFonts.outfit(
      fontSize: AppSizes.fontSizeBodyMedium.sp,
      fontStyle: msg.isBlocked ? FontStyle.italic : FontStyle.normal,
      color: msg.isBlocked
          ? Colors.red
          : (isMe && msg.messageType == 'text'
                ? Colors.white
                : (isDark ? Colors.white : Colors.black87)),
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: (msg.messageType == 'give' || msg.messageType == 'take') && !isMe
            ? () => controller.startPrivateChat(
                senderId: msg.senderId,
                senderName: msg.senderName ?? 'Member',
                senderAvatar: msg.senderPhoto,
              )
            : null,
        child: Container(
          margin: EdgeInsets.only(bottom: AppSizes.spacingL.h),
          constraints: BoxConstraints(maxWidth: 280.w),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.radiusL.r),
              topRight: Radius.circular(AppSizes.radiusL.r),
              bottomLeft: Radius.circular(isMe ? AppSizes.radiusL.r : 0),
              bottomRight: Radius.circular(isMe ? 0 : AppSizes.radiusL.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.radiusL.r),
              topRight: Radius.circular(AppSizes.radiusL.r),
              bottomLeft: Radius.circular(isMe ? AppSizes.radiusL.r : 0),
              bottomRight: Radius.circular(isMe ? 0 : AppSizes.radiusL.r),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: borderLeftColor != null
                    ? Border(
                        left: BorderSide(color: borderLeftColor, width: 4.w),
                      )
                    : null,
              ),
              padding:
                  EdgeInsets.symmetric(
                    horizontal: AppSizes.spacingM.w,
                    vertical: AppSizes.spacingS.h,
                  ).copyWith(
                    left: borderLeftColor != null ? AppSizes.spacingM.w : null,
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                    SizedBox(height: 4.h),
                  ],

                  if (typeTag != null && tagColor != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: tagColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            typeTag,
                            style: GoogleFonts.outfit(
                              fontSize: AppSizes.fontSizeMicro.sp,
                              fontWeight: FontWeight.bold,
                              color: tagColor,
                            ),
                          ),
                        ),
                        if (!isMe)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Tap to Chat',
                                style: GoogleFonts.outfit(
                                  fontSize: AppSizes.fontSizeMicro.sp,
                                  color: colors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                size: 12.sp,
                                color: colors.primary,
                              ),
                            ],
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                  ],

                  Text(
                    msg.isBlocked
                        ? '[Message blocked by administrator]'
                        : (msg.message ?? ''),
                    style: textStyle,
                  ),
                  SizedBox(height: 4.h),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      isMe ? '$timeString • You' : timeString,
                      style: GoogleFonts.outfit(
                        fontSize: AppSizes.fontSizeMicro.sp,
                        color: isMe && msg.messageType == 'text'
                            ? Colors.white70
                            : (isDark ? Colors.white60 : Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeTab({
    required BuildContext context,
    required AppColorScheme colors,
    required String type,
    required String label,
    required Color activeColor,
  }) {
    final isSelected = controller.messageType.value == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.messageType.value = type,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: AppSizes.fontSizeBodyMedium.sp,
              color: isSelected
                  ? Colors.white
                  : (colors.isDark ? Colors.white70 : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}
