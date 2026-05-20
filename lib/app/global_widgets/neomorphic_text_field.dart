import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/values/sizes.dart';
import '../../core/values/colors.dart';

class NeomorphicTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final int maxLines;
  final bool enabled;
  final bool showValidationIcon;

  const NeomorphicTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.isPassword = false,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.maxLines = 1,
    this.enabled = true,
    this.showValidationIcon = true,
  });

  @override
  State<NeomorphicTextField> createState() => _NeomorphicTextFieldState();
}

class _NeomorphicTextFieldState extends State<NeomorphicTextField>
    with SingleTickerProviderStateMixin {
  late bool _obscureText;
  bool _isFocused = false;
  late FocusNode _focusNode;
  String? _errorText;
  late AnimationController _focusAnimationController;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode = FocusNode();
    _focusAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
        if (_isFocused) {
          _focusAnimationController.forward();
        } else {
          _focusAnimationController.reverse();
        }
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Inset shadows for neumorphic effect
    final insetShadows = isDark
        ? AppColors.neumorphicInsetShadowDark()
        : AppColors.neumorphicInsetShadowLight();

    // Focus shadows - slightly more pronounced
    final focusShadows = isDark
        ? AppColors.neumorphicShadowDark(blur: 12, distance: 3)
        : AppColors.neumorphicShadowLight(blur: 12, distance: 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isFocused ? focusShadows : insetShadows,
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType,
            validator: (value) {
              final error = widget.validator?.call(value);
              _errorText = error;
              return error;
            },
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            enabled: widget.enabled,
            style: GoogleFonts.outfit(
              fontSize: AppSizes.fontSizeInputText,
              color: isDark
                  ? AppColors.textDarkPrimary
                  : AppColors.textLightPrimary,
            ),
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: _buildSuffixIcon(isDark),
              filled: true,
              fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
              labelStyle: GoogleFonts.outfit(
                fontSize: AppSizes.fontSizeInputLabel,
                color: _isFocused
                    ? AppColors.primary
                    : (isDark
                          ? AppColors.textDarkSecondary
                          : AppColors.textLightSecondary),
              ),
              hintStyle: GoogleFonts.outfit(
                fontSize: AppSizes.fontSizeInputHint,
                color: isDark
                    ? AppColors.textDarkSecondary.withValues(alpha: 0.6)
                    : AppColors.textLightSecondary.withValues(alpha: 0.6),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.error, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.error, width: 1.5),
              ),
              errorStyle: GoogleFonts.outfit(
                fontSize: AppSizes.fontSizeInputHint,
                color: AppColors.error,
              ),
            ),
          ),
        ),
        if (_errorText != null && _errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorText!,
              style: GoogleFonts.outfit(
                fontSize: AppSizes.fontSizeInputHint,
                color: AppColors.error,
              ),
            ),
          ),
      ],
    );
  }

  Widget? _buildSuffixIcon(bool isDark) {
    if (widget.isPassword) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        child: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.primaryLight,
          size: 20,
        ),
      );
    }

    if (widget.showValidationIcon &&
        _errorText == null &&
        widget.controller != null &&
        widget.controller!.text.isNotEmpty) {
      return Icon(
        Icons.check_circle_outline,
        color: AppColors.success,
        size: 20,
      );
    }

    return widget.suffixIcon;
  }
}
