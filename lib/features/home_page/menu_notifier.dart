import 'package:flutter/material.dart';

class MenuState extends ChangeNotifier {
  String _selectedMenuItem = 'Best';

  String get selectedMenuItem => _selectedMenuItem;

  void setSelectedMenuItem(String selectedItem) {
    _selectedMenuItem = selectedItem;
    notifyListeners(); // Notify listeners about the change
  }
}
