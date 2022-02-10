import 'package:flutter/material.dart';
import 'package:notes_keeper/models/user_model.dart';
import 'package:notes_keeper/services/auth.dart';
import 'package:notes_keeper/services/database.dart';
import 'package:notes_keeper/theme_data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'notes.dart';
import 'notes_grid.dart';

class AddNotesPage extends StatefulWidget {
  const AddNotesPage({@required this.isDarkModeTrue, @required this.customUser});
  final CustomUser customUser;
  final isDarkModeTrue;

  @override
  _AddNotesPageState createState() => _AddNotesPageState();
}

class _AddNotesPageState extends State<AddNotesPage> {
  CustomColors customColors = CustomColors();

  String isDarkModeTrue;

  TextEditingController headingController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String heading;
  String content;

  void checkTheme() {
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
    checkTheme();
    isDarkModeTrue = widget.isDarkModeTrue;
    super.initState();
  }

  @override
  void dispose() {
    headingController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.userID).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: customColors.backgroundColor,
              foregroundColor: customColors.foregroundColor,
              leading: IconButton(
                color: customColors.backgroundColor,
                icon: Icon(
                  Icons.cancel_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.done_outline,
                    color: Colors.white,
                  ),
                  onPressed: _handleNoteAddition,
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                color: customColors.gridForegroundColor,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 10.0),
                    ),
                    TextField(
                      controller: headingController,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: null,
                      style: TextStyle(fontSize: 20.0,color: customColors.textColor),
                      decoration: InputDecoration(
                        hintText: "Heading",
                        hintStyle: TextStyle(fontSize: 20.0,color: customColors.textColor),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        fillColor: customColors.gridForegroundColor,
                        filled: true,
                      ),
                      onChanged: (value) {
                        setState(() {
                          heading = value != null ? value : "";
                        });
                      },
                    ),
                    Container(
                      height: 3.0,
                      color: customColors.backgroundColor,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 7.0),
                    ),
                    TextField(
                      controller: contentController,
                      keyboardType: TextInputType.multiline,
                      minLines: 10,
                      maxLines: null,
                      style: TextStyle(fontSize: 18.0,color: customColors.textContentColor),
                      decoration: InputDecoration(
                        hintText: "Type Your note here.",
                        hintStyle: TextStyle(fontSize: 18.0,color: customColors.textColor),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        fillColor: customColors.gridForegroundColor,
                        filled: true,
                      ),
                      onChanged: (value) {
                        setState(() {
                          content = value != null ? value : "";
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _handleNoteAddition() {
    Future addResult = DatabaseService(uid: widget.customUser.userID).addNotesData(this.heading, this.content);
    Navigator.of(context).pop();
  }
}
