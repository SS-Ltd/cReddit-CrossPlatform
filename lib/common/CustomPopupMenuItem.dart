import 'package:flutter/material.dart';

class CustomPopupMenuItem<T> extends PopupMenuEntry<T> {
  const CustomPopupMenuItem({super.key, required this.child, this.value});

  final Widget child;
  final T? value;

  @override
  CustomPopupMenuItemState<T> createState() => CustomPopupMenuItemState<T>();

  @override
  double get height => 30;

  @override
  bool represents(T? value) => value == this.value;
}

class CustomPopupMenuItemState<T> extends State<CustomPopupMenuItem<T>> {
  void onTap() {
    Navigator.pop<T>(context, widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: widget.child,
    );
  }
}
