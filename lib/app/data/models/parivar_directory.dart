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
      id: json['_id'] ?? '',
      head: ParivarHead.fromJson(json['head'] ?? {}),
      familyMembers:
          (json['familyMembers'] as List<dynamic>?)
              ?.map(
                (e) => ParivarFamilyMember.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

class ParivarHead {
  final String firstName;
  final String lastName;
  final String village;
  final String phoneNumber;
  final String? workDetailsSummary;

  ParivarHead({
    required this.firstName,
    required this.lastName,
    required this.village,
    required this.phoneNumber,
    this.workDetailsSummary,
  });

  factory ParivarHead.fromJson(Map<String, dynamic> json) {
    return ParivarHead(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      village: json['village'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      workDetailsSummary: json['workDetailsSummary'],
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

  ParivarFamilyMember({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.relation,
    this.phoneNumber,
    this.workDetailsSummary,
    this.isIndependent = false,
    this.linkedUserId,
  });

  factory ParivarFamilyMember.fromJson(Map<String, dynamic> json) {
    return ParivarFamilyMember(
      id: json['_id'] ?? json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      relation: json['relation'] ?? '',
      phoneNumber: json['phoneNumber'],
      workDetailsSummary: json['workDetailsSummary'],
      isIndependent: json['isIndependent'] ?? false,
      linkedUserId: json['linkedUserId'],
    );
  }
}
