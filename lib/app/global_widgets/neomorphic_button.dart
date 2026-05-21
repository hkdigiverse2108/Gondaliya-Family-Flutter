import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/values/sizes.dart';
import '../../core/theme/app_color_scheme.dart';

class NeomorphicButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? width;
  final double height;
  final bool isGradient;
  final List<Color>? gradientColors;
  final AlignmentGeometry? gradientBegin;
  final AlignmentGeometry? gradientEnd;

  const NeomorphicButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.width,
    this.height = 50,
    this.isGradient = false,
    this.gradientColors,
    this.gradientBegin,
    this.gradientEnd,
  });

  @override
  State<NeomorphicButton> createState() => _NeomorphicButtonState();
}

class _NeomorphicButtonState extends State<NeomorphicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _shadowAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    _animationController.forward();
  }

  void _onPointerUp(PointerUpEvent event) {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final theme = Theme.of(context);

    final buttonColor = widget.backgroundColor ?? theme.primaryColor;
    final contentColor = widget.textColor ?? colors.white;

    return AnimatedBuilder(
      animation: _shadowAnimation,
      builder: (context, child) {
        final shadowDistance = 5.0 * _shadowAnimation.value;
        final shadowBlur = 15.0 * _shadowAnimation.value;

        final shadows = colors.neumorphicShadow(
          blur: shadowBlur,
          distance: shadowDistance,
        );

        return Listener(
          onPointerDown: widget.isLoading ? null : _onPointerDown,
          onPointerUp: widget.isLoading ? null : _onPointerUp,
          child: SizedBox(
            width: widget.width ?? double.infinity,
            height: widget.height,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                boxShadow: widget.isLoading ? [] : shadows,
                gradient: widget.isGradient
                    ? LinearGradient(
                        colors: widget.gradientColors ?? colors.primaryGradient,
                        begin: widget.gradientBegin ?? Alignment.centerLeft,
                        end: widget.gradientEnd ?? Alignment.centerRight,
                      )
                    : null,
                color: !widget.isGradient ? buttonColor : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.isLoading ? null : widget.onPressed,
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: widget.isLoading
                        ? Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  contentColor,
                                ),
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.icon != null) ...[
                                Icon(
                                  widget.icon,
                                  size: 20,
                                  color: contentColor,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                widget.text,
                                style: GoogleFonts.outfit(
                                  fontSize: AppSizes.fontSizeButton,
                                  fontWeight: FontWeight.w600,
                                  color: contentColor,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
