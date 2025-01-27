import 'package:flutter/material.dart';

class AnimatedTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final int maxLines;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  const AnimatedTextField({
    Key? key,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.onSaved,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: InputBorder.none,
        ),
        maxLines: maxLines,
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}

class AnimatedDropdown extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<String> items;
  final Function(String?)? onChanged;

  const AnimatedDropdown({
    Key? key,
    required this.label,
    required this.icon,
    required this.items,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: InputBorder.none,
        ),
        items: items
            .map((type) => DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                ))
            .toList(),
        onChanged: onChanged, // onChanged artık String? türünde
      ),
    );
  }
}
