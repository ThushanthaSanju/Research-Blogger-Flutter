import 'package:flutter/material.dart';

class IconButtonBar extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final Function() onPressed;

  const IconButtonBar(
      {Key? key,
      required this.icon,
      required this.selected,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 25,
            color: selected ? Colors.white : Colors.grey,
          ),
        ),
      ],
    );
  }
}
