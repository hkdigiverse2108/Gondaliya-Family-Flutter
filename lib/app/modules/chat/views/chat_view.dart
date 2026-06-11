import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../global_widgets/glass_app_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../global_widgets/full_screen_image_viewer.dart';

import '../../../../core/values/colors.dart';
import '../../../data/models/chat.dart';
import '../controllers/chat_controller.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/values/sizes.dart';
import '../../../../core/config/app_config.dart';

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
              return Obx(() {
                final loadingMore = controller.isLoadingMore.value;
                final itemCount =
                    controller.messages.length + (loadingMore ? 1 : 0);
                return ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.all(AppSizes.spacingL.w),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    // Show spinner at the top while loading older messages
                    if (loadingMore && index == 0) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSizes.spacingM.h,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16.w,
                                height: 16.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Loading older messages...',
                                style: GoogleFonts.outfit(
                                  fontSize: AppSizes.fontSizeCaption.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    final msgIndex = loadingMore ? index - 1 : index;
                    final msg = controller.messages[msgIndex];
                    final isMe = msg.senderId == controller.currentUserId;
                    return _buildMessageBubble(msg, isMe, isDark, colors);
                  },
                );
              });
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

                // Attachment Preview (if picked)
                Obx(() {
                  if (controller.pickedFilePath.value == null) {
                    return const SizedBox.shrink();
                  }
                  final isImg = controller.pickedFileType.value == 'IMAGE';
                  return Container(
                    margin: EdgeInsets.only(bottom: AppSizes.spacingM.h),
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black26 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (isImg)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.file(
                              File(controller.pickedFilePath.value!),
                              width: 50.r,
                              height: 50.r,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          CircleAvatar(
                            radius: 25.r,
                            backgroundColor: Colors.red.withValues(alpha: 0.1),
                            child: Icon(
                              Icons.picture_as_pdf_rounded,
                              color: Colors.red,
                              size: 28.r,
                            ),
                          ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.pickedFileName.value ?? 'Attachment',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppSizes.fontSizeBodyMedium.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                _formatBytes(controller.pickedFileSize.value),
                                style: GoogleFonts.outfit(
                                  fontSize: AppSizes.fontSizeBodySmall.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.cancel_rounded,
                            color: Colors.grey,
                          ),
                          onPressed: controller.clearAttachment,
                        ),
                      ],
                    ),
                  );
                }),

                // Input Field
                Row(
                  children: [
                    Obx(() {
                      if (controller.isUploading.value) {
                        return IconButton(
                          icon: const Icon(Icons.attach_file_rounded),
                          onPressed: null,
                          color: Colors.grey.withValues(alpha: 0.5),
                        );
                      }
                      return PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.attach_file_rounded,
                          color: AppColors.primary,
                        ),
                        onSelected: (value) {
                          if (value == 'image') {
                            controller.pickImage();
                          } else if (value == 'pdf') {
                            controller.pickDocument();
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(
                            value: 'image',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.image_rounded,
                                  color: Colors.blue,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text('image'.tr, style: GoogleFonts.outfit()),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'pdf',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.picture_as_pdf_rounded,
                                  color: Colors.red,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'pdf_document'.tr,
                                  style: GoogleFonts.outfit(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                    Expanded(
                      child: Obx(
                        () => TextField(
                          controller: controller.messageController,
                          enabled: !controller.isUploading.value,
                          decoration: InputDecoration(
                            hintText: controller.isUploading.value
                                ? 'uploading'.tr
                                : 'Type a message...',
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
                    ),
                    SizedBox(width: AppSizes.spacingS.w),
                    Obx(() {
                      final activeColor = controller.messageType.value == 'give'
                          ? colors.secondary
                          : controller.messageType.value == 'take'
                          ? colors.goldAccent
                          : colors.primary;

                      if (controller.isUploading.value) {
                        return CircleAvatar(
                          backgroundColor: activeColor.withValues(alpha: 0.5),
                          radius: AppSizes.radiusXXL.r,
                          child: const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }

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
    Gradient? bubbleGradient;

    if (msg.messageType == 'give') {
      bubbleColor = Colors.transparent;
      bubbleGradient = LinearGradient(
        colors: isDark
            ? [
                Colors.green.shade900.withValues(alpha: 0.45),
                Colors.green.shade900.withValues(alpha: 0.15),
              ]
            : [
                Colors.green.shade50,
                Colors.green.shade100.withValues(alpha: 0.5),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      borderLeftColor = colors.secondary;
      typeTag = 'GIVE';
      tagColor = colors.secondary;
    } else if (msg.messageType == 'take') {
      bubbleColor = Colors.transparent;
      bubbleGradient = LinearGradient(
        colors: isDark
            ? [
                Colors.orange.shade900.withValues(alpha: 0.45),
                Colors.orange.shade900.withValues(alpha: 0.15),
              ]
            : [
                Colors.orange.shade50,
                Colors.orange.shade100.withValues(alpha: 0.5),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
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
            color: bubbleGradient == null ? bubbleColor : null,
            gradient: bubbleGradient,
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
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: msg.messageType == 'give'
                                  ? [
                                      colors.secondary,
                                      colors.secondary.withValues(alpha: 0.85),
                                    ]
                                  : [
                                      colors.goldAccent,
                                      colors.goldAccent.withValues(alpha: 0.85),
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: tagColor.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                msg.messageType == 'give'
                                    ? Icons.volunteer_activism_rounded
                                    : Icons.handshake_rounded,
                                color: Colors.white,
                                size: 12.sp,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                typeTag,
                                style: GoogleFonts.outfit(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                  ],

                  if (msg.isBlocked)
                    Text('[Message blocked by administrator]', style: textStyle)
                  else ...[
                    // Render attachment if present
                    if (msg.mediaUrl != null && msg.mediaUrl!.isNotEmpty) ...[
                      if (msg.mediaType == 'IMAGE')
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => FullScreenImageViewer(
                                imageUrls: [_resolveUrl(msg.mediaUrl!)],
                                initialIndex: 0,
                              ),
                            );
                          },
                          child: Container(
                            width: 180.w,
                            height: 180.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : Colors.black.withValues(alpha: 0.08),
                                width: 1.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14.5.r),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    _resolveUrl(msg.mediaUrl!),
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Container(
                                        color: isDark
                                            ? Colors.black26
                                            : Colors.grey.shade100,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                progress.expectedTotalBytes !=
                                                    null
                                                ? progress.cumulativeBytesLoaded /
                                                      progress
                                                          .expectedTotalBytes!
                                                : null,
                                            strokeWidth: 2.r,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: isDark
                                            ? Colors.black26
                                            : Colors.grey.shade100,
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image_outlined,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // Glassmorphic Zoom Overlay
                                  Positioned(
                                    right: 8.r,
                                    bottom: 8.r,
                                    child: Container(
                                      padding: EdgeInsets.all(6.r),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(
                                          alpha: 0.6,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                          width: 1,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.zoom_in_rounded,
                                        color: Colors.white,
                                        size: 18.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else if (msg.mediaType == 'FILE')
                        GestureDetector(
                          onTap: () async {
                            final uri = Uri.parse(_resolveUrl(msg.mediaUrl!));
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : (isDark
                                        ? Colors.white.withValues(alpha: 0.05)
                                        : Colors.white),
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              border: Border.all(
                                color: isMe
                                    ? Colors.white.withValues(alpha: 0.15)
                                    : (isDark
                                          ? Colors.white.withValues(alpha: 0.08)
                                          : Colors.grey.shade300),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Colors.redAccent, Colors.red],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red.withValues(
                                          alpha: 0.2,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.picture_as_pdf_rounded,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getFileName(msg.mediaUrl!),
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                          color:
                                              isMe && msg.messageType == 'text'
                                              ? Colors.white
                                              : (isDark
                                                    ? Colors.white
                                                    : Colors.black87),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        _formatBytes(msg.fileSize),
                                        style: GoogleFonts.outfit(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              isMe && msg.messageType == 'text'
                                              ? Colors.white70
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                CircleAvatar(
                                  radius: 16.r,
                                  backgroundColor: isMe
                                      ? Colors.white.withValues(alpha: 0.2)
                                      : colors.primary.withValues(alpha: 0.1),
                                  child: Icon(
                                    Icons.download_for_offline_rounded,
                                    size: 20.sp,
                                    color: isMe ? Colors.white : colors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (msg.message != null && msg.message!.isNotEmpty)
                        SizedBox(height: 8.h),
                    ],
                    if (msg.message != null && msg.message!.isNotEmpty)
                      Text(msg.message!, style: textStyle),
                  ],

                  if ((msg.messageType == 'give' ||
                          msg.messageType == 'take') &&
                      !isMe) ...[
                    SizedBox(height: 12.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: msg.messageType == 'give'
                              ? [
                                  colors.secondary,
                                  colors.secondary.withValues(alpha: 0.9),
                                ]
                              : [
                                  colors.goldAccent,
                                  colors.goldAccent.withValues(alpha: 0.9),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: tagColor!.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.send_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'DM Member',
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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

  String _resolveUrl(String? url) {
    if (url == null || url.isEmpty || url == 'null') return '';
    if (url.startsWith('/uploads')) {
      return '${AppConfig.baseUrl}$url';
    }
    if (url.contains('localhost:5000')) {
      return url.replaceAll('http://localhost:5000', AppConfig.baseUrl);
    }
    if (url.contains('127.0.0.1:5000')) {
      return url.replaceAll('http://127.0.0.1:5000', AppConfig.baseUrl);
    }
    return url;
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    final i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  String _getFileName(String url) {
    try {
      final uri = Uri.parse(url);
      return Uri.decodeComponent(uri.pathSegments.last);
    } catch (e) {
      return 'Document.pdf';
    }
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
