import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pre_techwiz/shared/utilities/translate.dart';

class MyTextInput extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? leading;
  final Widget? trailing;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? errorText;
  final int? maxLines;
  final bool? autofocus;

  const MyTextInput({
    Key? key,
    this.hintText,
    this.labelText,
    this.controller,
    this.focusNode,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.leading,
    this.trailing,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.errorText,
    this.maxLines = 1,
    this.autofocus = false,
  }) : super(key: key);

  @override
  State<MyTextInput> createState() => _MyTextInputState();
}

class _MyTextInputState extends State<MyTextInput> {
  late bool _showClear;

  @override
  void initState() {
    super.initState();
    _showClear = widget.controller?.text.isNotEmpty ?? false;
    widget.controller?.addListener(_updateClearButtonVisibility);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_updateClearButtonVisibility);
    super.dispose();
  }

  void _updateClearButtonVisibility() {
    final hasText = widget.controller?.text.isNotEmpty ?? false;
    if (_showClear != hasText) {
      setState(() => _showClear = hasText);
    }
  }

  Widget _buildErrorLabel() {
    if (widget.errorText == null) return const SizedBox.shrink();

    final errorText = Translate.of(context).translate(widget.errorText!);
    final errorStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Theme.of(context).colorScheme.error,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.leading != null) const SizedBox(width: 24),
          Expanded(
            child: Text(
              errorText,
              style: errorStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        if (widget.labelText != null)
          Text(
            Translate.of(context).translate(widget.labelText!),
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor.withAlpha(20),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLeading(),
                  Expanded(
                    child: TextField(
                      onTap: widget.onTap,
                      textAlignVertical: TextAlignVertical.center,
                      onSubmitted: widget.onSubmitted,
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      onChanged: widget.onChanged,
                      obscureText: widget.obscureText,
                      keyboardType: widget.keyboardType,
                      textInputAction: widget.textInputAction,
                      maxLines: widget.maxLines,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        suffixIcon: _buildSuffixIcon(),
                        border: InputBorder.none,
                      ),
                      autofocus: widget.autofocus ?? false,
                    ),
                  )
                ],
              ),
              _buildErrorLabel(),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildLeading() {
    if (widget.leading == null) return const SizedBox(width: 16);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 8),
          widget.leading!,
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildSuffixIcon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.trailing != null) widget.trailing!,
        if (_showClear)
          GestureDetector(
            dragStartBehavior: DragStartBehavior.down,
            onTap: () {
              widget.controller?.clear();
              widget.onChanged?.call('');
            },
            child: const Icon(Icons.clear),
          ),
        const SizedBox(width: 12),
      ],
    );
  }
}
