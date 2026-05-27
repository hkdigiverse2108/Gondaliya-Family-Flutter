import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/values/sizes.dart';
import '../../../global_widgets/neomorphic_text_field.dart';
import '../../../global_widgets/neomorphic_dropdown_field.dart';
import '../../../global_widgets/neomorphic_button.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/family_member.dart';
import '../../home/controllers/profile_controller.dart';

class FamilyMemberFormView extends StatefulWidget {
  const FamilyMemberFormView({super.key});

  @override
  State<FamilyMemberFormView> createState() => _FamilyMemberFormViewState();
}

class _FamilyMemberFormViewState extends State<FamilyMemberFormView> {
  final _formKey = GlobalKey<FormState>();
  final _profileController = Get.find<ProfileController>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _middleNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _dobController;
  late final TextEditingController _educationController;

  String? _selectedRelation;
  String? _selectedBloodGroup;
  String? _selectedMaritalStatus;

  FamilyMember? _member;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    // Parse arguments in initState
    final args = Get.arguments;
    if (args is Map<String, dynamic> && args.containsKey('member')) {
      _member = args['member'] as FamilyMember;
      _isEdit = true;
    }

    _firstNameController = TextEditingController(text: _member?.firstName);
    _middleNameController = TextEditingController(text: _member?.middleName);
    _lastNameController = TextEditingController(text: _member?.lastName);
    _phoneController = TextEditingController(text: _member?.phoneNumber);
    _dobController = TextEditingController(text: _member?.dob);
    _educationController = TextEditingController(text: _member?.education);

    _selectedRelation =
        (_member?.relation != null &&
            AppEnums.relations.contains(_member!.relation))
        ? _member!.relation
        : AppEnums.relations.first;

    _selectedBloodGroup =
        (_member?.bloodGroup != null &&
            AppEnums.bloodGroups.contains(_member!.bloodGroup))
        ? _member!.bloodGroup
        : AppEnums.bloodGroups.first;

