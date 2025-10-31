import 'package:flutter/material.dart';

class AppDropdownField<T> extends StatefulWidget {
  final String label;
  final T? value;
  final List<T> options;
  final void Function(T?) onChanged;
  final IconData icon;
  final String? Function(T?)? validator;
  final String? hintText;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.icon,
    this.validator,
    this.hintText,
  });

  @override
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>> {
  bool isOpen = false;
  String? errorText;

  void _toggleDropdown() {
    setState(() {
      isOpen = !isOpen;
    });
  }

  void _selectOption(T? value) {
    widget.onChanged(value);
    setState(() {
      isOpen = false;
    });
    
    // Run validation if validator exists
    if (widget.validator != null) {
      setState(() {
        errorText = widget.validator!(value);
      });
    }
  }

  Widget _buildDropdownItem({
    required T? value,
    required String displayText,
    required bool isEnabled,
    required bool isHint,
  }) {
    final isSelected = value == widget.value;

    return InkWell(
      onTap: isEnabled ? () => _selectOption(value) : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF2F4F8) : Colors.transparent,
        ),
        child: Text(
          displayText,
          style: TextStyle(
            fontSize: 16,
            color: isHint ? Colors.grey : Colors.black,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: errorText != null ? Colors.red : Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                Icon(widget.icon, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   widget.label,
                      //   style: TextStyle(
                      //     fontSize: 12,
                      //     color: Colors.grey.shade600,
                      //   ),
                      // ),
                      // const SizedBox(height: 2),
                      Text(
                        widget.value?.toString() ?? widget.hintText ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: widget.value != null ? Colors.black : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        // Dropdown items rendered directly in widget tree
        if (isOpen)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 250),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                // Hint option (disabled)
                if (widget.hintText != null)
                  _buildDropdownItem(
                    value: null,
                    displayText: widget.hintText!,
                    isEnabled: false,
                    isHint: true,
                  ),
                // Regular options
                ...widget.options.map((option) {
                  return _buildDropdownItem(
                    value: option,
                    displayText: option.toString(),
                    isEnabled: true,
                    isHint: false,
                  );
                }),
              ],
            ),
          ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}