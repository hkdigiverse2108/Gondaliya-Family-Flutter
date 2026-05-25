import 'package:get/get.dart';
import '../../../data/models/family_member.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/auth_repository.dart';

class MemberDetailController extends GetxController {
  final _authRepo = AuthRepository();

  final member = Rxn<FamilyMember>();
  final linkedUser = Rxn<UserModel>();
  final isLoading = false.obs;

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
}
