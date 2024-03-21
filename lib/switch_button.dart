import 'package:flutter/material.dart';

class SwitchButton extends StatefulWidget {
  const SwitchButton(
      {super.key,
      required this.buttonText,
      required this.buttonicon,
      required this.onPressed});

  final String buttonText;
  final IconData buttonicon;
  final VoidCallback onPressed;

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: ()
              {
                _switchValue = !_switchValue;
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
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(widget.buttonText),
                  ),
                  Switch(
                    value: _switchValue,
                    onChanged: _onSwitchChanged,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
