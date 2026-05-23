import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gondalia_family/core/theme/app_color_scheme.dart';

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final String? titleText;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;

  const GlassAppBar({
    super.key,
    this.title,
    this.titleText,
    this.actions,
    this.leading,
    this.bottom,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AppBar(
      title:
          title ??
          (titleText != null
              ? Text(
                  titleText!,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                )
              : null),
      centerTitle: centerTitle,
      actions: actions,
      leading: leading,
      backgroundColor: colors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: colors.textPrimary),
      flexibleSpace: const SizedBox.shrink(),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
