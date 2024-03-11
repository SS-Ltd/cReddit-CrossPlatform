import 'package:flutter/material.dart';

class ArrowButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final IconData buttonIcon;
  final String optional;
  final bool hasarrow;

  const ArrowButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.buttonIcon,
    required this.hasarrow,
    this.optional = '',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: onPressed,
              style: ButtonStyle(
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(buttonIcon),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(buttonText),
                        if (optional.isNotEmpty) Text(optional),
                      ],
                    ),
                  ),
                  hasarrow
                      ? const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                            Icons.arrow_forward_ios_rounded,
                          ),
                      )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//if (optional.isNotEmpty) Text(optional),