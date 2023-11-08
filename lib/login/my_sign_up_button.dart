import 'package:flutter/material.dart';
import 'package:weather_app/ui/welcome.dart';

// ignore: camel_case_types
class button_login extends StatelessWidget {
  final Function()? onTap;
  const button_login({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  const Welcome()));
    },

      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
            child: Text("Sign Up",
              style: TextStyle(color: Colors.white,
              fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )
        ),

      ),
    );
  }
}
