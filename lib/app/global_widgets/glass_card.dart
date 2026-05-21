import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_color_scheme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color? fillColor;
  final double blurSigma;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 18.0,
    this.fillColor,
    this.blurSigma = 16.0,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color:
                  fillColor ??
                  (colors.isDark
                      ? colors.card.withValues(alpha: 0.65)
                      : colors.card.withValues(alpha: 0.75)),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: colors.isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.white.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
