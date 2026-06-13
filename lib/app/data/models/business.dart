class Business {
  final String id;
  final String name;
  final String category;
  final List<String> subCategory;
  final String address;
  final String city;
  final String contact;
  final String description;
  final String? ownerId; // Links to FamilyMember id if applicable
  final DateTime createdAt;
  final String ownerName;
  final String? businessLogo;
  final String? businessBanner;
  final List<String>? businessPhotos;

  Business({
    required this.id,
    required this.name,
    required this.category,
    required this.subCategory,
    required this.address,
    required this.city,
    required this.contact,
    required this.description,
    this.ownerId,
    required this.createdAt,
    required this.ownerName,
    this.businessLogo,
    this.businessBanner,
    this.businessPhotos,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'subCategory': subCategory,
      'address': address,
      'city': city,
      'contact': contact,
      'description': description,
      'ownerId': ownerId,
      'createdAt': createdAt.toIso8601String(),
      'ownerName': ownerName,
      'businessLogo': businessLogo,
      'businessBanner': businessBanner,
      'businessPhotos': businessPhotos,
    };
  }

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      subCategory: json['subCategory'] is List
          ? (json['subCategory'] as List).map((e) => e.toString()).toList()
          : (json['subCategory'] != null &&
                  json['subCategory'].toString().isNotEmpty)
              ? [json['subCategory'].toString()]
              : [],
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      contact: json['contact'] as String? ?? '',
      description: json['description'] as String? ?? '',
      ownerId: json['ownerId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      ownerName: json['ownerName'] as String? ?? '',
      businessLogo: json['businessLogo'] as String?,
      businessBanner: json['businessBanner'] as String?,
      businessPhotos: (json['businessPhotos'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Business copyWith({
    String? id,
    String? name,
    String? category,
    List<String>? subCategory,
    String? address,
    String? city,
    String? contact,
    String? description,
    String? ownerId,
    DateTime? createdAt,
    String? ownerName,
    String? businessLogo,
    String? businessBanner,
    List<String>? businessPhotos,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      address: address ?? this.address,
      city: city ?? this.city,
      contact: contact ?? this.contact,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      ownerName: ownerName ?? this.ownerName,
      businessLogo: businessLogo ?? this.businessLogo,
      businessBanner: businessBanner ?? this.businessBanner,
      businessPhotos: businessPhotos ?? this.businessPhotos,
    );
  }
}
