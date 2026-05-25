import 'package:get/get.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/auth_repository.dart';

class BusinessDetailController extends GetxController {
  final _authRepo = AuthRepository();

  final owner = Rxn<UserModel>();
  final isLoading = false.obs;

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
}
