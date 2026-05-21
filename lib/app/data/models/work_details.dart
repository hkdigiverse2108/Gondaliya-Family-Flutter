import 'package:equatable/equatable.dart';

class WorkDetails extends Equatable {
  final bool hasOwnBusiness;
  final BusinessDetails? businessDetails;
  final JobDetails? jobDetails;

  const WorkDetails({
    required this.hasOwnBusiness,
    this.businessDetails,
    this.jobDetails,
  });

  factory WorkDetails.fromJson(Map<String, dynamic> json) {
    return WorkDetails(
      hasOwnBusiness: json['hasOwnBusiness'] as bool? ?? false,
      businessDetails: json['businessDetails'] != null
          ? BusinessDetails.fromJson(json['businessDetails'] as Map<String, dynamic>)
          : null,
      jobDetails: json['jobDetails'] != null
          ? JobDetails.fromJson(json['jobDetails'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasOwnBusiness': hasOwnBusiness,
      'businessDetails': businessDetails?.toJson(),
      'jobDetails': jobDetails?.toJson(),
    };
  }

  @override
  List<Object?> get props => [hasOwnBusiness, businessDetails, jobDetails];
}

class BusinessDetails extends Equatable {
  final String category;
  final String subCategory;
  final String businessName;
  final String ownerName;
  final String description;
  final List<BusinessLocation> locations;
  final ContactInfo? contactInfo;

  const BusinessDetails({
    required this.category,
    required this.subCategory,
    required this.businessName,
    required this.ownerName,
    required this.description,
    required this.locations,
    this.contactInfo,
  });

  factory BusinessDetails.fromJson(Map<String, dynamic> json) {
    return BusinessDetails(
      category: json['category'] as String? ?? '',
      subCategory: json['subCategory'] as String? ?? '',
      businessName: json['businessName'] as String? ?? '',
      ownerName: json['ownerName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      locations: (json['locations'] as List<dynamic>?)
              ?.map((e) => BusinessLocation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      contactInfo: json['contactInfo'] != null
          ? ContactInfo.fromJson(json['contactInfo'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'subCategory': subCategory,
      'businessName': businessName,
      'ownerName': ownerName,
      'description': description,
      'locations': locations.map((e) => e.toJson()).toList(),
      'contactInfo': contactInfo?.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        category,
        subCategory,
        businessName,
        ownerName,
        description,
        locations,
        contactInfo,
      ];
}

class BusinessLocation extends Equatable {
  final String shopAddress;
  final String areaCity;
  final String state;
  final String pincode;
  final String googleMapLink;

  const BusinessLocation({
    required this.shopAddress,
    required this.areaCity,
    required this.state,
    required this.pincode,
    required this.googleMapLink,
  });

  factory BusinessLocation.fromJson(Map<String, dynamic> json) {
    return BusinessLocation(
      shopAddress: json['shopAddress'] as String? ?? '',
      areaCity: json['areaCity'] as String? ?? '',
      state: json['state'] as String? ?? '',
      pincode: json['pincode'] as String? ?? '',
      googleMapLink: json['googleMapLink'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shopAddress': shopAddress,
      'areaCity': areaCity,
      'state': state,
      'pincode': pincode,
      'googleMapLink': googleMapLink,
    };
  }

  @override
  List<Object?> get props => [shopAddress, areaCity, state, pincode, googleMapLink];
}

class ContactInfo extends Equatable {
  final String mobile1;
  final String mobile2;
  final String email;
  final String website;
  final String portfolioLink;

  const ContactInfo({
    required this.mobile1,
    required this.mobile2,
    required this.email,
    required this.website,
    required this.portfolioLink,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      mobile1: json['mobile1'] as String? ?? '',
      mobile2: json['mobile2'] as String? ?? '',
      email: json['email'] as String? ?? '',
      website: json['website'] as String? ?? '',
      portfolioLink: json['portfolioLink'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mobile1': mobile1,
      'mobile2': mobile2,
      'email': email,
      'website': website,
      'portfolioLink': portfolioLink,
    };
  }

  @override
  List<Object?> get props => [mobile1, mobile2, email, website, portfolioLink];
}

class JobDetails extends Equatable {
  final String jobCategory;
  final String jobRole;
  final String companyName;
  final String jobLocation;

  const JobDetails({
    required this.jobCategory,
    required this.jobRole,
    required this.companyName,
    required this.jobLocation,
  });

  factory JobDetails.fromJson(Map<String, dynamic> json) {
    return JobDetails(
      jobCategory: json['jobCategory'] as String? ?? '',
      jobRole: json['jobRole'] as String? ?? '',
      companyName: json['companyName'] as String? ?? '',
      jobLocation: json['jobLocation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobCategory': jobCategory,
      'jobRole': jobRole,
      'companyName': companyName,
      'jobLocation': jobLocation,
    };
  }

  @override
  List<Object?> get props => [jobCategory, jobRole, companyName, jobLocation];
}
