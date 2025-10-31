
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospitalmanagementuser/presentation/cubit/password_visibility_cubit.dart';

Widget normalTextField(
  String hint,
  IconData icon,
  TextEditingController controller,
  String? Function(String?) validator,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      controller: controller,
      validator: validator,
      inputFormatters: [
        TextInputFormatter.withFunction(
          (oldValue, newValue) {
            return TextEditingValue(
              text: newValue.text.toLowerCase(),
              selection: newValue.selection,
            );
          },
        ),
      ],
      decoration: InputDecoration(
        hintText: 'Enter $hint',
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
Widget passwordTextField(
  String label,
  TextEditingController controller,
  String? Function(String?) validator,
) {
  return BlocProvider(
    create: (_) => PasswordVisibilityCubit(),
    child: BlocBuilder<PasswordVisibilityCubit, bool>(
      builder: (context, isVisible) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: controller,
            obscureText: !isVisible,
            validator: validator,
            decoration: InputDecoration(
              hintText: '$label your password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  isVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () => context.read<PasswordVisibilityCubit>().toggleVisibility(),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      },
    ),
  );
}


Widget numberTextField(
  String label,
  TextEditingController controller,
  String? Function(String?) validator,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      controller: controller,
      keyboardType:TextInputType.number,
      validator: validator,
      decoration: InputDecoration(
        hintText: 'complete this field',
        prefixIcon: const Icon(Icons.lock_outline),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}
