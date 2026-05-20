import 'package:equatable/equatable.dart';

class FamilyMember extends Equatable {
  final String id;
  final String name;
  final String surname;
  final String fatherName;
  final int age;
  final String relationship;
  final String phoneNumber;
  final String occupation;
  final String birthDate; // DD/MM/YYYY
  final String education;
  final bool isMarried;
  final String bloodGroup;
  final String skill;
  final String notes;
  final DateTime createdAt;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.surname,
    required this.fatherName,
    required this.age,
    required this.relationship,
    required this.phoneNumber,
    required this.occupation,
    required this.birthDate,
    required this.education,
    required this.isMarried,
    required this.bloodGroup,
    required this.skill,
    required this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'fatherName': fatherName,
      'age': age,
      'relationship': relationship,
      'phoneNumber': phoneNumber,
      'occupation': occupation,
      'birthDate': birthDate,
      'education': education,
      'isMarried': isMarried,
      'bloodGroup': bloodGroup,
      'skill': skill,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      fatherName: json['fatherName'] as String,
      age: json['age'] as int,
      relationship: json['relationship'] as String,
      phoneNumber: json['phoneNumber'] as String,
      occupation: json['occupation'] as String,
      birthDate: json['birthDate'] as String? ?? '',
      education: json['education'] as String? ?? '',
      isMarried: json['isMarried'] as bool? ?? false,
      bloodGroup: json['bloodGroup'] as String? ?? '',
      skill: json['skill'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  FamilyMember copyWith({
    String? id,
    String? name,
    String? surname,
    String? fatherName,
    int? age,
    String? relationship,
    String? phoneNumber,
    String? occupation,
    String? birthDate,
    String? education,
    bool? isMarried,
    String? bloodGroup,
    String? skill,
    String? notes,
    DateTime? createdAt,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      fatherName: fatherName ?? this.fatherName,
      age: age ?? this.age,
      relationship: relationship ?? this.relationship,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      occupation: occupation ?? this.occupation,
      birthDate: birthDate ?? this.birthDate,
      education: education ?? this.education,
      isMarried: isMarried ?? this.isMarried,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      skill: skill ?? this.skill,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    surname,
    fatherName,
    age,
    relationship,
    phoneNumber,
    occupation,
    birthDate,
    education,
    isMarried,
    bloodGroup,
    skill,
    notes,
    createdAt,
  ];

  @override
  bool get stringify => true;
}
