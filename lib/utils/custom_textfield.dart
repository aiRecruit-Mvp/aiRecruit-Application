import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final Color? iconColor; // Icon color parameter
  final TextInputType? keyboardType; // Keyboard type parameter
  final TextInputAction? textInputAction; // Text input action parameter

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.iconColor,
    this.keyboardType, // Initialize keyboardType
    this.textInputAction, // Initialize textInputAction
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: iconColor) : null,
        suffixIcon: suffixIcon,
      ),
      obscureText: obscureText,
      keyboardType: keyboardType, // Set keyboardType
      textInputAction: textInputAction, // Set textInputAction
    );
  }
}
