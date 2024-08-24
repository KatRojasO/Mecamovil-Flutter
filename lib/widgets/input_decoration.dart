import 'package:flutter/material.dart';

class InputDecorations{
  static InputDecoration inputDecoration(
    {
      required String hintext,
      required String labeltext,
      required Icon icon
    }
  )
  {
    return InputDecoration(
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.deepPurple    
        )
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.deepPurple,
          width: 2,
        )
      ),
      hintText: hintext,
      labelText: labeltext,
      prefixIcon: icon
    );
  }
}