import 'package:flutter/material.dart';

class MenuState extends ChangeNotifier {
  String _selectedMenuItem = 'Hot';
  String _lastType = 'Hot';

  String get selectedMenuItem => _selectedMenuItem;
  String get lastType => _lastType;

  void setSelectedMenuItem(String selectedItem) {
    _selectedMenuItem = selectedItem;
    notifyListeners(); // Notify listeners about the change
  }

  void setLastType(String lastType) {
    _lastType = lastType;
  }
}
