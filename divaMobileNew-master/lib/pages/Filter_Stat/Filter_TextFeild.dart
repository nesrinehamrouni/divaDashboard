import 'package:flutter/material.dart';

class FilterTextField extends StatefulWidget {
  final String? label;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const FilterTextField({
    Key? key,
    this.label,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  _BorderedTextFieldState createState() => _BorderedTextFieldState();
}

class _BorderedTextFieldState extends State<FilterTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.label,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
