import 'package:flutter/material.dart';

TextField genericTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller,
    [Function()? onEditComplete, bool isNext = false]) {
  //onEditComplete is optional argument
  return TextField(
    maxLines: 1,
    maxLength: 30,
    controller: controller,
    textInputAction:
        isNext ? TextInputAction.next : null, // Moves focus to next.
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    onEditingComplete: onEditComplete,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}
