import '../../../core/utils/extensions/safe_json_map_extensions.dart';

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
      id: json.getString('_id'),
      village: json.getOrNull<String>('village') ?? '',
      taluka: json.getOrNull<String>('taluka') ?? '',
      district: json.getOrNull<String>('district') ?? '',
      pincode: json.getOrNull<String>('pincode') ?? '',
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
