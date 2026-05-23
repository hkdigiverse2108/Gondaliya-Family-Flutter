class ParivarDirectory {
  final String id;
  final ParivarHead head;
  final List<dynamic> familyMembers;

  ParivarDirectory({
    required this.id,
    required this.head,
    required this.familyMembers,
  });

  factory ParivarDirectory.fromJson(Map<String, dynamic> json) {
    return ParivarDirectory(
      id: json['_id'] ?? '',
      head: ParivarHead.fromJson(json['head'] ?? {}),
      familyMembers: json['familyMembers'] ?? [],
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
