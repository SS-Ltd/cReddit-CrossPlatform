import 'package:flutter/material.dart';

class OptionListTile extends StatelessWidget {
  OptionListTile(
      {super.key,
      required this.title,
      required this.onTap,
      this.icon,
      this.radiobutton = true});

  final String title;
  final VoidCallback onTap;
  final IconData? icon;
  final bool radiobutton;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: radiobutton ? Radio(value: true, groupValue: null, onChanged: null) : Icon(icon),
      onTap: onTap,
    );
  }
}
