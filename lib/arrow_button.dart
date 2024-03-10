import 'package:flutter/material.dart';

class ArrowButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final IconData buttonicon;

  const ArrowButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.buttonicon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
        child: Row(
          children: [
            TextButton(
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
                  Icon(buttonicon),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(buttonText),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          ],
        ),
      
    );
  }
}
