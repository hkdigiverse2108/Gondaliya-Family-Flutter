import '../../../core/utils/extensions/safe_json_map_extensions.dart';

class ParivarDirectory {
  final String id;
  final ParivarHead head;
  final List<ParivarFamilyMember> familyMembers;

  ParivarDirectory({
    required this.id,
    required this.head,
    required this.familyMembers,
  });

  factory ParivarDirectory.fromJson(Map<String, dynamic> json) {
    return ParivarDirectory(
      id: json.getString('_id'),
      head: ParivarHead.fromJson(json.getMap('head')),
      familyMembers: (json
          .getList<ParivarFamilyMember>('familyMembers')
          .map((e) => ParivarFamilyMember.fromJson(e as Map<String, dynamic>))
          .toList()),
    );
  }
}

class ParivarHead {
  final String firstName;
  final String lastName;
  final String village;
  final String phoneNumber;
  final String? workDetailsSummary;
  final String? profilePhoto;

  ParivarHead({
    required this.firstName,
    required this.lastName,
    required this.village,
    required this.phoneNumber,
    this.workDetailsSummary,
    this.profilePhoto,
  });

  factory ParivarHead.fromJson(Map<String, dynamic> json) {
    return ParivarHead(
      firstName: json.getString('firstName'),
      lastName: json.getString('lastName'),
      village: json.getString('village'),
      phoneNumber: json.getString('phoneNumber'),
      workDetailsSummary: json.getString('workDetailsSummary'),
      profilePhoto: json.getOrNull('profilePhoto') == null
          ? null
          : json.getString('profilePhoto'),
    );
  }
}

class ParivarFamilyMember {
  final String id;
  final String firstName;
  final String lastName;
  final String relation;
  final String? phoneNumber;
  final String? workDetailsSummary;
  final bool isIndependent;
  final String? linkedUserId;
  final String? profilePhoto;

  ParivarFamilyMember({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.relation,
    this.phoneNumber,
    this.workDetailsSummary,
    this.isIndependent = false,
    this.linkedUserId,
    this.profilePhoto,
  });

  factory ParivarFamilyMember.fromJson(Map<String, dynamic> json) {
    return ParivarFamilyMember(
      id: json.getOrNull('_id') ?? json.getString('id'),
      firstName: json.getString('firstName'),
      lastName: json.getString('lastName'),
      relation: json.getString('relation'),
      phoneNumber: json.getString('phoneNumber'),
      workDetailsSummary: json.getString('workDetailsSummary'),
      isIndependent: json.getBool('isIndependent'),
      linkedUserId: json.getOrNull('linkedUserId'),
      profilePhoto: json.getOrNull('profilePhoto') == null
          ? null
          : json.getString('profilePhoto'),
    );
  }
}
