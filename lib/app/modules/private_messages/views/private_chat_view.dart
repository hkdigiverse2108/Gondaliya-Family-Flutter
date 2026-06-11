import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/values/sizes.dart';
import '../controllers/private_chat_controller.dart';
import '../widgets/private_message_bubble.dart';
import '../../../../core/config/app_config.dart';

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
          onPressed: Get.back,
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
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primary.withValues(alpha: 0.1),
                ),
                child: ClipOval(
                  child: (other?.avatar != null &&
                          other!.avatar!.isNotEmpty &&
                          other.avatar != 'null')
                      ? Image.network(
                          _resolveUrl(other.avatar!),
                          width: 36.r,
                          height: 36.r,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Text(
                              initials,
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: colors.primary,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            initials,
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                            ),
                          ),
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
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
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
                            child: Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 28.r),
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
                          icon: const Icon(Icons.cancel_rounded, color: Colors.grey),
                          onPressed: controller.clearAttachment,
                        ),
                      ],
                    ),
                  );
                }),

                // Text Input and Send Button
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
                        icon: Icon(Icons.attach_file_rounded, color: colors.primary),
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
                                Icon(Icons.image_rounded, color: Colors.blue, size: 20.sp),
                                SizedBox(width: 8.w),
                                Text('image'.tr, style: GoogleFonts.outfit()),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'pdf',
                            child: Row(
                              children: [
                                Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 20.sp),
                                SizedBox(width: 8.w),
                                Text('pdf_document'.tr, style: GoogleFonts.outfit()),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                    Expanded(
                      child: Obx(() => TextField(
                        controller: controller.messageController,
                        enabled: !controller.isUploading.value,
                        maxLines: 4,
                        minLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: controller.isUploading.value
                              ? 'uploading'.tr
                              : 'Type a message...',
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
                      )),
                    ),
                    SizedBox(width: AppSizes.spacingS.w),
                    Obx(() {
                      if (controller.isUploading.value) {
                        return CircleAvatar(
                          backgroundColor: colors.primary.withValues(alpha: 0.5),
                          radius: 24.r,
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
                        backgroundColor: colors.primary,
                        radius: 24.r,
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
}
