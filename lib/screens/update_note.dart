import 'package:flutter/material.dart';
import 'package:notes_keeper/models/notes_list.dart';
import 'package:notes_keeper/services/database.dart';
import 'package:notes_keeper/theme_data/custom_colors.dart';

class UpdateNotesData extends StatefulWidget {

  const UpdateNotesData({
    @required this.isDarkModeTrue,
    @required this.index,
    @required this.notes,
    @required this.customUser,
    @required this.noteId,
  });

  final isDarkModeTrue;
  final int index;
  final notes;
  final customUser;
  final noteId;

  @override
  _UpdateNotesDataState createState() => _UpdateNotesDataState();
}

class _UpdateNotesDataState extends State<UpdateNotesData> {

  CustomColors customColors = CustomColors();

  String isDarkModeTrue;

  TextEditingController headingController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String heading;
  String content;
  List<NotesData> notes;

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
    notes = widget.notes;
    //userData = widget.userData;
    isDarkModeTrue = widget.isDarkModeTrue;
    super.initState();
  }

  @override
  void dispose() {
    headingController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> showExitDialog(BuildContext context, String noteId) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: customColors.foregroundColor,
              title: Text(
                'Delete this note ? ',
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
                    Navigator.of(context).pop();
                    _handleNoteDeleting(noteId);
                  },
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    //final userData = Provider.of<UserData>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customColors.backgroundColor,
        foregroundColor: customColors.foregroundColor,
        leading: IconButton(
          color: customColors.backgroundColor,
          icon: Icon(
            Icons.cancel,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.white,
          ),
          onPressed: () {
            showExitDialog(context, widget.noteId);
            return null;
          },
        ),
        IconButton(
            icon: Icon(
              Icons.file_download_done,
              color: Colors.white,
            ),
            onPressed: () => _handleNoteEditing(widget.noteId),
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
              TextFormField(
                initialValue:
                    notes[widget.index].heading != null ? notes[widget.index].heading : "",
                //controller: headingController,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: null,
                style: TextStyle(fontSize: 20.0, color: customColors.textColor),
                decoration: InputDecoration(
                  hintText: "Heading",
                  hintStyle: TextStyle(fontSize: 20.0, color: customColors.textColor),
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
              TextFormField(
                initialValue:
                    notes[widget.index].content != null ? notes[widget.index].content : "",
                //controller: contentController,
                keyboardType: TextInputType.multiline,
                minLines: 10,
                maxLines: null,
                style: TextStyle(fontSize: 18.0, color: customColors.textContentColor),
                decoration: InputDecoration(
                  hintText: "Type Your note here.",
                  hintStyle: TextStyle(fontSize: 18.0, color: customColors.textColor),
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
  }

  void _handleNoteEditing(String noteId) async {
    await DatabaseService(noteId: noteId, uid: widget.customUser.userID)
        .updateNotesData(this.heading ?? notes[widget.index].heading,
            this.content ?? notes[widget.index].content);
    Navigator.of(context).pop();
  }

  void _handleNoteDeleting(String noteId) async {
    await DatabaseService(noteId: noteId, uid: widget.customUser.userID).deleteNotesData();
    Navigator.of(context).pop();
  }
}
