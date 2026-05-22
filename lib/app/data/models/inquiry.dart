import 'package:equatable/equatable.dart';

class Inquiry extends Equatable {
  final String id;
  final String senderId;
  final String targetType;
  final String targetId;
  final String message;
  final String? reply;
  final DateTime? repliedAt;
  final bool isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Inquiry({
    required this.id,
    required this.senderId,
    required this.targetType,
    required this.targetId,
    required this.message,
    this.reply,
    this.repliedAt,
    this.isRead = false,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        senderId,
        targetType,
        targetId,
        message,
        reply,
        repliedAt,
        isRead,
        createdAt,
        updatedAt,
      ];

  factory Inquiry.fromJson(Map<String, dynamic> json) {
    return Inquiry(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      targetType: json['targetType'] as String? ?? '',
      targetId: json['targetId'] as String? ?? '',
      message: json['message'] as String? ?? '',
      reply: json['reply'] as String?,
      repliedAt: json['repliedAt'] != null
          ? DateTime.tryParse(json['repliedAt'] as String)
          : null,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) '_id': id,
      'senderId': senderId,
      'targetType': targetType,
      'targetId': targetId,
      'message': message,
      if (reply != null) 'reply': reply,
      if (repliedAt != null) 'repliedAt': repliedAt?.toIso8601String(),
      'isRead': isRead,
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

