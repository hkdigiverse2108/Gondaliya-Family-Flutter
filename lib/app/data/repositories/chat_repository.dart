import 'package:get/get.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_response.dart';
import '../../../core/network/api_service.dart';
import '../models/chat.dart';

class ChatRepository {
  final DioApiService _apiService = Get.find<DioApiService>();

  // Fetch paginated chat messages from the global room.
  // Returns a tuple of (messages, totalPages).
  Future<ApiResponse<(List<Chat>, int)>> getChatMessages({
    int page = 1,
    int limit = 15,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    return _apiService.get<(List<Chat>, int)>(
      ApiEndpoints.chatRooms,
      queryParams: queryParams,
      fromJson: (json) {
        List<Chat> msgs = [];
        int totalPages = 1;

        if (json is Map<String, dynamic>) {
          // Backend wraps in { data: [...], totalData, state: { totalPages } }
          final raw = json['data'];
          if (raw is List) {
            msgs = raw
                .map((e) => Chat.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          final state = json['state'];
          if (state is Map<String, dynamic>) {
            totalPages = (state['totalPages'] as num?)?.toInt() ?? 1;
          }
        } else if (json is List) {
          msgs = json
              .map((e) => Chat.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return (msgs, totalPages);
      },
    );
  }

  // Send a chat message using POST /chat/add
  Future<ApiResponse<Chat>> sendChatMessage({
    String? message,
    String? mediaUrl,
    String mediaType = 'TEXT',
    String messageType = 'text',
    int fileSize = 0,
  }) async {
    final body = <String, dynamic>{
      'message': message,
      'mediaType': mediaType,
      'mediaUrl': mediaUrl,
      'messageType': messageType,
      'fileSize': fileSize,
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
