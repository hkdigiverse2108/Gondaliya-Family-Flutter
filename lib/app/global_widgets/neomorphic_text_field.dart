import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/values/sizes.dart';
import '../../core/theme/app_color_scheme.dart';

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
  final void Function(String)? onChanged;
  final int maxLines;
  final bool enabled;
  final bool showValidationIcon;
  final int? maxLength;

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
    this.maxLength,
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
    final colors = context.appColors;

    // Inset shadows for neumorphic effect
    final insetShadows = colors.neumorphicInsetShadow();

    // Focus shadows - slightly more pronounced
    final focusShadows = colors.neumorphicShadow(blur: 12, distance: 3);

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
              if (_errorText != error) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _errorText = error;
                    });
                  }
                });
              }
              return error != null
                  ? ''
                  : null; // Return empty string to trigger errorBorder without showing text inside container
            },
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            enabled: widget.enabled,
            style: GoogleFonts.outfit(
              fontSize: AppSizes.fontSizeInputText,
              color: colors.textPrimary,
            ),
            maxLength: widget.maxLength,
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: _buildSuffixIcon(colors),
              filled: true,
              fillColor: widget.enabled ? colors.card : colors.divider,
              labelStyle: GoogleFonts.outfit(
                fontSize: AppSizes.fontSizeInputLabel,
                color: _isFocused ? colors.primary : colors.textSecondary,
              ),
              hintStyle: GoogleFonts.outfit(
                fontSize: AppSizes.fontSizeInputHint,
                color: colors.textSecondary.withValues(alpha: 0.6),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: widget.controller?.text.isEmpty == false
                    ? BorderSide(color: colors.primary, width: 1.5)
                    : BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.primary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.error, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.error, width: 1.5),
              ),
              errorStyle: const TextStyle(height: 0, fontSize: 0),
            ),
          ),
        ),
        if (_errorText != null && _errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 12.0),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 14,
                  color: colors.error,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _errorText!,
                    style: GoogleFonts.outfit(
                      fontSize: AppSizes.fontSizeInputHint,
                      color: colors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget? _buildSuffixIcon(AppColorScheme colors) {
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
          color: colors.textPrimary,
          size: 20,
        ),
      );
    }

    if (widget.showValidationIcon &&
        _errorText == null &&
        widget.controller != null &&
        widget.controller!.text.isNotEmpty) {
      return Icon(Icons.check_circle_outline, color: colors.success, size: 20);
    }

    return widget.suffixIcon;
  }
}
