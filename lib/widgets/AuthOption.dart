import 'package:flutter/material.dart';

Row authOption(String description, String title, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(description, style: const TextStyle(color: Colors.white),),
      GestureDetector(
        onTap: () {
          onTap();
        },
        child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      )
    ],
  );
}