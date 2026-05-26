import 'package:equatable/equatable.dart';

enum MessageType { text, give, take }

class PrivateMessage extends Equatable {
  final String messageId;
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String? senderPhoto;
  final String receiverId;
  final String message;
  final MessageType messageType;
  final bool isRead;
  final DateTime? createdAt;

  const PrivateMessage({
    required this.messageId,
    required this.conversationId,
    required this.senderId,
    this.senderName,
    this.senderPhoto,
    required this.receiverId,
    required this.message,
    required this.messageType,
    required this.isRead,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        messageId,
        conversationId,
        senderId,
        senderName,
        senderPhoto,
        receiverId,
        message,
        messageType,
        isRead,
        createdAt,
      ];

  factory PrivateMessage.fromJson(Map<String, dynamic> json) {
    String senderId = '';
    String? senderName;
    String? senderPhoto;

    final senderData = json['senderId'];
    if (senderData is Map<String, dynamic>) {
      senderId =
          senderData['_id'] as String? ?? senderData['id'] as String? ?? '';
      final firstName = senderData['firstName'] as String? ?? '';
      final lastName = senderData['lastName'] as String? ?? '';
      if (firstName.isNotEmpty || lastName.isNotEmpty) {
        senderName = '$firstName $lastName'.trim();
      }
      senderPhoto = senderData['profilePhoto'] as String?;
    } else if (senderData is String) {
      senderId = senderData;
    }

    final typeStr = json['messageType'] as String? ?? 'text';
    MessageType type;
    if (typeStr == 'give') {
      type = MessageType.give;
    } else if (typeStr == 'take') {
      type = MessageType.take;
    } else {
      type = MessageType.text;
    }

    return PrivateMessage(
      messageId: json['_id'] as String? ?? json['id'] as String? ?? '',
      conversationId: json['conversationId'] as String? ?? '',
      senderId: senderId,
      senderName: senderName,
      senderPhoto: senderPhoto,
      receiverId: json['receiverId'] as String? ?? '',
      message: json['message'] as String? ?? '',
      messageType: type,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': messageId,
      'conversationId': conversationId,
      'senderId': senderId,
      if (senderName != null) 'senderName': senderName,
      if (senderPhoto != null) 'senderPhoto': senderPhoto,
      'receiverId': receiverId,
      'message': message,
      'messageType': messageType.name,
      'isRead': isRead,
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
    };
  }
}
