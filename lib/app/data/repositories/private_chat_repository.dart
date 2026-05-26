import 'package:get/get.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/api_service.dart';
import '../models/private_conversation_model.dart';
import '../models/private_message_model.dart';

class PrivateChatRepository {
  final DioApiService _apiService = Get.find<DioApiService>();

  /// Start or retrieve a conversation with a specific user
  Future<ApiResponse<String>> startConversation({
    required String receiverId,
  }) async {
    final body = {
      'receiverId': receiverId,
    };

    return _apiService.post<String>(
      ApiEndpoints.startPrivateChat,
      data: body,
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          return json['conversationId'] as String? ?? '';
        }
        return '';
      },
    );
  }

  /// Fetch all active private conversations for the current user
  Future<ApiResponse<List<PrivateConversation>>> getConversations() async {
    return _apiService.get<List<PrivateConversation>>(
      ApiEndpoints.privateConversations,
      fromJson: (json) {
        if (json is List) {
          return json
              .map((e) => PrivateConversation.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );
  }

  /// Fetch paginated messages for a private conversation
  Future<ApiResponse<List<PrivateMessage>>> getMessages({
    required String conversationId,
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;
    if (limit != null) queryParams['limit'] = limit;

    final path = ApiEndpoints.replaceId(
      ApiEndpoints.privateMessages,
      conversationId,
    );

    return _apiService.get<List<PrivateMessage>>(
      path,
      queryParams: queryParams,
      fromJson: (json) {
        if (json is Map<String, dynamic> && json['data'] is List) {
          final list = json['data'] as List;
          return list
              .map((e) => PrivateMessage.fromJson(e as Map<String, dynamic>))
              .toList();
        } else if (json is List) {
          return json
              .map((e) => PrivateMessage.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );
  }

  /// Mark all messages in a conversation as read
  Future<ApiResponse<bool>> markAsRead({
    required String conversationId,
  }) async {
    final path = ApiEndpoints.replaceId(
      ApiEndpoints.readPrivateMessages,
      conversationId,
    );

    return _apiService.put<bool>(
      path,
      fromJson: (json) => true,
    );
  }

  /// Soft delete a conversation
  Future<ApiResponse<bool>> deleteConversation({
    required String conversationId,
  }) async {
    final path = ApiEndpoints.replaceId(
      ApiEndpoints.deletePrivateConversation,
      conversationId,
    );

    return _apiService.delete<bool>(
      path,
      fromJson: (json) => true,
    );
  }
}
