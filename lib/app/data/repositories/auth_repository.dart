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
  Future<ApiResponse<UserModel>> getProfile() {
    return api.get<UserModel>(
      ApiEndpoints.profile,
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Fetch user by ID
  Future<ApiResponse<UserModel>> getUserById(String id) {
    return api.get<UserModel>(
      ApiEndpoints.replaceId(ApiEndpoints.userById, id),
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
