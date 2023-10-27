import 'package:flutter/material.dart';

    class MyTextFields extends StatelessWidget {
      final controller;
      final String hintText;
      final bool obscureText;
      const MyTextFields({
        super.key,
        required this.controller,
        required this.hintText,
        required this.obscureText,
      });
    
      @override
      Widget build(BuildContext context) {
        return  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              fillColor: Colors.grey,
              filled: true,
              hintText: hintText,

            ),
          ),
        );
      }
    }
    