import 'package:flutter/material.dart';

class PopupSelectField extends StatelessWidget {
  final String label;
  final dynamic value;
  final IconData icon;
  final List<dynamic> options;
  final void Function(dynamic) onSelected;
  final String? Function(String?)? validator;

  const PopupSelectField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.options,
    required this.onSelected,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: TextEditingController(text: value?.toString()),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon,color: Colors.grey,),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: const Color.fromARGB(255, 242, 244, 248),
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
      readOnly: true,
      validator: validator,
      onTap: () => _showOptionsDialog(context),
    );
  }

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(options[index].toString()), // convert to string
                  ),
                  onTap: () {
                    onSelected(options[index]); // keep original type
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
