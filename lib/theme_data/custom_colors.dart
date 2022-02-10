import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CustomColors extends ChangeNotifier{
  Color backgroundColor = Colors.blue[500];
  Color textFieldColor = Colors.white;
  Color textFieldBorderColor = Colors.grey[200];
  Color foregroundColor = Colors.grey[200];
  Color textColor = Colors.black;
  Color buttonColor = Colors.blue[400];
  Color buttonTextColor = Colors.white;
  Color shadowColor = Colors.grey[600];
  Color gridBackgroundColor = Colors.grey[500];
  Color gridForegroundColor = Colors.grey[200];
  Color textContentColor = Colors.grey[800];

  void darkMode() {
    backgroundColor = Colors.black;
    textFieldColor = Colors.grey[300];
    textFieldBorderColor = Colors.grey[850];
    foregroundColor = Colors.grey[850];
    textColor = Colors.white;
    buttonColor = Colors.grey[900];
    buttonTextColor = Colors.white;
    shadowColor = Colors.black;
    gridBackgroundColor = Colors.black;
    gridForegroundColor = Colors.grey[800];
    textContentColor = Colors.grey[400];
    notifyListeners();
  }

  void lightMode() {
    backgroundColor = Colors.blue[500];
    textFieldColor = Colors.white;
    textFieldBorderColor = Colors.grey[200];
    foregroundColor = Colors.grey[200];
    textColor = Colors.black;
    buttonColor = Colors.blue[400];
    buttonTextColor = Colors.white;
    shadowColor = Colors.grey[600];
    gridBackgroundColor = Colors.grey[200];
    gridForegroundColor = Colors.grey[350];
    textContentColor = Colors.grey[800];
    notifyListeners();
  }
}
