import 'package:flutter/material.dart';

// ignore: camel_case_types
class weatheritem extends StatelessWidget {
  const weatheritem({
    super.key,
    required this.value, required this.text, required this.unit, required this.imageUrl,
  });

  final int value;
  final String text;
  final String unit;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children : [
            Text(text, style: const TextStyle(
          color: Colors.black54,
        ),),
        const SizedBox(
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.all(20.0),
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
            color: Color(0xffE0E8FE),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ) ,
          child: Image.asset(imageUrl,width: 50),
        ),
        const SizedBox(
          height: 8,
        ),
        Text( value.toString() + unit, style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),)
      ]);
  }
}
