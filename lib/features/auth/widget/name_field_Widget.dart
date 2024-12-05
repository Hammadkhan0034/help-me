import 'package:alarm_app/constants/colors.dart';
import 'package:flutter/material.dart';

class NameFieldWidget extends StatelessWidget {
  final TextEditingController controller;

  const NameFieldWidget({
    super.key,
 required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.name,
      style: const TextStyle(fontSize: 18, color: Colors.white),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Name cannot be empty';
        }
        return null;
      },
      decoration: const InputDecoration(
        
        helperStyle: TextStyle(fontSize: 14, color: Color(0xffF4F4F9)),
        fillColor: AColors.darkGrey,
        focusColor: Color(0xffF4F4F9),
        suffixIconColor: Color(0xffF4F4F9),
        iconColor: Color(0xffF4F4F9),
        errorStyle: TextStyle(color: Colors.white),
        filled: true,
        hintText: 'Enter your name',
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: AColors.darkGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: AColors.darkGrey),
        ),
        // contentPadding: EdgeInsets.symmetric(horizontal: 20)
      ),

    );
  }
}
