import 'package:flutter/material.dart';
import 'package:notes_keeper/models/user_model.dart';
import 'dart:io';
import 'package:notes_keeper/theme_data/custom_colors.dart';
import 'package:notes_keeper/theme_data/theme_data.dart';
import 'home.dart';
import 'notes.dart';

class SettingsPage extends StatefulWidget {
  final CounterStorage storage;
  final isDarkModeTrue;
  final bool isHomePageBackPage;
  final CustomUser customUser;

  SettingsPage({
    @required this.storage,
    @required this.isDarkModeTrue,
    @required this.isHomePageBackPage,
    @required this.customUser,
  });

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  CustomColors customColors = CustomColors();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String isDarkModeTrue;

  void _checkTheme() {
    setState(() {
      if (widget.isDarkModeTrue == "true") {
        customColors.darkMode();
      } else {
        customColors.lightMode();
      }
    });
  }

  @override
  void initState() {
    _checkTheme();
    isDarkModeTrue = widget.isDarkModeTrue;
    super.initState();
  }

  Future<File> _changeThemeOnFile() {
    // Write the variable as a string to the file.
    return widget.storage.writeFile(isDarkModeTrue);
  }

  Future<void> showThemeDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: customColors.foregroundColor,
              title: Text(
                'Choose your Theme',
                style: TextStyle(color: customColors.textColor),
              ),
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                            hoverColor: customColors.textColor,
                            activeColor: customColors.textColor,
                            value: "false",
                            groupValue: isDarkModeTrue,
                            onChanged: (String value) {
                              setState(() {
                                isDarkModeTrue = "false";
                              });
                            },
                          ),
                          Text(
                            "Light Theme",
                            style: TextStyle(color: customColors.textColor),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            hoverColor: customColors.textColor,
                            activeColor: customColors.textColor,
                            value: "true",
                            groupValue: isDarkModeTrue,
                            onChanged: (String value) {
                              setState(() {
                                isDarkModeTrue = "true";
                              });
                            },
                          ),
                          Text(
                            "Dark Theme",
                            style: TextStyle(color: customColors.textColor),
                          ),
                        ],
                      ),
                    ],
                  )),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      primary: customColors.foregroundColor,
                      onPrimary: customColors.textColor,
                    ),
                    child: Text(
                      '  OK  ',
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleOnBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _handleOnBackPressed,
          ),
          toolbarHeight: 60.0,
          title: Text(
            "Settings",
            style: TextStyle(fontSize: 25.0),
          ),
          backgroundColor: customColors.backgroundColor,
        ),
        body: Container(
          color: customColors.foregroundColor,
          child: ListView(
            children: [
              ListTile(
                tileColor: customColors.foregroundColor,
                leading: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.settings_rounded,
                    color: customColors.textColor,
                    size: 25.0,
                  ),
                ),
                title: Text(
                  "Change Theme",
                  style: TextStyle(color: customColors.textColor, fontSize: 20.0),
                ),
                subtitle: Text(
                  _showCurrentTheme(),
                  style: TextStyle(color: customColors.textColor, fontSize: 15.0),
                ),
                onTap: showThemeChangeDialog,
                onLongPress: showThemeChangeDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showThemeChangeDialog() async {
    await showThemeDialog(context);
    if (isDarkModeTrue == "true") {
      setState(() {
        customColors.darkMode();
        _changeThemeOnFile();
      });
    } else {
      setState(() {
        customColors.lightMode();
      });
      _changeThemeOnFile();
    }
  }

  String _showCurrentTheme() {
    if (isDarkModeTrue == "true") {
      return "Dark Theme";
    } else
      return "Light Theme";
  }

  Future<bool> _handleOnBackPressed() {
    if (widget.isHomePageBackPage == true) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    storage: widget.storage,
                  )));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NotesPage(
                    storage: widget.storage,
                    isDarkModeTrue: isDarkModeTrue,
                    customUser: widget.customUser,
                  )));
    }
    return null;
  }


}
