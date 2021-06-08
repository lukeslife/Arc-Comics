import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:arc_comics/core/viewmodels/addServerModel.dart';
import 'package:arc_comics/ui/shared/globals.dart';

class TextFieldWidget extends StatelessWidget {
  final void Function(String?) onSaved;
  final String? Function(String?) validator;
  final String hintText;
  final IconData prefixIconData;
  final IconData? suffixIconData;
  final bool obscureText;
  final Function(String?)? onChanged;

  TextFieldWidget({
    required this.onSaved,
    required this.validator,
    required this.hintText,
    required this.prefixIconData,
    required this.obscureText,
    this.suffixIconData,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AddServerModel>(context);
    return TextFormField(
      onSaved: onSaved,
      onChanged: onChanged,
      validator: validator,
      obscureText: obscureText,
      style: TextStyle(
        color: Global.blue,
        fontSize: 14.0,
      ),
      cursorColor: Global.blue,
      decoration: InputDecoration(
        labelText: hintText,
        prefixIcon: Icon(
          prefixIconData,
          size: 18,
          color: Global.blue,
        ),
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Global.blue),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            model.isVisible = !model.isVisible;
          },
          child: Icon(
            suffixIconData,
            size: 18,
            color: Global.blue,
          ),
        ),
        labelStyle: TextStyle(color: Global.blue),
        focusColor: Global.blue,
      ),
    );
  }
}
