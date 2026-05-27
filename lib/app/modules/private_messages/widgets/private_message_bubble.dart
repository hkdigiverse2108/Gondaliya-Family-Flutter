import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/values/sizes.dart';
import '../../../data/models/private_message_model.dart';
import '../../../../app/global_widgets/full_screen_image_viewer.dart';
import 'package:gondalia_family/core/config/app_config.dart';

class PrivateMessageBubble extends StatelessWidget {
  final PrivateMessage message;
  final bool isMe;
  final VoidCallback? onTap;

  const PrivateMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    final timeString = message.createdAt != null
        ? DateFormat('hh:mm a').format(message.createdAt!.toLocal())
        : DateFormat('hh:mm a').format(DateTime.now());

    // Compute distinct background and border styles based on message type
    Color bubbleColor;
    Color? borderLeftColor;
    String? typeTag;
    Color? tagColor;
    Gradient? bubbleGradient;

    if (message.messageType == MessageType.give) {
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
      borderLeftColor = colors.secondary; // Emerald Green
      typeTag = 'GIVE';
      tagColor = colors.secondary;
    } else if (message.messageType == MessageType.take) {
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
      borderLeftColor = colors.goldAccent; // Amber/Orange Accent
      typeTag = 'TAKE';
      tagColor = colors.goldAccent;
    } else {
      // Standard Text
      bubbleColor = isMe
          ? colors.primary
          : (isDark ? Colors.grey.shade800 : Colors.grey.shade200);
    }

    final textStyle = GoogleFonts.outfit(
      fontSize: AppSizes.fontSizeBodyMedium.sp,
      color: isMe && message.messageType == MessageType.text
          ? Colors.white
          : (isDark ? Colors.white : Colors.black87),
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap,
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
                  // Sender name (only for received messages)
                  if (!isMe && message.senderName != null) ...[
                    Text(
                      message.senderName!,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: AppSizes.fontSizeBodySmall.sp,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],

                  // Give/Take Tag Indicator
                  if (typeTag != null && tagColor != null) ...[
                    Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: message.messageType == MessageType.give
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
                            message.messageType == MessageType.give
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

                  // Message Content
                  if (message.mediaUrl != null &&
                      message.mediaUrl!.isNotEmpty) ...[
                    if (message.mediaType == 'IMAGE')
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => FullScreenImageViewer(
                              imageUrls: [_resolveUrl(message.mediaUrl!)],
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
                                  _resolveUrl(message.mediaUrl!),
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
                                                    progress.expectedTotalBytes!
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
                    else if (message.mediaType == 'FILE')
                      GestureDetector(
                        onTap: () async {
                          final uri = Uri.parse(_resolveUrl(message.mediaUrl!));
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
                                      color: Colors.red.withValues(alpha: 0.2),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getFileName(message.mediaUrl!),
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                        color:
                                            isMe &&
                                                message.messageType ==
                                                    MessageType.text
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
                                      _formatBytes(message.fileSize),
                                      style: GoogleFonts.outfit(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            isMe &&
                                                message.messageType ==
                                                    MessageType.text
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
                    if (message.message != null && message.message!.isNotEmpty)
                      SizedBox(height: 8.h),
                  ],
                  if (message.message != null && message.message!.isNotEmpty)
                    Text(message.message!, style: textStyle),
                  SizedBox(height: 4.h),

                  // Timestamp
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      isMe ? '$timeString • You' : timeString,
                      style: GoogleFonts.outfit(
                        fontSize: AppSizes.fontSizeMicro.sp,
                        color: isMe && message.messageType == MessageType.text
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
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = (log(bytes) / log(1024)).floor();
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
}
