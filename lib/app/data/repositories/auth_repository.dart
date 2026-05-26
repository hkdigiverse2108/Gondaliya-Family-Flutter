import 'package:gondalia_family/core/network/api_response.dart';
import 'package:gondalia_family/core/network/base_repository.dart';
import 'package:gondalia_family/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';
import '../models/user.dart';
import '../models/support.dart';

class AuthRepository extends BaseRepository {
  /// Login with phone number and password
  Future<ApiResponse<UserModel>> login({
    required String phoneNumber,
    required String password,
    String? deviceToken,
  }) {
    final Map<String, dynamic> payload = {
      'phoneNumber': phoneNumber,
      'password': password,
    };
    if (deviceToken != null && deviceToken.isNotEmpty) {
      payload['deviceToken'] = deviceToken;
    }
    return api.post<UserModel>(
      ApiEndpoints.login,
      data: payload,
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

  /// Update user profile details
  Future<ApiResponse<UserModel>> updateUser(Map<String, dynamic> payload) {
    return api.put<UserModel>(
      ApiEndpoints.updateUser,
      data: payload,
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Fetch all businesses with optional search and pagination
  Future<ApiResponse<List<dynamic>>> getBusinesses({
    String? search,
    int? page,
    int? limit,
  }) {
    final Map<String, dynamic> queryParams = {};
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search;
    }
    if (page != null) {
      queryParams['page'] = page;
    }
    if (limit != null) {
      queryParams['limit'] = limit;
    }
    return api.get<List<dynamic>>(
      ApiEndpoints.businessesAll,
      queryParams: queryParams.isNotEmpty ? queryParams : null,
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
    Map<String, dynamic> payload,
  ) {
    return api.put<UserModel>(
      ApiEndpoints.familyMembers,
      data: payload,
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Delete a family member
  Future<ApiResponse<UserModel>> deleteFamilyMember(
    Map<String, dynamic> payload,
  ) {
    return api.delete<UserModel>(
      ApiEndpoints.familyMembers,
      data: payload,
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Fetch support contact details
  Future<ApiResponse<Support>> getSupportInfo() {
    return api.get<Support>(
      ApiEndpoints.supportAll,
      fromJson: (json) => Support.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Submit user feedback or complaint
  Future<ApiResponse<dynamic>> addFeedback({
    required String type,
    required String message,
  }) {
    return api.post<dynamic>(
      ApiEndpoints.feedbackAdd,
      data: {'type': type, 'message': message},
      fromJson: (json) => json,
    );
  }

  /// Upload a file to the centralized upload endpoint
  Future<ApiResponse<Map<String, dynamic>>> uploadFile({
    required String filePath,
    String? oldFileUrl,
  }) async {
    final fileName = filePath.split('/').last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
      if (oldFileUrl != null && oldFileUrl.isNotEmpty) 'oldFileUrl': oldFileUrl,
    });

    return api.uploadFile<Map<String, dynamic>>(
      ApiEndpoints.upload,
      formData: formData,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }
}
