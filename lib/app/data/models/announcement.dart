import 'package:equatable/equatable.dart';

class Announcement extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String createdBy;
  final bool isActive;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Announcement({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.createdBy,
    this.isActive = true,
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        createdBy,
        isActive,
        isDeleted,
        createdAt,
        updatedAt,
      ];

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      createdBy: json['createdBy'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      isDeleted: json['isDeleted'] as bool? ?? false,
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
      'title': title,
      'description': description,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'createdBy': createdBy,
      'isActive': isActive,
      'isDeleted': isDeleted,
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

