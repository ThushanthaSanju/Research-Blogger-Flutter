import 'package:flutter/material.dart';

Image reusableLogo(String path) {
  return Image.asset(
    path,
    fit: BoxFit.fitWidth,
    width: 200,
    height: 200,
    color: Colors.white,
  );
}
