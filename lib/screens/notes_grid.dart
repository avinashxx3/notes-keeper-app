import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_keeper/models/notes_list.dart';
import 'package:notes_keeper/models/user_model.dart';
import 'package:notes_keeper/screens/update_note.dart';
import 'package:notes_keeper/theme_data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:notes_keeper/services/database.dart';

class CustomGridListView extends StatefulWidget {
  const CustomGridListView({@required this.isDarkModeTrue, @required this.customUser});

  final CustomUser customUser;
  final isDarkModeTrue;

  @override
  _CustomGridListViewState createState() => _CustomGridListViewState();
}

class _CustomGridListViewState extends State<CustomGridListView> {
  CustomColors customColors = CustomColors();

  String isDarkModeTrue;

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
  Widget build(BuildContext context) {
    checkTheme();
    double screenWidth = MediaQuery.of(context).size.width;
    final notes = Provider.of<List<NotesData>>(context);
    while(notes == null){
      return Center(
        child: Container(
          color: customColors.foregroundColor,
            child: CircularProgressIndicator())
      );
    }
    return StreamProvider<UserData>.value(
      value: DatabaseService(
        uid: widget.customUser.userID,
      ).userData,
      child: notes.length == 0
          ? Container(
              width: double.infinity,
              height: double.infinity,
              color: customColors.foregroundColor,
              child: Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Text(
                  "Add a Note to get started !!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    color: customColors.textColor,
                  ),
                ),
              ),
            )
          : Container(
              color: customColors.gridBackgroundColor,
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: screenWidth / 20, vertical: 30.0),
                itemCount: notes == null? 0 : notes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 15.0,
                    crossAxisCount:
                        (MediaQuery.of(context).orientation == Orientation.portrait) ? 2 : 3),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => UpdateNotesData(
                                    notes: notes,
                                    index: index,
                                    customUser: widget.customUser,
                                    isDarkModeTrue: this.isDarkModeTrue,
                                    noteId: notes[index].noteId,
                                  )));
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: customColors.gridForegroundColor,
                        borderRadius: BorderRadius.circular(20.0),
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                              width: MediaQuery.of(context).size.width * 9 / 20,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  notes[index].heading.toString(),
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: customColors.textColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 1.0,
                            color: Colors.grey[900],
                            height: 2.0,
                          ),
                          Expanded(
                            flex: 11,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                              width: MediaQuery.of(context).size.width * 9 / 20,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  notes[index].content.toString(),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: customColors.textContentColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
