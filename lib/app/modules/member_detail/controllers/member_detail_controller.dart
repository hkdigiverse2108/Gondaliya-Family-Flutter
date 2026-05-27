import 'package:get/get.dart';
import '../../../data/models/family_member.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/private_chat_repository.dart';
import '../../../data/models/private_conversation_model.dart';
import '../../../data/services/storage_service.dart';

class MemberDetailController extends GetxController {
  final _authRepo = AuthRepository();
  final _chatRepo = PrivateChatRepository();

  final member = Rxn<FamilyMember>();
  final linkedUser = Rxn<UserModel>();
  final headName = Rxn<String>();
  final isLoading = false.obs;
  final isStartingChat = false.obs;

  String get currentUserId => Get.find<StorageService>().currentUser?.id ?? '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      final passedMember = args['member'];
      if (passedMember != null && passedMember is FamilyMember) {
        member.value = passedMember;
        if (passedMember.linkedUserId != null && passedMember.linkedUserId!.isNotEmpty) {
          fetchLinkedUserProfile(passedMember.linkedUserId!);
        }
      }

      final userId = args['userId'] as String?;
      final passedUser = args['user'];
      if (passedUser != null && passedUser is UserModel) {
        linkedUser.value = passedUser;
      }
      if (userId != null && userId.isNotEmpty) {
        fetchLinkedUserProfile(userId);
      }

      final passedHeadName = args['headName'] as String?;
      if (passedHeadName != null) {
        headName.value = passedHeadName;
      }
    }
  }

  Future<void> fetchLinkedUserProfile(String id) async {
    // Only show loading if we don't have enough initial details
    if (member.value == null && linkedUser.value == null) {
      isLoading.value = true;
    }
    try {
      final response = await _authRepo.getUserById(id);
      if (response.success && response.data != null) {
        linkedUser.value = response.data;
        // If we don't have a member, synthesize one or show user details directly
      }
    } catch (e) {
      Get.printError(info: 'fetchLinkedUserProfile error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startDirectMessage() async {
    final userVal = linkedUser.value;
    if (userVal == null) return;

    isStartingChat.value = true;
    try {
      final response = await _chatRepo.startConversation(
        receiverId: userVal.id,
      );
      if (response.success && response.data != null) {
        final conversationId = response.data!;
        Get.toNamed(
          '/private-chat/$conversationId',
          arguments: {
            'otherUser': PrivateChatUser(
              userId: userVal.id,
              name: '${userVal.firstName} ${userVal.lastName}'.trim(),
              avatar: userVal.profilePhoto,
            ),
          },
        );
      } else {
        Get.snackbar(
          'error'.tr,
          response.message ?? 'Failed to start conversation',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Could not start conversation',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isStartingChat.value = false;
    }
  }
}
