import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String type;
  final String refId;
  final bool isRead;
  final DateTime? createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.refId,
    this.isRead = false,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        body,
        type,
        refId,
        isRead,
        createdAt,
      ];

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      type: json['type'] as String? ?? '',
      refId: json['refId'] as String? ?? '',
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) '_id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'type': type,
      'refId': refId,
      'isRead': isRead,
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
    };
  }
}

