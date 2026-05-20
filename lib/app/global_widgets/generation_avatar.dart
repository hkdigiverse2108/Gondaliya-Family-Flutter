import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/values/colors.dart';

class GenerationAvatar extends StatelessWidget {
  final String name;
  final Color color;
  final double radius;

  const GenerationAvatar({
    super.key,
    required this.name,
    required this.color,
    this.radius = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2.w),
      ),
      child: CircleAvatar(
        radius: radius.r,
        backgroundColor: color.withValues(alpha: 0.1),
        child: Text(
          name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'M',
          style: GoogleFonts.outfit(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: (radius * 0.7).sp,
          ),
        ),
      ),
    );
  }

  /// Returns a generation color based on relationship and age.
  static Color getGenerationColor(String relationship, int age) {
    final rel = relationship.toLowerCase();
    if (age >= 55 ||
        rel.contains('grand') ||
        rel.contains('elder') ||
        rel.contains('uncle') ||
        rel.contains('aunt')) {
      return AppColors.goldAccent;
    } else if (age < 18 ||
        rel.contains('son') ||
        rel.contains('daughter') ||
        rel.contains('child') ||
        rel.contains('niece') ||
        rel.contains('nephew')) {
      return AppColors.secondary;
    } else {
      return AppColors.primaryLight;
    }
  }
}
