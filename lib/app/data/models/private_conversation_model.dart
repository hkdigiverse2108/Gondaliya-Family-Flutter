import 'package:equatable/equatable.dart';

class PrivateConversation extends Equatable {
  final String conversationId;
  final PrivateChatUser otherUser;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;

  const PrivateConversation({
    required this.conversationId,
    required this.otherUser,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [
        conversationId,
        otherUser,
        lastMessage,
        lastMessageAt,
        unreadCount,
      ];

  factory PrivateConversation.fromJson(Map<String, dynamic> json) {
    final otherParticipant = json['otherParticipant'] as Map<String, dynamic>?;
    final otherUser = otherParticipant != null
        ? PrivateChatUser.fromJson(otherParticipant)
        : const PrivateChatUser(userId: '', name: 'Unknown');

    return PrivateConversation(
      conversationId: json['_id'] as String? ?? json['id'] as String? ?? '',
      otherUser: otherUser,
      lastMessage: json['lastMessage'] as String?,
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.tryParse(json['lastMessageAt'] as String)
          : null,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': conversationId,
      'otherParticipant': otherUser.toJson(),
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'unreadCount': unreadCount,
    };
  }
}

class PrivateChatUser extends Equatable {
  final String userId;
  final String name;
  final String? avatar;

  const PrivateChatUser({
    required this.userId,
    required this.name,
    this.avatar,
  });

  @override
  List<Object?> get props => [userId, name, avatar];

  factory PrivateChatUser.fromJson(Map<String, dynamic> json) {
    return PrivateChatUser(
      userId: json['_id'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      avatar: json['avatar'] == 'null' || json['avatar'] == null
          ? null
          : json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': userId,
      'name': name,
      if (avatar != null) 'avatar': avatar,
    };
  }
}
