import 'package:gondalia_family/core/network/api_service.dart';
import 'package:gondalia_family/core/network/api_endpoints.dart';
import 'package:gondalia_family/app/data/models/announcement.dart';
import 'package:gondalia_family/app/data/models/listing.dart';

class HomeRepository {
  final DioApiService _apiService;

  HomeRepository(this._apiService);

  Future<List<Announcement>> getAnnouncements() async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        ApiEndpoints.announcements,
      );

      if (response.success && response.data != null) {
        final List<dynamic> dataList = response.data!['data'] ?? [];
        return dataList.map((e) => Announcement.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Listing>> getListings() async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        ApiEndpoints.listings,
      );

      if (response.success && response.data != null) {
        final List<dynamic> dataList = response.data!['data'] ?? [];
        return dataList.map((e) => Listing.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
