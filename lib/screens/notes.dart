import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_keeper/models/notes_list.dart';
import 'package:notes_keeper/models/user_model.dart';
import 'package:notes_keeper/services/auth.dart';
import 'package:notes_keeper/theme_data/theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_note.dart';
import 'home.dart';
import 'notes_grid.dart';
import 'settings.dart';
import 'package:notes_keeper/theme_data/custom_colors.dart';
import 'package:notes_keeper/services/database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {

  const NotesPage(
      {@required this.isDarkModeTrue, @required this.storage, @required this.customUser});

  final isDarkModeTrue;
  final CounterStorage storage;
  final CustomUser customUser;

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  CustomColors customColors = CustomColors();
  final _minimumPadding = 5.0;

  AuthService _auth = AuthService();

  CustomUser _customUser;
  String name;
  bool isProcessing = false;
  String isDarkModeTrue;

  void checkTheme() {
    setState(() {
      if (widget.isDarkModeTrue == "true") {
        customColors.darkMode();
      }
      else {
        customColors.lightMode();
      }
    });
  }

  @override
  void initState() {
    checkTheme();
    isDarkModeTrue = widget.isDarkModeTrue;
    _customUser = widget.customUser;
    name = _customUser.userName;
    super.initState();
  }

  Future<void> showExitDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: customColors.foregroundColor,
              title: Text(
                'Exit the App ? ',
                style: TextStyle(color: customColors.textColor),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    primary: customColors.foregroundColor,
                    onPrimary: customColors.textColor,
                  ),
                  child: Text(
                    'Cancel',
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    primary: customColors.foregroundColor,
                    onPrimary: customColors.textColor,
                  ),
                  child: Text(
                    '  OK  ',
                  ),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
            );
          });
        });
  }

  Future<void> showNameChangeDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: customColors.foregroundColor,
              title: TextFormField(
                //controller: nameController,
                initialValue: _customUser.userName,
                style: TextStyle(fontSize: 20.0, color: customColors.textColor),
                decoration: InputDecoration(
                  //labelText: "Name",
                  hintText: "Enter new Name",
                  hintStyle: TextStyle(color: customColors.textColor, fontSize: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: customColors.foregroundColor),
                  ),
                  fillColor: customColors.foregroundColor,
                  filled: true,
                ),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                validator: (value) => value.isEmpty ? 'Enter a name' : null,
              ),
              actions: <Widget>[
                isProcessing?
                Center(
                  child: CircularProgressIndicator(),
                ) : Text(""),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: _minimumPadding, horizontal: 2*_minimumPadding),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      primary: customColors.foregroundColor,
                      onPrimary: customColors.textColor,
                    ),
                    child: Text(
                      ' Cancel ',
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      primary: customColors.foregroundColor,
                      onPrimary: customColors.textColor,
                    ),
                    child: Text(
                      ' OK ',
                    ),
                    onPressed: () async{
                      setState(() {
                        isProcessing = true;
                      });
                      final String uid = await _auth.updateUserData(name);
                      setState(() {
                        isProcessing = false;
                        //final newCustomUser = CustomUser(userID: uid, userName: name);
                        _customUser.userName = name;
                      });
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString("userName", _customUser.userName);
                      Navigator.of(context).pop();
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
    return StreamProvider<List<NotesData>>.value(
      value: DatabaseService(uid: _customUser.userID).notes,
      child: WillPopScope(
        onWillPop: () {
          showExitDialog(context);
          return null;
        },
        child: SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(75.0),
              child: Container(
                color: customColors.backgroundColor,
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Text(
                          _customUser.userName,
                          style: TextStyle(fontSize: 25.0, color: Colors.white),
                        ),
                        onTap: () async{
                          await showNameChangeDialog(context);
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.logout, color: Colors.white,),
                      onPressed: _handleLogoutIconClick,
                    ),
                    IconButton(
                      icon: Icon(Icons.settings_rounded, color: Colors.white,),
                      onPressed: _handleSettingsIconClick,
                    ),
                  ],
                ),
              ),
            ),

            body: CustomGridListView(
                isDarkModeTrue: this.isDarkModeTrue, customUser: _customUser),

            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

            floatingActionButton: FloatingActionButton(
              tooltip: "Add a new Note",
              elevation: 2.0,
              foregroundColor: customColors.buttonTextColor,
              backgroundColor: customColors.buttonColor,
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) =>
                        AddNotesPage(
                          customUser: _customUser,
                          isDarkModeTrue: this.isDarkModeTrue,
                        )));
              },
            ),
          ),
        ),
      ),
    );
  }

  Future _handleLogoutIconClick() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
    Navigator.of(context).pop();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) =>
        HomePage(
          storage: widget.storage,
        ))
    );
  }

  void _handleSettingsIconClick() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) =>
        SettingsPage(
          storage: widget.storage,
          isDarkModeTrue: this.isDarkModeTrue,
          isHomePageBackPage: false,
          customUser: _customUser,
        ))
    );
  }
}