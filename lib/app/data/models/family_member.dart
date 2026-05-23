import 'package:equatable/equatable.dart';
import 'work_details.dart';

class FamilyMember extends Equatable {
  final String? id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String? profilePhoto;
  final String relation;
  final String dob;
  final String education;
  final String? occupation;
  final String isMarried;
  final String bloodGroup;
  final String? skills;
  final String phoneNumber;
  final WorkDetails? workDetails;
  final DateTime? createdAt;

  const FamilyMember({
    this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    this.profilePhoto,
    required this.relation,
    required this.dob,
    required this.education,
    this.occupation,
    required this.isMarried,
    required this.bloodGroup,
    this.skills,
    required this.phoneNumber,
    this.workDetails,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'profilePhoto': profilePhoto,
      'relation': relation,
      'dob': dob,
      'education': education,
      'occupation': occupation,
      'isMarried': isMarried,
      'bloodGroup': bloodGroup,
      'skills': skills,
      'phoneNumber': phoneNumber,
      'workDetails': workDetails?.toJson() ?? {},
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['_id'] as String? ?? json['id'] as String?,
      firstName: json['firstName'] as String? ?? '',
      middleName: json['middleName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      profilePhoto: json['profilePhoto'] == 'null'
          ? null
          : json['profilePhoto'] as String?,
      relation: json['relation'] as String? ?? '',
      dob: json['dob'] as String? ?? '',
      education: json['education'] as String? ?? '',
      occupation: json['occupation'] as String?,
      isMarried: json['isMarried'] as String? ?? '',
      bloodGroup: json['bloodGroup'] as String? ?? '',
      skills: json['skills'] as String?,
      phoneNumber: json['phoneNumber'] as String? ?? '',
      workDetails:
          json['workDetails'] != null && json['workDetails'].toString() != '{}'
          ? WorkDetails.fromJson(json['workDetails'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  FamilyMember copyWith({
    String? id,
    String? firstName,
    String? middleName,
    String? lastName,
    String? profilePhoto,
    String? relation,
    String? dob,
    String? education,
    String? occupation,
    String? isMarried,
    String? bloodGroup,
    String? skills,
    String? phoneNumber,
    WorkDetails? workDetails,
    DateTime? createdAt,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      relation: relation ?? this.relation,
      dob: dob ?? this.dob,
      education: education ?? this.education,
      occupation: occupation ?? this.occupation,
      isMarried: isMarried ?? this.isMarried,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      skills: skills ?? this.skills,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      workDetails: workDetails ?? this.workDetails,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    firstName,
    middleName,
    lastName,
    profilePhoto,
    relation,
    dob,
    education,
    occupation,
    isMarried,
    bloodGroup,
    skills,
    phoneNumber,
    workDetails,
    createdAt,
  ];

  @override
  bool get stringify => true;
}
