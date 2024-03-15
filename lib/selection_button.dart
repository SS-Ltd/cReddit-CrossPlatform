import 'package:flutter/material.dart';

class SelectionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final IconData buttonIcon;
  // final List<String> dropdownItems;
  // final String selectedDropdownItem;
  final String selectedtext;

  const SelectionButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.buttonIcon,
    // required this.dropdownItems,
    // required this.selectedDropdownItem,
    required this.selectedtext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(buttonIcon),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(buttonText),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(selectedtext),
                const Icon(Icons.arrow_drop_down)
              ],
            )
          ],
        ),
      ),
    );
  }
}

                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
                    //   child: Row(
                    //     children: [
                    //       Text(selectedtext),
                    //       const Icon(Icons.arrow_drop_down)
                    //     ],
                    //   ),
                    // )