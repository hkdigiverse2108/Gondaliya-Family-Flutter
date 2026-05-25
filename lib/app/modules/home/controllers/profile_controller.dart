import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/family_member.dart';
import '../../../data/models/business.dart';
import '../../../data/models/user.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/repositories/auth_repository.dart';

class ProfileController extends GetxController {
  final _uuid = const Uuid();
  final _storage = Get.find<StorageService>();
  final _authRepo = AuthRepository();

  final currentUser = Rxn<UserModel>();
  final isLoading = false.obs;
  final isBusinessesLoading = false.obs;

  final familyMembers = <FamilyMember>[].obs;
  final businesses = <Business>[].obs;

  final familySearchQuery = ''.obs;
  final businessSearchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Load initial user details from storage
    currentUser.value = _storage.currentUser;
    if (currentUser.value != null) {
      familyMembers.assignAll(currentUser.value!.familyMembers);
    }
    // Fetch latest user details from API
    fetchUserProfile();
    fetchBusinesses();
  }

  Future<void> fetchUserProfile() async {
    final userId = currentUser.value?.id;
    if (userId == null || userId.isEmpty) return;

    isLoading.value = true;
    try {
      final response = await _authRepo.getUserById(userId);
      if (response.success && response.data != null) {
        currentUser.value = response.data;
        await _storage.saveUser(response.data!);
        familyMembers.assignAll(response.data!.familyMembers);
      }
    } catch (e) {
      Get.printError(info: 'fetchUserProfile error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBusinesses() async {
    isBusinessesLoading.value = true;
    try {
      final response = await _authRepo.getBusinesses();
      if (response.success && response.data != null) {
        final List<Business> list = [];
        for (var item in response.data!) {
          try {
            if (item is Map<String, dynamic> && item.containsKey('business')) {
              final bizJson = item['business'] as Map<String, dynamic>;
              final ownerJson = item['owner'] as Map<String, dynamic>?;
              final ownerId = ownerJson?['userId'] ?? '';

              final locs = bizJson['locations'] as List<dynamic>?;
              final String shopAddress;
              final String city;
              if (locs != null && locs.isNotEmpty) {
                final firstLoc = locs.first as Map<String, dynamic>;
                city = firstLoc['areaCity'] ?? '';
                final addrParts = [
                  firstLoc['shopAddress'] ?? '',
                  firstLoc['areaCity'] ?? '',
                  firstLoc['state'] ?? '',
                  firstLoc['pincode'] ?? '',
                ].where((part) => part.toString().trim().isNotEmpty).toList();
                shopAddress = addrParts.join(', ');
              } else {
                shopAddress = '';
                city = '';
              }

              final contactInfo =
                  bizJson['contactInfo'] as Map<String, dynamic>?;
              final contact =
                  contactInfo?['mobile1'] ?? ownerJson?['phoneNumber'] ?? '';
              final ownerName = (ownerJson != null)
                  ? "${ownerJson['firstName'] ?? ''} ${ownerJson['lastName'] ?? ''}"
                        .trim()
                  : (bizJson['ownerName'] ?? '');

              list.add(
                Business(
                  id: ownerId,
                  name: bizJson['businessName'] ?? '',
                  category: bizJson['category'] ?? '',
                  subCategory: bizJson['subCategory'] ?? '',
                  address: shopAddress,
                  city: city,
                  contact: contact,
                  description: bizJson['description'] ?? '',
                  ownerId: ownerId,
                  createdAt: DateTime.now(),
                  ownerName: ownerName,
                ),
              );
            } else if (item is Map<String, dynamic> &&
                item.containsKey('workDetails')) {
              final user = UserModel.fromJson(item);
              if (user.workDetails?.businessDetails != null) {
                final biz = user.workDetails!.businessDetails!;
                final String shopAddress;
                final String city;
                if (biz.locations.isNotEmpty) {
                  final firstLoc = biz.locations.first;
                  city = firstLoc.areaCity;
                  final addrParts = [
                    firstLoc.shopAddress,
                    firstLoc.areaCity,
                    firstLoc.state,
                    firstLoc.pincode,
                  ].where((part) => part.trim().isNotEmpty).toList();
                  shopAddress = addrParts.join(', ');
                } else {
                  shopAddress = '';
                  city = '';
                }

                list.add(
                  Business(
                    id: user.id,
                    name: biz.businessName,
                    category: biz.category,
                    subCategory: biz.subCategory,
                    address: shopAddress,
                    city: city,
                    contact: biz.contactInfo?.mobile1 ?? user.phoneNumber,
                    description: biz.description,
                    ownerId: user.id,
                    createdAt: user.createdAt ?? DateTime.now(),
                    ownerName: biz.ownerName.isNotEmpty
                        ? biz.ownerName
                        : '${user.firstName} ${user.lastName}'.trim(),
                  ),
                );
              }
            } else {
              list.add(Business.fromJson(item as Map<String, dynamic>));
            }
          } catch (e) {
            // Ignore single item errors
          }
        }
        businesses.assignAll(list);
      }
    } catch (e) {
      Get.printError(info: 'fetchBusinesses error: $e');
    } finally {
      isBusinessesLoading.value = false;
    }
  }

  List<FamilyMember> get filteredFamilyMembers {
    if (familySearchQuery.value.trim().isEmpty) return familyMembers;
    final q = familySearchQuery.value.toLowerCase();
    return familyMembers
        .where(
          (m) =>
              m.firstName.toLowerCase().contains(q) ||
              m.middleName.toLowerCase().contains(q) ||
              m.lastName.toLowerCase().contains(q) ||
              (m.occupation?.toLowerCase().contains(q) ?? false) ||
              m.relation.toLowerCase().contains(q),
        )
        .toList();
  }

  List<Business> get filteredBusinesses {
    if (businessSearchQuery.value.trim().isEmpty) return businesses;
    final q = businessSearchQuery.value.toLowerCase();
    return businesses
        .where(
          (b) =>
              b.name.toLowerCase().contains(q) ||
              b.category.toLowerCase().contains(q) ||
              b.description.toLowerCase().contains(q) ||
              b.address.toLowerCase().contains(q),
        )
        .toList();
  }

  Future<void> addFamilyMember({
    required String firstName,
    required String middleName,
    required String lastName,
    required String dob,
    required String relation,
    required String phoneNumber,
    required String occupation,
    required String education,
    required String isMarried,
    required String bloodGroup,
    required String skills,
  }) async {
    isLoading.value = true;
    try {
      final payload = {
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'dob': dob,
        'relation': relation,
        'phoneNumber': phoneNumber,
        'occupation': occupation,
        'education': education,
        'isMarried': isMarried,
        'bloodGroup': bloodGroup,
        'skills': skills,
      };

      final response = await _authRepo.addFamilyMember(payload);
      if (response.success && response.data != null) {
        currentUser.value = response.data;
        await _storage.saveUser(response.data!);
        familyMembers.assignAll(response.data!.familyMembers);
      } else {
        _addLocalFamilyMember(
          firstName: firstName,
          middleName: middleName,
          lastName: lastName,
          dob: dob,
          relation: relation,
          phoneNumber: phoneNumber,
          occupation: occupation,
          education: education,
          isMarried: isMarried,
          bloodGroup: bloodGroup,
          skills: skills,
        );
      }
    } catch (e) {
      Get.printError(info: 'addFamilyMember error: $e');
      _addLocalFamilyMember(
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        dob: dob,
        relation: relation,
        phoneNumber: phoneNumber,
        occupation: occupation,
        education: education,
        isMarried: isMarried,
        bloodGroup: bloodGroup,
        skills: skills,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _addLocalFamilyMember({
    required String firstName,
    required String middleName,
    required String lastName,
    required String dob,
    required String relation,
    required String phoneNumber,
    required String occupation,
    required String education,
    required String isMarried,
    required String bloodGroup,
    required String skills,
  }) {
    familyMembers.add(
      FamilyMember(
        id: _uuid.v4(),
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        dob: dob,
        relation: relation,
        phoneNumber: phoneNumber,
        occupation: occupation,
        education: education,
        isMarried: isMarried,
        bloodGroup: bloodGroup,
        skills: skills,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> updateFamilyMember(FamilyMember updated) async {
    isLoading.value = true;
    try {
      final payload = {
        'firstName': updated.firstName,
        'middleName': updated.middleName,
        'lastName': updated.lastName,
        'dob': updated.dob,
        'relation': updated.relation,
        'phoneNumber': updated.phoneNumber,
        'occupation': updated.occupation,
        'education': updated.education,
        'isMarried': updated.isMarried,
        'bloodGroup': updated.bloodGroup,
        'skills': updated.skills,
      };

      final response = await _authRepo.updateFamilyMember(
        updated.id ?? '',
        payload,
      );
      if (response.success && response.data != null) {
        currentUser.value = response.data;
        await _storage.saveUser(response.data!);
        familyMembers.assignAll(response.data!.familyMembers);
      } else {
        _updateLocalFamilyMember(updated);
      }
    } catch (e) {
      Get.printError(info: 'updateFamilyMember error: $e');
      _updateLocalFamilyMember(updated);
    } finally {
      isLoading.value = false;
    }
  }

  void _updateLocalFamilyMember(FamilyMember updated) {
    final i = familyMembers.indexWhere((m) => m.id == updated.id);
    if (i != -1) {
      familyMembers[i] = updated;
    }
  }

  Future<void> deleteFamilyMember(String id) async {
    isLoading.value = true;
    try {
      final response = await _authRepo.deleteFamilyMember(id);
      if (response.success && response.data != null) {
        currentUser.value = response.data;
        await _storage.saveUser(response.data!);
        familyMembers.assignAll(response.data!.familyMembers);
      } else {
        _deleteLocalFamilyMember(id);
      }
    } catch (e) {
      Get.printError(info: 'deleteFamilyMember error: $e');
      _deleteLocalFamilyMember(id);
    } finally {
      isLoading.value = false;
    }
  }

  void _deleteLocalFamilyMember(String id) {
    familyMembers.removeWhere((m) => m.id == id);
  }

  void addBusiness({
    required String name,
    required String category,
    required String subCategory,
    required String address,
    required String city,
    required String contact,
    required String description,
    required String ownerName,
    String? ownerId,
  }) {
    businesses.add(
      Business(
        id: _uuid.v4(),
        name: name,
        category: category,
        subCategory: subCategory,
        address: address,
        city: city,
        contact: contact,
        description: description,
        ownerId: ownerId,
        createdAt: DateTime.now(),
        ownerName: ownerName,
      ),
    );
    // TODO: persist via API
  }
}
