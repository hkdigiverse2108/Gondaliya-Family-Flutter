import 'package:get/get.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/api_service.dart';
import '../models/chat.dart';

class ChatRepository {
  final DioApiService _apiService = Get.find<DioApiService>();

  // Fetch all chat messages from the global room
  Future<ApiResponse<List<Chat>>> getChatMessages({
    int? page,
    int? limit,
  }) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;
    if (limit != null) queryParams['limit'] = limit;

    return _apiService.get<List<Chat>>(
      ApiEndpoints.chatRooms, // Mapped to '/chat/all'
      queryParams: queryParams,
      fromJson: (json) {
        if (json is Map<String, dynamic> && json['data'] is List) {
          final list = json['data'] as List;
          return list
              .map((e) => Chat.fromJson(e as Map<String, dynamic>))
              .toList();
        } else if (json is List) {
          return json
              .map((e) => Chat.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return [];
      },
    );
  }

  // Send a chat message using POST /chat/add
  Future<ApiResponse<Chat>> sendChatMessage({
    required String message,
    String? mediaUrl,
    String mediaType = 'TEXT',
  }) async {
    final body = <String, dynamic>{
      'message': message,
      'mediaType': mediaType,
      'mediaUrl': ?mediaUrl,
    };

    return _apiService.post<Chat>(
      ApiEndpoints.addChatMessage,
      data: body,
      fromJson: (json) {
        return Chat.fromJson(json as Map<String, dynamic>);
      },
    );
  }
}