    _selectedMaritalStatus =
        (_member?.isMarried != null && _member!.isMarried.isNotEmpty)
        ? (_member!.isMarried.toLowerCase() == 'married'
              ? 'married'
              : 'unMarried')
        : AppEnums.maritalStatus.first;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _educationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          _isEdit ? 'edit_member'.tr : 'add_member'.tr,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: colors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: colors.card,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.spacingL.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header card decoration
                Container(
                  padding: EdgeInsets.all(AppSizes.spacingL.w),
                  decoration: BoxDecoration(
                    color: colors.card,
                    borderRadius: BorderRadius.circular(AppSizes.radiusL.r),
                    border: Border.all(
                      color: colors.primary.withValues(alpha: 0.05),
                    ),
                    boxShadow: colors.neumorphicShadow(blur: 8, distance: 2),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28.r,
                        backgroundColor: colors.primary.withValues(alpha: 0.1),
                        child: Icon(
                          PhosphorIcons.userPlus(PhosphorIconsStyle.bold),
                          color: colors.primary,
                          size: 28.sp,
                        ),
                      ),
                      SizedBox(width: AppSizes.spacingL.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEdit
                                  ? 'Update Member Details'
                                  : 'Register Family Member',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: AppSizes.fontSizeBodyLarge.sp,
                                color: colors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Ensure information is accurate for village directory sync.',
                              style: GoogleFonts.outfit(
                                fontSize: AppSizes.fontSizeCaption.sp,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSizes.spacingXL.h),

                // Name Fields
                _buildSectionTitle('Personal Details', colors),
                SizedBox(height: AppSizes.spacingM.h),

                NeomorphicTextField(
                  controller: _firstNameController,
                  labelText: 'First Name',
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                    color: colors.textPrimary,
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'field_required'.tr
                      : null,
                ),
                SizedBox(height: AppSizes.spacingM.h),

                Row(
                  children: [
                    Expanded(
                      child: NeomorphicTextField(
                        controller: _middleNameController,
                        labelText: 'Middle Name',
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSizes.spacingM.w),
                    Expanded(
                      child: NeomorphicTextField(
                        controller: _lastNameController,
                        labelText: 'Last Name',
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          color: colors.textPrimary,
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'field_required'.tr
                            : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.spacingM.h),

                // Dropdown Relationship
                NeomorphicDropdownField<String>(
                  value: _selectedRelation,
                  labelText: 'relationship'.tr,
                  prefixIcon: Icon(
                    Icons.family_restroom_rounded,
                    color: colors.textPrimary,
                  ),
                  items: AppEnums.relations.map((relation) {
                    return NeomorphicDropdownItem<String>(
                      value: relation,
                      label: relation.tr,
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedRelation = val;
                    });
                  },
                ),
                SizedBox(height: AppSizes.spacingXL.h),

                _buildSectionTitle('Contact & Attributes', colors),
                SizedBox(height: AppSizes.spacingM.h),

                NeomorphicTextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  labelText: 'phone_number'.tr,
                  prefixIcon: Icon(
                    Icons.phone_iphone_outlined,
                    color: colors.textPrimary,
                  ),
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        value.length != 10) {
                      return 'invalid_phone'.tr;
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSizes.spacingM.h),

                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              _dobController.text =
                                  "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
                            });
                          }
                        },
                        child: IgnorePointer(
                          child: NeomorphicTextField(
                            controller: _dobController,
                            labelText: 'birth_date'.tr,
                            prefixIcon: Icon(
                              Icons.cake_outlined,
                              color: colors.textPrimary,
                            ),
                            hintText: 'DD/MM/YYYY',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSizes.spacingM.w),
                    Expanded(
                      child: NeomorphicDropdownField<String>(
                        value: _selectedBloodGroup,
                        labelText: 'blood_group'.tr,
                        prefixIcon: Icon(
                          Icons.bloodtype_outlined,
                          color: colors.textPrimary,
                        ),
                        items: AppEnums.bloodGroups.map((bg) {
                          return NeomorphicDropdownItem<String>(
                            value: bg,
                            label: bg,
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedBloodGroup = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.spacingM.h),

                NeomorphicTextField(
                  controller: _educationController,
                  labelText: 'education'.tr,
                  prefixIcon: Icon(
                    Icons.school_outlined,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.spacingM.h),

                NeomorphicDropdownField<String>(
                  value: _selectedMaritalStatus,
                  labelText: 'marital_status'.tr,
                  prefixIcon: Icon(
                    Icons.favorite_border_rounded,
                    color: colors.textPrimary,
                  ),
                  items: AppEnums.maritalStatus.map((ms) {
                    return NeomorphicDropdownItem<String>(
                      value: ms,
                      label: ms.tr,
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedMaritalStatus = val;
                    });
                  },
                ),
                SizedBox(height: AppSizes.spacingXXL.h),

                // Save Button
                NeomorphicButton(
                  text: 'save'.tr,
                  isGradient: true,
                  gradientColors: colors.primaryGradient,
                  gradientBegin: Alignment.centerLeft,
                  gradientEnd: Alignment.centerRight,
                  onPressed: _saveMember,
                ),
                SizedBox(height: AppSizes.spacingXXL.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, AppColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: AppSizes.fontSizeBodyLarge.sp,
            color: colors.primary,
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          width: 40.w,
          height: 3.h,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(1.5.r),
          ),
        ),
      ],
    );
  }

  void _saveMember() {
    if (_formKey.currentState!.validate()) {
      if (_isEdit && _member != null) {
        _profileController.updateFamilyMember(
          _member!.copyWith(
            firstName: _firstNameController.text.trim(),
            middleName: _middleNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            relation: _selectedRelation ?? '',
            phoneNumber: _phoneController.text.trim(),
            dob: _dobController.text.trim(),
            education: _educationController.text.trim(),
            isMarried: _selectedMaritalStatus ?? 'unMarried',
            bloodGroup: _selectedBloodGroup ?? '',
          ),
        );
      } else {
        _profileController.addFamilyMember(
          firstName: _firstNameController.text.trim(),
          middleName: _middleNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          relation: _selectedRelation ?? '',
          phoneNumber: _phoneController.text.trim(),
          dob: _dobController.text.trim(),
          education: _educationController.text.trim(),
          isMarried: _selectedMaritalStatus ?? 'unMarried',
          bloodGroup: _selectedBloodGroup ?? '',
        );
      }
      Get.back();
      final colors = context.appColors;
      Get.snackbar(
        'Success',
        _isEdit ? 'Member updated successfully' : 'Member added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: colors.secondary.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    }
  }
}
