import 'package:flutter/material.dart';
import '../../core/values/colors.dart';

class NeomorphicCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double shadowDistance;
  final double shadowBlur;
  final VoidCallback? onTap;

  const NeomorphicCard({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.shadowDistance = 5.0,
    this.shadowBlur = 15.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        backgroundColor ?? (isDark ? AppColors.cardDark : AppColors.cardLight);

    final shadows = isDark
        ? AppColors.neumorphicShadowDark(
            blur: shadowBlur,
            distance: shadowDistance,
          )
        : AppColors.neumorphicShadowLight(
            blur: shadowBlur,
            distance: shadowDistance,
          );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: shadows,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(padding: padding, child: child),
        ),
      ),
    );
  }
}
