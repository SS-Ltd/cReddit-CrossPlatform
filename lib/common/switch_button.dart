import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/palette.dart';

class SwitchButton extends StatefulWidget {
  SwitchButton(
      {super.key,
      required this.buttonText,
      required this.onPressed,
      required this.switchvalue,
      this.buttonicon,
      this.optional = ''});

  final String buttonText;
  final IconData? buttonicon;
  final ValueChanged<bool> onPressed;
  bool switchvalue;
  final String optional;

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
                    widget.buttonicon == null
                        ? const SizedBox()
                        : Icon(widget.buttonicon, color: Palette.whiteColor),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.buttonText,
                          style: const TextStyle(color: Palette.whiteColor),
                        ),
                        if (widget.optional.isNotEmpty)
                          SizedBox(
                            width: 300,
                            child: Text(
                              widget.optional,
                              style: const TextStyle(color: Palette.whiteColor),
                              softWrap: true,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
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
