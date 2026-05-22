import 'package:equatable/equatable.dart';

class Feedback extends Equatable {
  final String id;
  final String userId;
  final String type;
  final String message;
  final String status;
  final String? adminNote;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Feedback({
    required this.id,
    required this.userId,
    required this.type,
    required this.message,
    this.status = 'PENDING',
    this.adminNote,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        message,
        status,
        adminNote,
        createdAt,
        updatedAt,
      ];

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      type: json['type'] as String? ?? '',
      message: json['message'] as String? ?? '',
      status: json['status'] as String? ?? 'PENDING',
      adminNote: json['adminNote'] as String?,
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
      'userId': userId,
      'type': type,
      'message': message,
      'status': status,
      if (adminNote != null) 'adminNote': adminNote,
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

