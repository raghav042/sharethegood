import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  const InputText({
    Key? key,
    required this.label,
    required this.controller,
    this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
  }) : super(key: key);
  final String label;
  final TextEditingController controller;
  final bool? obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
      child: TextFormField(
        controller: controller,
        minLines: 1,
        maxLines: 5,
        obscureText: obscureText ?? false,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
