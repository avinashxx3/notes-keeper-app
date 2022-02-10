import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:notes_keeper/models/user_model.dart';
import 'package:notes_keeper/theme_data/custom_colors.dart';
import 'package:notes_keeper/screens/sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notes.dart';
import 'register.dart';
import 'package:notes_keeper/theme_data/theme_data.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  final CounterStorage storage;
  HomePage({@required this.storage});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  CustomColors customColors = CustomColors();
  final _minimumPadding = 5.0;

  SharedPreferences loginState;

  var isDarkModeTrue;
  Future _initThemeData;

  Future initThemeData() async {
    widget.storage.readFile().then((String isDarkModeTrue) {
      setState(() {
        this.isDarkModeTrue = isDarkModeTrue;
        if (isDarkModeTrue == "true") {
          customColors.darkMode();
        } else {
          customColors.lightMode();
        }
      });
    });
  }

  Future initLoginState() async{
    loginState = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    _initThemeData = initThemeData();
    initLoginState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initThemeData,
      builder: (context, snapshot) {
        while (snapshot == null) {
          return Container(child: CircularProgressIndicator());
        }
        final customUser = Provider.of<CustomUser>(context);
        if(
            loginState != null &&
            loginState.getString('userId') != null
            && loginState.getString('userName') != null
        ){
          customUser.userID = loginState.getString('userId');
          customUser.userName = loginState.getString('userName');
          return NotesPage(isDarkModeTrue: isDarkModeTrue, storage: widget.storage, customUser: customUser,);
        }
        //print(customUser);
        //if(customUser != null){
        //  return NotesPage(isDarkModeTrue: isDarkModeTrue, storage: widget.storage);
        //}
        //else{
        else{
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 70.0,
            title: Text(
              "Notes Keeper",
              style: TextStyle(fontSize: 25.0),
            ),
            backgroundColor: customColors.backgroundColor,
            actions: [
              IconButton(
                  icon: Icon(Icons.settings_rounded,color: Colors.white,),
                  onPressed: _handleSettingsIconClick,
              ),
            ],
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              TextEditingController().clear();
            },
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 5,
                right: MediaQuery.of(context).size.width / 6,
                left: MediaQuery.of(context).size.width / 6,
              ),
              color: customColors.foregroundColor,
              width: double.infinity,
              //decoration: BoxDecoration(
              //  color: CustomColors.foregroundColor,
              //),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: _minimumPadding,
                      shadowColor: customColors.shadowColor,
                      primary: customColors.buttonColor,
                      onPrimary: customColors.buttonTextColor,
                    ),
                    child: Text(
                      " Sign In ",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignInPage(
                              isDarkModeTrue: isDarkModeTrue,
                              storage: widget.storage,
                          )));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: _minimumPadding),
                  ),
                  Text(
                    "Don\'t have an Account? Register now",
                    style: TextStyle(color: customColors.textColor, fontSize: 15.0),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: _minimumPadding),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: _minimumPadding,
                      shadowColor: customColors.shadowColor,
                      primary: customColors.buttonColor,
                      onPrimary: customColors.buttonTextColor,
                    ),
                    child: Text(
                      " Register ",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegisterPage(
                            isDarkModeTrue: isDarkModeTrue,storage: widget.storage,)
                      ));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
        }
      }
    );
  }

  void _handleSettingsIconClick() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) =>
        SettingsPage(
          storage: widget.storage,
          isDarkModeTrue: this.isDarkModeTrue,
          isHomePageBackPage: true,
        ))
    );
  }

}