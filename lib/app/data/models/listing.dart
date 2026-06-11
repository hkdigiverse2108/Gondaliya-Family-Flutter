import 'package:equatable/equatable.dart';

import '../../../core/utils/extensions/safe_json_map_extensions.dart';

class ListingLocation extends Equatable {
  final String city;
  final String pincode;

  const ListingLocation({required this.city, required this.pincode});

  @override
  List<Object?> get props => [city, pincode];

  factory ListingLocation.fromJson(Map<String, dynamic> json) {
    return ListingLocation(
      city: json['city'] as String? ?? '',
      pincode: json['pincode'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'city': city, 'pincode': pincode};
  }
}

class Listing extends Equatable {
  final String id;
  final String postedBy;
  final String type;
  final String title;
  final String description;
  final List<String>? photos;
  final num price;
  final String priceUnit;
  final DateTime availableFrom;
  final DateTime? availableTo;
  final ListingLocation location;
  final String contactPhone;
  final String status;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Listing({
    required this.id,
    required this.postedBy,
    required this.type,
    required this.title,
    required this.description,
    this.photos,
    required this.price,
    required this.priceUnit,
    required this.availableFrom,
    this.availableTo,
    required this.location,
    required this.contactPhone,
    this.status = 'ACTIVE',
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    postedBy,
    type,
    title,
    description,
    photos,
    price,
    priceUnit,
    availableFrom,
    availableTo,
    location,
    contactPhone,
    status,
    isDeleted,
    createdAt,
    updatedAt,
  ];

  factory Listing.fromJson(Map<String, dynamic> json) {
    String postedByVal = '';
    final rawPostedBy = json['postedBy'];
    if (rawPostedBy is Map<String, dynamic>) {
      postedByVal =
          '${rawPostedBy.getOrNull('firstName') ?? ''} ${rawPostedBy.getOrNull('lastName') ?? ''}'
              .trim();
      if (postedByVal.isEmpty) {
        postedByVal =
            rawPostedBy.getOrNull('_id') ?? rawPostedBy.getOrNull('id') ?? '';
      }
    } else if (rawPostedBy is String) {
      postedByVal = rawPostedBy;
    }

    return Listing(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      postedBy: postedByVal,
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      price: json['price'] as num? ?? 0,
      priceUnit: json['priceUnit'] as String? ?? '',
      availableFrom:
          DateTime.tryParse(json['availableFrom'] as String? ?? '') ??
          DateTime.now(),
      availableTo: json['availableTo'] != null
          ? DateTime.tryParse(json['availableTo'] as String)
          : null,
      location: ListingLocation.fromJson(
        json['location'] as Map<String, dynamic>? ?? {},
      ),
      contactPhone: json['contactPhone'] as String? ?? '',
      status: json['status'] as String? ?? 'ACTIVE',
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
      'postedBy': postedBy,
      'type': type,
      'title': title,
      'description': description,
      if (photos != null) 'photos': photos,
      'price': price,
      'priceUnit': priceUnit,
      'availableFrom': availableFrom.toIso8601String(),
      if (availableTo != null) 'availableTo': availableTo?.toIso8601String(),
      'location': location.toJson(),
      'contactPhone': contactPhone,
      'status': status,
      'isDeleted': isDeleted,
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
