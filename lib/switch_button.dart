import 'package:flutter/material.dart';

class SwitchButton extends StatefulWidget {
  SwitchButton(
      {super.key,
      required this.buttonText,
      required this.buttonicon,
      required this.onPressed,
      required this.switchvalue});

  final String buttonText;
  final IconData buttonicon;
  final ValueChanged<bool> onPressed;
  bool switchvalue;

  @override
  State<SwitchButton> createState() {
    return _SwitchButtonState();
  }
}

class _SwitchButtonState extends State<SwitchButton> {
  bool _switchValue = false;

  @override
  void initState() {
    super.initState();
    _switchValue = widget.switchvalue;
  }  

  void _onSwitchChanged(bool value) {
    setState(() {
      _switchValue = value;
      widget.switchvalue = _switchValue;
    });
    widget.onPressed(widget.switchvalue);
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
                    widget.switchvalue = _switchValue;
                  });
                  widget.onPressed(widget.switchvalue);
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
