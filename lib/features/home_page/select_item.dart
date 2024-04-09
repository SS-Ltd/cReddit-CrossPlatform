import 'package:flutter/material.dart';

class SelectItem extends StatefulWidget implements PreferredSizeWidget {
  final List<String> menuItems;
  final ValueChanged<String>? onMenuItemSelected;

  const SelectItem({
    required this.menuItems,
    this.onMenuItemSelected,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _SelectItemState createState() => _SelectItemState();
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
    return Expanded(
      // Wrap the SelectItem with Expanded
      child: DropdownButton<String>(
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
      ),
    );
  }
}
