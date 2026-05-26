import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/values/sizes.dart';
import '../../../data/models/private_message_model.dart';

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

    if (message.messageType == MessageType.give) {
      bubbleColor = isDark
          ? Colors.green.shade900.withValues(alpha: 0.25)
          : Colors.green.shade50;
      borderLeftColor = colors.secondary; // Emerald Green
      typeTag = 'GIVE';
      tagColor = colors.secondary;
    } else if (message.messageType == MessageType.take) {
      bubbleColor = isDark
          ? Colors.orange.shade900.withValues(alpha: 0.2)
          : Colors.orange.shade50;
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
                        left: BorderSide(
                          color: borderLeftColor,
                          width: 4.w,
                        ),
                      )
                    : null,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.spacingM.w,
                vertical: AppSizes.spacingS.h,
              ).copyWith(left: borderLeftColor != null ? AppSizes.spacingM.w : null),
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
                      margin: EdgeInsets.only(bottom: 4.h),
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
                  ],

                  // Message Content
                  Text(
                    message.message,
                    style: textStyle,
                  ),
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
}
