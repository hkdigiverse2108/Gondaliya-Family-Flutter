import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String id;
  final String senderId;
  final String? message;
  final String? mediaUrl;
  final String mediaType;
  final int fileSize;
  final bool isDeleted;
  final bool isBlocked;
  final String? deletedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Chat({
    required this.id,
    required this.senderId,
    this.message,
    this.mediaUrl,
    this.mediaType = 'TEXT',
    this.fileSize = 0,
    this.isDeleted = false,
    this.isBlocked = false,
    this.deletedBy,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    senderId,
    message,
    mediaUrl,
    mediaType,
    fileSize,
    isDeleted,
    isBlocked,
    deletedBy,
    createdAt,
    updatedAt,
  ];

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      message: json['message'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      mediaType: json['mediaType'] as String? ?? 'TEXT',
      fileSize: (json['fileSize'] as num?)?.toInt() ?? 0,
      isDeleted: json['isDeleted'] as bool? ?? false,
      isBlocked: json['isBlocked'] as bool? ?? false,
      deletedBy: json['deletedBy'] as String?,
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
      if (message != null) 'message': message,
      if (mediaUrl != null) 'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'fileSize': fileSize,
      'isDeleted': isDeleted,
      'isBlocked': isBlocked,
      if (deletedBy != null) 'deletedBy': deletedBy,
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
