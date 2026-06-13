import 'package:equatable/equatable.dart';

class Support extends Equatable {
  final String id;
  final List<String> phones;
  final String email;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Support({
    required this.id,
    required this.phones,
    required this.email,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, phones, email, address, createdAt, updatedAt];

  factory Support.fromJson(Map<String, dynamic> json) {
    return Support(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      phones:
          (json['phones'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      email: json['email'] as String? ?? '',
      address: json['address'] as String?,
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
      'phones': phones,
      'email': email,
      if (address != null) 'address': address,
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
