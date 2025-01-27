import 'package:flutter/material.dart';

class AnimatedTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function(String?) onSaved;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputType keyboardType;

  const AnimatedTextField({
    Key? key,
    required this.label,
    required this.icon,
    required this.onSaved,
    this.validator,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            border: InputBorder.none,
          ),
          maxLines: maxLines,
          onSaved: onSaved,
          validator: validator,
          keyboardType: keyboardType,
        ),
      ),
    );
  }
}
