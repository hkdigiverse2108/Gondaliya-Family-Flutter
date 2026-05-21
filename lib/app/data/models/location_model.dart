class LocationModel {
  final String id;
  final String village;
  final String taluka;
  final String district;
  final String pincode;

  LocationModel({
    required this.id,
    required this.village,
    required this.taluka,
    required this.district,
    required this.pincode,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['_id'] ?? '',
      village: json['village'] ?? '',
      taluka: json['taluka'] ?? '',
      district: json['district'] ?? '',
      pincode: json['pincode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'village': village,
      'taluka': taluka,
      'district': district,
      'pincode': pincode,
    };
  }
}
