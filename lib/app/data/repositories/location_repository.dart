import '../../../core/network/base_repository.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/location_model.dart';

class LocationRepository extends BaseRepository {
  /// Fetch locations with search and pagination
  Future<List<LocationModel>> getLocations({
    int page = 1,
    int limit = 10,
    String search = '',
  }) async {
    final response = await api.get<Map<String, dynamic>>(
      ApiEndpoints.location,
      queryParams: {
        'page': page,
        'limit': limit,
        if (search.isNotEmpty) 'search': search,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      final data = response.data!['data'] as List?;
      if (data != null) {
        return data
            .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }
}
