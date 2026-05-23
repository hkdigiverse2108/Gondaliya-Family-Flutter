import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/family_member.dart';
import '../../../data/models/business.dart';

class ProfileController extends GetxController {
  final _uuid = const Uuid();

  final familyMembers = <FamilyMember>[].obs;
  final businesses = <Business>[].obs;

  final familySearchQuery = ''.obs;
  final businessSearchQuery = ''.obs;

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

  void addFamilyMember({
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
    // TODO: persist via API
  }

  void updateFamilyMember(FamilyMember updated) {
    final i = familyMembers.indexWhere((m) => m.id == updated.id);
    if (i != -1) {
      familyMembers[i] = updated;
      // TODO: persist via API
    }
  }

  void deleteFamilyMember(String id) {
    familyMembers.removeWhere((m) => m.id == id);
    // TODO: persist via API
  }

  void addBusiness({
    required String name,
    required String category,
    required String address,
    required String contact,
    required String description,
    String? ownerId,
  }) {
    businesses.add(
      Business(
        id: _uuid.v4(),
        name: name,
        category: category,
        address: address,
        contact: contact,
        description: description,
        ownerId: ownerId,
        createdAt: DateTime.now(),
      ),
    );
    // TODO: persist via API
  }
}
