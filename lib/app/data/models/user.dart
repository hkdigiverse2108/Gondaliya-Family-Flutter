import 'package:equatable/equatable.dart';
import 'family_member.dart';
import 'work_details.dart';

class UserModel extends Equatable {
  final String id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String dob;
  final String bloodGroup;
  final String education;
  final String isMarried;
  final String phoneNumber;
  final String? password;
  final String? profilePhoto;
  final bool isActive;
  final String? nativeVillage;
  final String? nativeTaluka;
  final String? nativeDistrict;
  final String village;
  final String pincode;
  final String taluka;
  final String district;
  final String currentAddress;
  final String? currentCity;
  final String? currentState;
  final String houseType;
  final String? phoneNumber2;
  final List<FamilyMember> familyMembers;
  final WorkDetails? workDetails;

  // Login / Auth extras
  final String? role;
  final String? token;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.dob,
    required this.bloodGroup,
    required this.education,
    required this.isMarried,
    required this.phoneNumber,
    this.password,
    this.profilePhoto,
    this.isActive = true,
    this.nativeVillage,
    this.nativeTaluka,
    this.nativeDistrict,
    required this.village,
    required this.pincode,
    required this.taluka,
    required this.district,
    required this.currentAddress,
    this.currentCity,
    this.currentState,
    required this.houseType,
    this.phoneNumber2,
    required this.familyMembers,
    this.workDetails,
    this.role,
    this.token,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'dob': dob,
      'bloodGroup': bloodGroup,
      'education': education,
      'isMarried': isMarried,
      'phoneNumber': phoneNumber,
      'password': password,
      'profilePhoto': profilePhoto,
      'isActive': isActive,
      'nativeVillage': nativeVillage,
      'nativeTaluka': nativeTaluka,
      'nativeDistrict': nativeDistrict,
      'village': village,
      'pincode': pincode,
      'taluka': taluka,
      'district': district,
      'currentAddress': currentAddress,
      'currentCity': currentCity,
      'currentState': currentState,
      'houseType': houseType,
      'phoneNumber2': phoneNumber2,
      'familyMembers': familyMembers.map((e) => e.toJson()).toList(),
      'workDetails': workDetails?.toJson(),
      'role': role,
      'token': token,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      middleName: json['middleName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      dob: json['dob'] as String? ?? '',
      bloodGroup: json['bloodGroup'] as String? ?? '',
      education: json['education'] as String? ?? '',
      isMarried: json['isMarried'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      password: json['password'] as String?,
      profilePhoto: json['profilePhoto'] == 'null'
          ? null
          : json['profilePhoto'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      nativeVillage: json['nativeVillage'] as String?,
      nativeTaluka: json['nativeTaluka'] as String?,
      nativeDistrict: json['nativeDistrict'] as String?,
      village: json['village'] as String? ?? '',
      pincode: json['pincode'] as String? ?? '',
      taluka: json['taluka'] as String? ?? '',
      district: json['district'] as String? ?? '',
      currentAddress: json['currentAddress'] as String? ?? '',
      currentCity: json['currentCity'] as String?,
      currentState: json['currentState'] as String?,
      houseType: json['houseType'] as String? ?? '',
      phoneNumber2: json['phoneNumber2'] == 'null'
          ? null
          : json['phoneNumber2'] as String?,
      familyMembers:
          (json['familyMembers'] as List<dynamic>?)
              ?.map((e) => FamilyMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      workDetails: json['workDetails'] != null
          ? WorkDetails.fromJson(json['workDetails'] as Map<String, dynamic>)
          : null,
      role: json['role'] as String?,
      token: json['token'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  UserModel copyWith({
    String? id,
    String? firstName,
    String? middleName,
    String? lastName,
    String? dob,
    String? bloodGroup,
    String? education,
    String? isMarried,
    String? phoneNumber,
    String? password,
    String? profilePhoto,
    bool? isActive,
    String? nativeVillage,
    String? nativeTaluka,
    String? nativeDistrict,
    String? village,
    String? pincode,
    String? taluka,
    String? district,
    String? currentAddress,
    String? currentCity,
    String? currentState,
    String? houseType,
    String? phoneNumber2,
    List<FamilyMember>? familyMembers,
    WorkDetails? workDetails,
    String? role,
    String? token,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      dob: dob ?? this.dob,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      education: education ?? this.education,
      isMarried: isMarried ?? this.isMarried,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      isActive: isActive ?? this.isActive,
      nativeVillage: nativeVillage ?? this.nativeVillage,
      nativeTaluka: nativeTaluka ?? this.nativeTaluka,
      nativeDistrict: nativeDistrict ?? this.nativeDistrict,
      village: village ?? this.village,
      pincode: pincode ?? this.pincode,
      taluka: taluka ?? this.taluka,
      district: district ?? this.district,
      currentAddress: currentAddress ?? this.currentAddress,
      currentCity: currentCity ?? this.currentCity,
      currentState: currentState ?? this.currentState,
      houseType: houseType ?? this.houseType,
      phoneNumber2: phoneNumber2 ?? this.phoneNumber2,
      familyMembers: familyMembers ?? this.familyMembers,
      workDetails: workDetails ?? this.workDetails,
      role: role ?? this.role,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    firstName,
    middleName,
    lastName,
    dob,
    bloodGroup,
    education,
    isMarried,
    phoneNumber,
    password,
    profilePhoto,
    isActive,
    nativeVillage,
    nativeTaluka,
    nativeDistrict,
    village,
    pincode,
    taluka,
    district,
    currentAddress,
    currentCity,
    currentState,
    houseType,
    phoneNumber2,
    familyMembers,
    workDetails,
    role,
    token,
    createdAt,
  ];

  @override
  bool get stringify => true;
}
