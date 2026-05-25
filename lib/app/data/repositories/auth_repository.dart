import 'package:gondalia_family/core/network/api_response.dart';
import 'package:gondalia_family/core/network/base_repository.dart';
import 'package:gondalia_family/core/network/api_endpoints.dart';
import '../models/user.dart';

class AuthRepository extends BaseRepository {
  /// Login with phone number and password
  Future<ApiResponse<UserModel>> login({
    required String phoneNumber,
    required String password,
  }) {
    return api.post<UserModel>(
      ApiEndpoints.login,
      data: {'phoneNumber': phoneNumber, 'password': password},
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Register a new user
  Future<ApiResponse<UserModel>> register({
    required Map<String, dynamic> payload,
  }) {
    return api.post<UserModel>(
      ApiEndpoints.register,
      data: payload,
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Fetch current user profile
  // Deprecated: Fetch by ID using getUserById instead

  /// Fetch user by ID
  Future<ApiResponse<UserModel>> getUserById(String id) {
    return api.get<UserModel>(
      ApiEndpoints.replaceId(ApiEndpoints.userById, id),
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Fetch all businesses
  Future<ApiResponse<List<dynamic>>> getBusinesses() {
    return api.get<List<dynamic>>(
      ApiEndpoints.businessesAll,
      fromJson: (json) {
        if (json is Map<String, dynamic> && json.containsKey('data')) {
          return json['data'] as List<dynamic>;
        } else if (json is List<dynamic>) {
          return json;
        }
        return [];
      },
    );
  }

  /// Add a family member
  Future<ApiResponse<UserModel>> addFamilyMember(Map<String, dynamic> payload) {
    return api.post<UserModel>(
      ApiEndpoints.familyMembers,
      data: payload,
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Update a family member
  Future<ApiResponse<UserModel>> updateFamilyMember(
    String memberId,
    Map<String, dynamic> payload,
  ) {
    return api.put<UserModel>(
      ApiEndpoints.replaceId(ApiEndpoints.familyMember, memberId),
      data: payload,
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Delete a family member
  Future<ApiResponse<UserModel>> deleteFamilyMember(String memberId) {
    return api.delete<UserModel>(
      ApiEndpoints.replaceId(ApiEndpoints.familyMember, memberId),
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
