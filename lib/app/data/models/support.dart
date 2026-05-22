import 'package:equatable/equatable.dart';

class Support extends Equatable {
  final String id;
  final String phone;
  final String? phone2;
  final String email;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Support({
    required this.id,
    required this.phone,
    this.phone2,
    required this.email,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    phone,
    phone2,
    email,
    address,
    createdAt,
    updatedAt,
  ];

  factory Support.fromJson(Map<String, dynamic> json) {
    return Support(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      phone2: json['phone2'] as String?,
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
      'phone': phone,
      if (phone2 != null) 'phone2': phone2,
      'email': email,
      if (address != null) 'address': address,
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
