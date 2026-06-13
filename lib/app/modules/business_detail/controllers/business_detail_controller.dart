import 'package:get/get.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/private_chat_repository.dart';
import '../../../data/models/private_conversation_model.dart';

class BusinessDetailController extends GetxController {
  final _authRepo = AuthRepository();
  final _chatRepo = PrivateChatRepository();

  final owner = Rxn<UserModel>();
  final isLoading = false.obs;
  final isStartingChat = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      final passedUser = args['user'];
      if (passedUser != null && passedUser is UserModel) {
        owner.value = passedUser;
      }
      final userId = args['userId'] as String?;
      if (userId != null && userId.isNotEmpty) {
        fetchOwnerProfile(userId);
      }
    }
  }

  Future<void> fetchOwnerProfile(String id) async {
    // Only show loading if we don't already have initial data
    if (owner.value == null) {
      isLoading.value = true;
    }
    try {
      final response = await _authRepo.getUserById(id);
      if (response.success && response.data != null) {
        owner.value = response.data;
      }
    } catch (e) {
      Get.printError(info: 'fetchOwnerProfile error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startDirectMessage() async {
    final ownerVal = owner.value;
    if (ownerVal == null) return;

    isStartingChat.value = true;
    try {
      final response = await _chatRepo.startConversation(
        receiverId: ownerVal.id,
      );
      if (response.success && response.data != null) {
        final conversationId = response.data!;
        Get.toNamed(
          '/private-chat/$conversationId',
          arguments: {
            'otherUser': PrivateChatUser(
              userId: ownerVal.id,
              name: '${ownerVal.firstName} ${ownerVal.lastName}'.trim(),
              avatar: ownerVal.profilePhoto,
            ),
          },
        );
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to start conversation',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not start conversation',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isStartingChat.value = false;
    }
  }
}
