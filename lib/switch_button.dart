import 'package:flutter/material.dart';

class SwitchButton extends StatefulWidget {
  SwitchButton(
      {super.key,
      required this.buttonText,
      required this.buttonicon,
      required this.onPressed,
      required this.spoilervalue});

  final String buttonText;
  final IconData buttonicon;
  final VoidCallback onPressed;
  bool spoilervalue;

  @override
  State<SwitchButton> createState() {
    return _SwitchButtonState();
  }
}

class _SwitchButtonState extends State<SwitchButton> {
  bool _switchValue = false;

  void _onSwitchChanged(bool value) {
    setState(() {
      _switchValue = value;
      widget.spoilervalue = _switchValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _switchValue = !_switchValue;
                    widget.spoilervalue = _switchValue;
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(widget.buttonicon),
                    const SizedBox(width: 10),
                    Text(widget.buttonText),
                  ],
                )
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Switch(
                  value: _switchValue,
                  onChanged: _onSwitchChanged,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
