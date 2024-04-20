import 'package:flutter/material.dart';

/// A widget that displays a dropdown button with a list of menu items.
///
/// The `SelectItem` widget is a stateful widget that implements the
/// `PreferredSizeWidget` interface. It provides a dropdown button that allows
/// the user to select an item from a list of menu items.
///
/// The `SelectItem` widget requires a list of [menuItems] and an optional
/// [onMenuItemSelected] callback function. The [menuItems] list contains the
/// items to be displayed in the dropdown menu. The [onMenuItemSelected]
/// callback function is called when the user selects an item from the dropdown
/// menu.
///
/// The `SelectItem` widget is typically used as the `appBar` property of a
/// `Scaffold` widget to display a dropdown button in the app bar.
///
/// Example usage:
///
/// ```dart
/// SelectItem(
///   menuItems: ['Item 1', 'Item 2', 'Item 3'],
///   onMenuItemSelected: (selectedItem) {
///     print('Selected item: $selectedItem');
///   },
/// )
/// ```
class SelectItem extends StatefulWidget implements PreferredSizeWidget {
  final List<String> menuItems;
  final ValueChanged<String>? onMenuItemSelected;

  /// Creates a `SelectItem` widget.
  ///
  /// The [menuItems] parameter is required and must not be null. It specifies
  /// the list of items to be displayed in the dropdown menu.
  ///
  /// The [onMenuItemSelected] parameter is optional. It is a callback function
  /// that is called when the user selects an item from the dropdown menu.
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
