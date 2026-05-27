import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/values/sizes.dart';
import '../../core/theme/app_color_scheme.dart';
import 'package:get/get.dart';

class NeomorphicDropdownItem<T> {
  final T value;
  final String label;

  const NeomorphicDropdownItem({required this.value, required this.label});
}

class NeomorphicDropdownField<T> extends StatefulWidget {
  final T? value;
  final String? labelText;
  final List<NeomorphicDropdownItem<T>> items;
  final void Function(T?)? onChanged;
  final Widget? prefixIcon;
  final String? Function(T?)? validator;
  final bool enabled;
  final bool showSearch;
  final String? searchHint;

  const NeomorphicDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.labelText,
    this.prefixIcon,
    this.validator,
    this.enabled = true,
    this.showSearch = false,
    this.searchHint,
  });

  @override
  State<NeomorphicDropdownField<T>> createState() =>
      _NeomorphicDropdownFieldState<T>();
}

class _NeomorphicDropdownFieldState<T>
    extends State<NeomorphicDropdownField<T>> {
  bool _isFocused = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey<FormFieldState<T>> _fieldKey = GlobalKey<FormFieldState<T>>();

  @override
  void dispose() {
    _removeOverlay(updateState: false);
    super.dispose();
  }

  @override
  void didUpdateWidget(NeomorphicDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _fieldKey.currentState?.didChange(widget.value);
        }
      });
    }
  }

  void _removeOverlay({bool updateState = true}) {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (updateState && mounted) {
      setState(() => _isFocused = false);
    }
  }

  void _showOverlay(BuildContext context, AppColorScheme colors) {
    if (!widget.enabled || _overlayEntry != null) return;

    setState(() => _isFocused = true);

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final currentValue = _fieldKey.currentState?.value ?? widget.value;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Invisible dismissible background
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 4),
              child: Material(
                color: Colors.transparent,
                child: _DropdownOverlayContent<T>(
                  items: widget.items,
                  selectedValue: currentValue,
                  colors: colors,
                  showSearch: widget.showSearch,
                  searchHint: widget.searchHint ?? 'search'.tr,
                  onSelected: (val) {
                    _removeOverlay();
                    if (val != currentValue) {
                      _fieldKey.currentState?.didChange(val);
                      widget.onChanged?.call(val);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final insetShadows = colors.neumorphicInsetShadow();
    final focusShadows = colors.neumorphicShadow(blur: 12, distance: 3);

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isFocused ? focusShadows : insetShadows,
            ),
            child: FormField<T>(
              key: _fieldKey,
              initialValue: widget.value,
              validator: widget.validator,
              builder: (FormFieldState<T> field) {
                // Find current label based on FormField state
                final selectedItem = widget.items.firstWhereOrNull(
                  (item) => item.value == field.value,
                );
                final displayLabel = selectedItem?.label ?? '';

                return InkWell(
                  onTap: () {
                    if (_isFocused) {
                      _removeOverlay();
                    } else {
                      _showOverlay(context, colors);
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    isFocused: _isFocused,
                    isEmpty: displayLabel.isEmpty,
                    decoration: InputDecoration(
                      labelText: widget.labelText,
                      prefixIcon: widget.prefixIcon,
                      suffixIcon: Icon(
                        _isFocused
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: colors.textSecondary,
                      ),
                      filled: true,
                      fillColor: widget.enabled ? colors.card : colors.divider,
                      labelStyle: GoogleFonts.outfit(
                        fontSize: AppSizes.fontSizeInputLabel,
                        color: _isFocused
                            ? colors.primary
                            : colors.textSecondary,
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
                        borderSide: field.value != null
                            ? BorderSide(color: colors.primary, width: 1.5)
                            : BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colors.primary,
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colors.error, width: 1.5),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: colors.error, width: 1.5),
                      ),
                      errorText: field.errorText,
                      errorStyle: GoogleFonts.outfit(
                        color: colors.error,
                        fontSize: 12,
                      ),
                    ),
                    child: Text(
                      displayLabel,
                      style: GoogleFonts.outfit(
                        fontSize: AppSizes.fontSizeInputText,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownOverlayContent<T> extends StatefulWidget {
  final List<NeomorphicDropdownItem<T>> items;
  final T? selectedValue;
  final AppColorScheme colors;
  final bool showSearch;
  final String searchHint;
  final void Function(T value) onSelected;

  const _DropdownOverlayContent({
    required this.items,
    required this.selectedValue,
    required this.colors,
    required this.showSearch,
    required this.searchHint,
    required this.onSelected,
  });

  @override
  State<_DropdownOverlayContent<T>> createState() =>
      _DropdownOverlayContentState<T>();
}

class _DropdownOverlayContentState<T>
    extends State<_DropdownOverlayContent<T>> {
  late List<NeomorphicDropdownItem<T>> _filteredItems;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = widget.items
          .where((item) => item.label.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;

    return Container(
      constraints: const BoxConstraints(maxHeight: 250),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showSearch)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  style: GoogleFonts.outfit(
                    color: colors.textPrimary,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.searchHint,
                    hintStyle: GoogleFonts.outfit(
                      color: colors.textSecondary,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: colors.textSecondary,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                vertical: widget.showSearch ? 0 : 8,
              ),
              shrinkWrap: true,
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                final isSelected = item.value == widget.selectedValue;

                return InkWell(
                  onTap: () => widget.onSelected(item.value),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colors.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.label,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? colors.primary
                                  : colors.textPrimary,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            color: colors.primary,
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
