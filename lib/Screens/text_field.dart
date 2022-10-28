import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget{

  final TextEditingController controller;
  final String label;
  final bool password;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;


  const CustomTextField({
    required this.label,
    required this.controller,
    this.validator,
    this.password = false,
    this.keyboardType,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              color: Color(0xFF031620),
            ),

            errorStyle: const TextStyle(
                color: Color(0xFF900020)
            ),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xFF900020),
                ), borderRadius: BorderRadius.circular(20)
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color(0xFF900020),
                    width: 2.0
                ),
                borderRadius: BorderRadius.circular(20)
            ),

            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide:  const BorderSide(
                    width: 2.0
                ),
                borderRadius: BorderRadius.circular(25.0)
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xFF031620),

                ),
                borderRadius: BorderRadius.circular(20)
            )

        ),
        autofocus: false,
        keyboardType: keyboardType,
        obscureText: password,
        validator: validator,

      ),
    );
  }



}