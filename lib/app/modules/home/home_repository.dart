import '../../../core/network/api_service.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/utils/extensions/safe_json_map_extensions.dart';
import '../../data/models/listing.dart';
import 'package:flutter/foundation.dart';
import '../../data/models/parivar_directory.dart';

class HomeRepository {
  final DioApiService _apiService;

  HomeRepository(this._apiService);

  Future<List<Listing>> getListings() async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        ApiEndpoints.listingsAll,
      );

      if (response.success && response.data != null) {
        final List<dynamic> dataList = response.data!.getOrNull('data') ?? [];
        return dataList
            .map((e) => Listing.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e, stack) {
      debugPrint('getListings error: $e\n$stack');
      return [];
    }
  }

  Future<List<String>?> getParivarVillages() async {
    try {
      final response = await _apiService.get<List<dynamic>>(
        ApiEndpoints.parivarVillages,
      );
      if (response.success && response.data != null) {
        return response.data!.map((e) => e.toString()).toList();
      }
      return null;
    } catch (e, stack) {
      debugPrint('getParivarVillages error: $e\n$stack');
      return null;
    }
  }

  Future<List<ParivarDirectory>?> getParivarDirectory() async {
    try {
      final response = await _apiService.get<List<dynamic>>(
        ApiEndpoints.parivarAll,
      );
      if (response.success && response.data != null) {
        return response.data!
            .map((e) => ParivarDirectory.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return null;
    } catch (e, stack) {
      debugPrint('getParivarDirectory error: $e\n$stack');
      return null;
    }
  }
}
