class Business {
  final String id;
  final String name;
  final String category;
  final String address;
  final String contact;
  final String description;
  final String? ownerId; // Links to FamilyMember id if applicable
  final DateTime createdAt;

  Business({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.contact,
    required this.description,
    this.ownerId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'address': address,
      'contact': contact,
      'description': description,
      'ownerId': ownerId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      address: json['address'] as String,
      contact: json['contact'] as String,
      description: json['description'] as String,
      ownerId: json['ownerId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Business copyWith({
    String? id,
    String? name,
    String? category,
    String? address,
    String? contact,
    String? description,
    String? ownerId,
    DateTime? createdAt,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
