import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/values/sizes.dart';
import '../../core/theme/app_color_scheme.dart';
import 'package:get/get.dart';

class NeomorphicAsyncDropdownItem<T> {
  final T value;
  final String label;

  const NeomorphicAsyncDropdownItem({required this.value, required this.label});
}

class NeomorphicAsyncDropdownField<T> extends StatefulWidget {
  final T? value;
  final String? labelText;
  final Future<List<NeomorphicAsyncDropdownItem<T>>> Function(String)? onSearch;
  final void Function(T?)? onChanged;
  final Widget? prefixIcon;
  final String? Function(T?)? validator;
  final bool enabled;
  final String? searchHint;
  final String Function(T?)? displayStringForValue;

  const NeomorphicAsyncDropdownField({
    super.key,
    required this.value,
    required this.onSearch,
    required this.onChanged,
    this.labelText,
    this.prefixIcon,
    this.validator,
    this.enabled = true,
    this.searchHint,
    this.displayStringForValue,
  });

  @override
  State<NeomorphicAsyncDropdownField<T>> createState() =>
      _NeomorphicAsyncDropdownFieldState<T>();
}

class _NeomorphicAsyncDropdownFieldState<T>
    extends State<NeomorphicAsyncDropdownField<T>> {
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
  void didUpdateWidget(NeomorphicAsyncDropdownField<T> oldWidget) {
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
                child: _AsyncDropdownOverlayContent<T>(
                  onSearch: widget.onSearch,
                  selectedValue: currentValue,
                  colors: colors,
                  searchHint: widget.searchHint ?? 'search'.tr,
                  onSelected: (val, label) {
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
                final displayLabel = widget.displayStringForValue != null
                    ? widget.displayStringForValue!(field.value)
                    : (field.value?.toString() ?? '');

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
                    isEmpty: field.value == null || displayLabel.isEmpty,
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

class _AsyncDropdownOverlayContent<T> extends StatefulWidget {
  final Future<List<NeomorphicAsyncDropdownItem<T>>> Function(String)? onSearch;
  final T? selectedValue;
  final AppColorScheme colors;
  final String searchHint;
  final void Function(T value, String label) onSelected;

  const _AsyncDropdownOverlayContent({
    required this.onSearch,
    required this.selectedValue,
    required this.colors,
    required this.searchHint,
    required this.onSelected,
  });

  @override
  State<_AsyncDropdownOverlayContent<T>> createState() =>
      _AsyncDropdownOverlayContentState<T>();
}

class _AsyncDropdownOverlayContentState<T>
    extends State<_AsyncDropdownOverlayContent<T>> {
  List<NeomorphicAsyncDropdownItem<T>> _items = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _performSearch('');
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(_searchController.text);
    });
  }

  Future<void> _performSearch(String query) async {
    if (widget.onSearch == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await widget.onSearch!(query);
      if (mounted) {
        setState(() {
          _items = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;

    return Container(
      constraints: const BoxConstraints(maxHeight: 250),
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
                  suffixIcon: _isLoading
                      ? Container(
                          padding: const EdgeInsets.all(12),
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.primary,
                          ),
                        )
                      : null,
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
            child: _items.isEmpty && !_isLoading
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'no_results_found'.tr,
                      style: GoogleFonts.outfit(color: colors.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    shrinkWrap: true,
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      final isSelected = item.value == widget.selectedValue;

                      return InkWell(
                        onTap: () => widget.onSelected(item.value, item.label),
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
