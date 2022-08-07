import 'package:flutter/cupertino.dart';

class NavigationProvider with ChangeNotifier {
  int currentScreenIndex = 0;

  void setCurrentScreenIndex(int index) {
    currentScreenIndex = index;
    notifyListeners();
  }
}
