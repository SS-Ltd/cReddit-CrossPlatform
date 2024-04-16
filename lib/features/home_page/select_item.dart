import 'package:flutter/material.dart';

class SelectItem extends StatefulWidget implements PreferredSizeWidget {
  final List<String> menuItems;
  final ValueChanged<String>? onMenuItemSelected;

  const SelectItem({
    super.key,
    required this.menuItems,
    this.onMenuItemSelected,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<SelectItem> createState() {
    return _SelectItemState();
  }
}

class _SelectItemState extends State<SelectItem> {
  late String selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.menuItems.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedItem,
      underline: Container(),
      onChanged: (String? newValue) {
        setState(() {
          selectedItem = newValue!;
          if (widget.onMenuItemSelected != null) {
            widget.onMenuItemSelected!(selectedItem);
          }
        });
      },
      items: widget.menuItems.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
