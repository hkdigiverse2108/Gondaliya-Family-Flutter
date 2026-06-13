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

  Future<List<Listing>> getMyListings() async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        ApiEndpoints.listingsAll,
        queryParams: {'my': 'true'},
      );

      if (response.success && response.data != null) {
        final List<dynamic> dataList = response.data!.getOrNull('data') ?? [];
        return dataList
            .map((e) => Listing.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e, stack) {
      debugPrint('getMyListings error: $e\n$stack');
      return [];
    }
  }

  Future<bool> deleteListing(String id) async {
    try {
      final response = await _apiService.delete<Map<String, dynamic>>(
        ApiEndpoints.replaceId(ApiEndpoints.listing, id),
      );
      return response.success;
    } catch (e, stack) {
      debugPrint('deleteListing error: $e\n$stack');
      return false;
    }
  }

  Future<bool> createListing(Map<String, dynamic> payload) async {
    try {
      final response = await _apiService.post<dynamic>(
        '/listings',
        data: payload,
      );
      return response.success;
    } catch (e, stack) {
      debugPrint('createListing error: $e\n$stack');
      return false;
    }
  }

  Future<bool> updateListing(String id, Map<String, dynamic> payload) async {
    try {
      final response = await _apiService.put<dynamic>(
        ApiEndpoints.replaceId(ApiEndpoints.listing, id),
        data: payload,
      );
      return response.success;
    } catch (e, stack) {
      debugPrint('updateListing error: $e\n$stack');
      return false;
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
