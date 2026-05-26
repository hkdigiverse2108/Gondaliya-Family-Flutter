import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../data/models/family_member.dart';
import '../../../data/models/user.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/repositories/auth_repository.dart';

class ProfileController extends GetxController {
  final _uuid = const Uuid();
  final _storage = Get.find<StorageService>();
  final _authRepo = AuthRepository();

  final currentUser = Rxn<UserModel>();
  final isLoading = false.obs;
  final familyMembers = <FamilyMember>[].obs;
  final familySearchQuery = ''.obs;

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

  /// Pick and upload a new profile photo directly using FilePicker
  Future<void> pickAndUploadProfilePhoto() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'gif', 'pdf'],
      );

      if (result == null || result.files.single.path == null) {
        return;
      }

      final pickedPath = result.files.single.path!;
      
      isLoading.value = true;
      Get.snackbar(
        'Uploading...',
        'Please wait while your profile photo is being uploaded.',
        snackPosition: SnackPosition.BOTTOM,
        showProgressIndicator: true,
      );

      // 1. Upload to centralized upload API with old file replacement
      final uploadResp = await _authRepo.uploadFile(
        filePath: pickedPath,
        oldFileUrl: currentUser.value?.profilePhoto,
      );

      if (uploadResp.success && uploadResp.data != null) {
        final uploadedUrl = uploadResp.data!['url'] as String;

        // 2. Perform direct user profile update with the new profilePhoto url
        final updateResp = await _authRepo.updateUser({
          'userId': currentUser.value!.id,
          'profilePhoto': uploadedUrl,
        });

        if (updateResp.success && updateResp.data != null) {
          currentUser.value = updateResp.data;
          await _storage.saveUser(updateResp.data!);
          familyMembers.assignAll(updateResp.data!.familyMembers);

          Get.closeAllSnackbars();
          Get.snackbar(
            'Success',
            'Profile photo updated successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.closeAllSnackbars();
          Get.snackbar(
            'Error',
            updateResp.message ?? 'Failed to update profile photo',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        Get.closeAllSnackbars();
        Get.snackbar(
          'Error',
          uploadResp.message ?? 'Failed to upload photo',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.printError(info: 'pickAndUploadProfilePhoto error: $e');
      Get.closeAllSnackbars();
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }



  Future<void> addFamilyMember({
    required String firstName,
    required String middleName,
    required String lastName,
    required String dob,
    required String relation,
    required String phoneNumber,
    required String education,
    required String isMarried,
    required String bloodGroup,
  }) async {
    isLoading.value = true;
    try {
      final normalizedIsMarried = isMarried.toLowerCase() == 'married'
          ? 'married'
          : 'unMarried';
      final payload = {
        'id': currentUser.value?.id ?? '',
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'dob': dob,
        'relation': relation,
        'phoneNumber': phoneNumber,
        'education': education,
        'isMarried': normalizedIsMarried,
        'bloodGroup': bloodGroup,
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
          education: education,
          isMarried: normalizedIsMarried,
          bloodGroup: bloodGroup,
        );
      }
    } catch (e) {
      Get.printError(info: 'addFamilyMember error: $e');
      final normalizedIsMarried = isMarried.toLowerCase() == 'married'
          ? 'married'
          : 'unMarried';
      _addLocalFamilyMember(
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        dob: dob,
        relation: relation,
        phoneNumber: phoneNumber,
        education: education,
        isMarried: normalizedIsMarried,
        bloodGroup: bloodGroup,
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
    required String education,
    required String isMarried,
    required String bloodGroup,
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
        education: education,
        isMarried: isMarried,
        bloodGroup: bloodGroup,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> updateFamilyMember(FamilyMember updated) async {
    isLoading.value = true;
    try {
      final normalizedIsMarried = updated.isMarried.toLowerCase() == 'married'
          ? 'married'
          : 'unMarried';
      final payload = {
        'id': currentUser.value?.id ?? '',
        'memberId': updated.id,
        'firstName': updated.firstName,
        'middleName': updated.middleName,
        'lastName': updated.lastName,
        'dob': updated.dob,
        'relation': updated.relation,
        'phoneNumber': updated.phoneNumber,
        'education': updated.education,
        'isMarried': normalizedIsMarried,
        'bloodGroup': updated.bloodGroup,
      };

      final response = await _authRepo.updateFamilyMember(payload);
      if (response.success && response.data != null) {
        currentUser.value = response.data;
        await _storage.saveUser(response.data!);
        familyMembers.assignAll(response.data!.familyMembers);
      } else {
        _updateLocalFamilyMember(
          updated.copyWith(isMarried: normalizedIsMarried),
        );
      }
    } catch (e) {
      Get.printError(info: 'updateFamilyMember error: $e');
      final normalizedIsMarried = updated.isMarried.toLowerCase() == 'married'
          ? 'married'
          : 'unMarried';
      _updateLocalFamilyMember(
        updated.copyWith(isMarried: normalizedIsMarried),
      );
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

  Future<void> deleteFamilyMember(String memberId) async {
    isLoading.value = true;
    try {
      final payload = {'id': currentUser.value?.id ?? '', 'memberId': memberId};
      final response = await _authRepo.deleteFamilyMember(payload);
      if (response.success && response.data != null) {
        currentUser.value = response.data;
        await _storage.saveUser(response.data!);
        familyMembers.assignAll(response.data!.familyMembers);
      } else {
        _deleteLocalFamilyMember(memberId);
      }
    } catch (e) {
      Get.printError(info: 'deleteFamilyMember error: $e');
      _deleteLocalFamilyMember(memberId);
    } finally {
      isLoading.value = false;
    }
  }

  void _deleteLocalFamilyMember(String id) {
    familyMembers.removeWhere((m) => m.id == id);
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

  Future<bool> submitFeedback({
    required String type,
    required String message,
  }) async {
    isLoading.value = true;
    try {
      final response = await _authRepo.addFeedback(
        type: type,
        message: message,
      );
      return response.success;
    } catch (e) {
      Get.printError(info: 'submitFeedback error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
