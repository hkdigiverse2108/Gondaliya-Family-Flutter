import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/values/sizes.dart';
import '../../../data/models/private_conversation_model.dart';

class ConversationTile extends StatelessWidget {
  final PrivateConversation conversation;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final other = conversation.otherUser;

    final initials = other.name.isNotEmpty
        ? other.name
            .trim()
            .split(' ')
            .map((l) => l[0])
            .take(2)
            .join()
            .toUpperCase()
        : '?';

    final formattedTime = _formatMessageTime(conversation.lastMessageAt);

    return Dismissible(
      key: Key(conversation.conversationId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingL.w),
        decoration: BoxDecoration(
          color: colors.error,
          borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
        ),
        child: Icon(
          PhosphorIcons.trash(),
          color: Colors.white,
          size: 24.w,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Delete Conversation',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Are you sure you want to delete this conversation with ${other.name}?',
              style: GoogleFonts.outfit(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.outfit(color: colors.textSecondary),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.error,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Delete',
                  style: GoogleFonts.outfit(),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
          border: Border.all(
            color: conversation.unreadCount > 0
                ? colors.primary.withValues(alpha: 0.15)
                : colors.primary.withValues(alpha: 0.04),
            width: 1.5,
          ),
          boxShadow: colors.neumorphicShadow(blur: 8, distance: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.all(AppSizes.spacingL.w),
                child: Row(
                  children: [
                    // Avatar / Initials
                    Container(
                      width: 52.r,
                      height: 52.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: conversation.unreadCount > 0
                              ? colors.primaryGradient
                              : [
                                  colors.textSecondary.withValues(alpha: 0.1),
                                  colors.textSecondary.withValues(alpha: 0.2),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: conversation.unreadCount > 0
                                ? Colors.white
                                : colors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSizes.spacingL.w),

                    // Info Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  other.name,
                                  style: GoogleFonts.outfit(
                                    fontWeight: conversation.unreadCount > 0
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    fontSize: AppSizes.fontSizeBodyLarge.sp,
                                    color: colors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: AppSizes.spacingS.w),
                              Text(
                                formattedTime,
                                style: GoogleFonts.outfit(
                                  fontSize: AppSizes.fontSizeMicro.sp,
                                  fontWeight: conversation.unreadCount > 0
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: conversation.unreadCount > 0
                                      ? colors.primary
                                      : colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.spacingS.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  conversation.lastMessage ?? 'No messages yet',
                                  style: GoogleFonts.outfit(
                                    fontSize: AppSizes.fontSizeBodyMedium.sp,
                                    fontWeight: conversation.unreadCount > 0
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                    color: conversation.unreadCount > 0
                                        ? colors.textPrimary
                                        : colors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (conversation.unreadCount > 0) ...[
                                SizedBox(width: AppSizes.spacingS.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: colors.primaryGradient,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${conversation.unreadCount}',
                                    style: GoogleFonts.outfit(
                                      fontSize: AppSizes.fontSizeMicro.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatMessageTime(DateTime? date) {
    if (date == null) return '';
    final localDate = date.toLocal();
    final now = DateTime.now();
    final difference = now.difference(localDate);

    if (difference.inDays == 0) {
      return DateFormat('hh:mm a').format(localDate);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(localDate); // Weekday name
    } else {
      return DateFormat('dd/MM/yyyy').format(localDate);
    }
  }
}
