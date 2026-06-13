import 'package:get/get.dart';
import '../../../data/models/user.dart';
import '../../../data/models/work_details.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/private_chat_repository.dart';
import '../../../data/models/private_conversation_model.dart';

class BusinessDetailController extends GetxController {
  final _authRepo = AuthRepository();
  final _chatRepo = PrivateChatRepository();

  final owner = Rxn<UserModel>();
  final isLoading = false.obs;
  final isStartingChat = false.obs;
  String? businessId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      final passedUser = args['user'];
      if (passedUser != null && passedUser is UserModel) {
        owner.value = passedUser;
      }
      final bizId = args['businessId'] as String?;
      businessId = bizId;
      final userId = args['userId'] as String?;
      if (bizId != null && bizId.isNotEmpty) {
        fetchBusinessDetail(bizId);
      } else if (userId != null && userId.isNotEmpty) {
        fetchOwnerProfile(userId);
      }
    }
  }

  Future<void> fetchBusinessDetail(String businessId) async {
    if (owner.value == null) {
      isLoading.value = true;
    }
    try {
      final response = await _authRepo.getBusinessById(businessId);
      if (response.success && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final ownerJson = data['owner'] as Map<String, dynamic>?;
        final bizJson = data['business'] as Map<String, dynamic>?;

        if (ownerJson != null && bizJson != null) {
          final businessDetails = BusinessDetails.fromJson(bizJson);
          final reconstructedUser = UserModel(
            id: ownerJson['userId'] as String? ?? '',
            firstName: ownerJson['firstName'] as String? ?? '',
            middleName: '',
            lastName: ownerJson['lastName'] as String? ?? '',
            dob: '',
            bloodGroup: '',
            education: '',
            isMarried: '',
            phoneNumber: ownerJson['phoneNumber'] as String? ?? '',
            profilePhoto: ownerJson['profilePhoto'] as String?,
            village: ownerJson['village'] as String? ?? '',
            pincode: '',
            taluka: '',
            district: '',
            currentAddress: '',
            currentCity: ownerJson['currentCity'] as String?,
            houseType: '',
            familyMembers: const [],
            workDetails: WorkDetails(
              businessDetails: businessDetails,
            ),
          );
          owner.value = reconstructedUser;
        }
      }
    } catch (e) {
      Get.printError(info: 'fetchBusinessDetail error: $e');
    } finally {
      isLoading.value = false;
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
        final user = response.data!;
        // Fetch legacy/first business for this user
        final bizResponse = await _authRepo.getBusinesses(search: user.phoneNumber);
        if (bizResponse.success && bizResponse.data != null && bizResponse.data!.isNotEmpty) {
          final firstBiz = bizResponse.data!.first;
          if (firstBiz is Map<String, dynamic> && firstBiz.containsKey('business')) {
            final bizJson = firstBiz['business'] as Map<String, dynamic>;
            businessId = bizJson['_id'] as String? ?? bizJson['id'] as String?;
            final businessDetails = BusinessDetails.fromJson(bizJson);
            owner.value = user.copyWith(
              workDetails: WorkDetails(
                jobDetails: user.workDetails?.jobDetails,
                businessDetails: businessDetails,
              ),
            );
            return;
          }
        }
        owner.value = user;
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
