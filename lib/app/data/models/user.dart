import 'family_member.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String phoneNumber;
  final String password;
  final String name;
  final String surname;
  final String fatherName;
  final String village;
  final String pincode;
  final String taluka;
  final String district;
  final String currentAddress;
  final String houseType; // 'Owned' or 'Rented'
  final String mobile1;
  final String mobile2;
  final String occupationType; // 'Business', 'Job', 'None'
  final String? businessName;
  final String? businessCategory;
  final String? businessAddress;
  final String? companyName;
  final String? jobRole;
  final String? companyAddress;
  final List<FamilyMember> familyMembers;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.phoneNumber,
    required this.password,
    required this.name,
    required this.surname,
    required this.fatherName,
    required this.village,
    required this.pincode,
    required this.taluka,
    required this.district,
    required this.currentAddress,
    required this.houseType,
    required this.mobile1,
    required this.mobile2,
    required this.occupationType,
    this.businessName,
    this.businessCategory,
    this.businessAddress,
    this.companyName,
    this.jobRole,
    this.companyAddress,
    required this.familyMembers,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'password': password,
      'name': name,
      'surname': surname,
      'fatherName': fatherName,
      'village': village,
      'pincode': pincode,
      'taluka': taluka,
      'district': district,
      'currentAddress': currentAddress,
      'houseType': houseType,
      'mobile1': mobile1,
      'mobile2': mobile2,
      'occupationType': occupationType,
      'businessName': businessName,
      'businessCategory': businessCategory,
      'businessAddress': businessAddress,
      'companyName': companyName,
      'jobRole': jobRole,
      'companyAddress': companyAddress,
      'familyMembers': familyMembers.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      fatherName: json['fatherName'] as String,
      village: json['village'] as String,
      pincode: json['pincode'] as String,
      taluka: json['taluka'] as String,
      district: json['district'] as String,
      currentAddress: json['currentAddress'] as String,
      houseType: json['houseType'] as String,
      mobile1: json['mobile1'] as String,
      mobile2: json['mobile2'] as String,
      occupationType: json['occupationType'] as String? ?? 'None',
      businessName: json['businessName'] as String?,
      businessCategory: json['businessCategory'] as String?,
      businessAddress: json['businessAddress'] as String?,
      companyName: json['companyName'] as String?,
      jobRole: json['jobRole'] as String?,
      companyAddress: json['companyAddress'] as String?,
      familyMembers:
          (json['familyMembers'] as List<dynamic>?)
              ?.map((e) => FamilyMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  UserModel copyWith({
    String? id,
    String? phoneNumber,
    String? password,
    String? name,
    String? surname,
    String? fatherName,
    String? village,
    String? pincode,
    String? taluka,
    String? district,
    String? currentAddress,
    String? houseType,
    String? mobile1,
    String? mobile2,
    String? occupationType,
    String? businessName,
    String? businessCategory,
    String? businessAddress,
    String? companyName,
    String? jobRole,
    String? companyAddress,
    List<FamilyMember>? familyMembers,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      fatherName: fatherName ?? this.fatherName,
      village: village ?? this.village,
      pincode: pincode ?? this.pincode,
      taluka: taluka ?? this.taluka,
      district: district ?? this.district,
      currentAddress: currentAddress ?? this.currentAddress,
      houseType: houseType ?? this.houseType,
      mobile1: mobile1 ?? this.mobile1,
      mobile2: mobile2 ?? this.mobile2,
      occupationType: occupationType ?? this.occupationType,
      businessName: businessName ?? this.businessName,
      businessCategory: businessCategory ?? this.businessCategory,
      businessAddress: businessAddress ?? this.businessAddress,
      companyName: companyName ?? this.companyName,
      jobRole: jobRole ?? this.jobRole,
      companyAddress: companyAddress ?? this.companyAddress,
      familyMembers: familyMembers ?? this.familyMembers,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    phoneNumber,
    password,
    name,
    surname,
    fatherName,
    village,
    pincode,
    taluka,
    district,
    currentAddress,
    houseType,
    mobile1,
    mobile2,
    occupationType,
    businessName,
    businessCategory,
    businessAddress,
    companyName,
    jobRole,
    companyAddress,
    familyMembers,
    createdAt,
  ];

  @override
  bool get stringify => true;
}
