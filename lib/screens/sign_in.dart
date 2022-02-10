import 'package:flutter/material.dart';
import 'package:notes_keeper/services/auth.dart';
import 'package:notes_keeper/theme_data/custom_colors.dart';
import 'package:notes_keeper/theme_data/theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'notes.dart';

class SignInPage extends StatefulWidget {

  SignInPage({@required this.isDarkModeTrue, @required this.storage});

  final isDarkModeTrue;
  final CounterStorage storage;

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final AuthService _auth = AuthService();
  CustomColors customColors = CustomColors();

  SharedPreferences setLoginState;

  final _minimumPadding = 5.0;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String email = '';
  String password = '';
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool signInError = false;

  void _checkTheme() {
    setState(() {
      if (widget.isDarkModeTrue == "true") {
        customColors.darkMode();
      } else {
        customColors.lightMode();
      }
    });
  }

  Future _setLoginState() async {
    setLoginState = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    _checkTheme();
    _setLoginState();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //onWillPop: () {
      //  Navigator.pushReplacement(
      //      context, MaterialPageRoute(builder: (context) => HomePage(
      //        storage: widget.storage,
      //  ))
      //  );
      //  return null;
      //},
      onWillPop: () {
        Navigator.of(context).pop();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      storage: widget.storage,
                    )));
        return null;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60.0,
          title: Text(
            "Sign In",
            style: TextStyle(fontSize: 25.0),
          ),
          backgroundColor: customColors.backgroundColor,
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
            //decoration: BoxDecoration(
            //  color: CustomColors.foregroundColor,
            //),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                      child: isLoading == false?
                    Text("") : Center(child: CircularProgressIndicator()),
                      ),
                  Text(
                    signInError ? "Incorrect username or Password" : "",
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: _minimumPadding),
                  ),
                  TextFormField(
                    controller: emailController,
                    style: TextStyle(fontSize: 15.0),
                    decoration: InputDecoration(
                      //labelText: "E - mail",
                      hintText: "Enter your E - mail",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: customColors.textFieldBorderColor),
                      ),
                      fillColor: customColors.textFieldColor,
                      filled: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    validator: (value) => value.isEmpty? "Enter a name" : null,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: _minimumPadding),
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    style: TextStyle(fontSize: 15.0),
                    decoration: InputDecoration(
                      //labelText: "Password",
                      hintText: "Enter your password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: customColors.textFieldBorderColor),
                      ),
                      fillColor: customColors.textFieldColor,
                      filled: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    validator: (value) => value.isEmpty ? 'Enter a Password' : null,
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
                      " Sign In ",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        print(email);
                        print(password);
                        dynamic customUserResult =
                            await _auth.signInWithNameEmailAndPassword(this.email, this.password);
                        setState(() {
                          isLoading = false;
                        });
                        if (customUserResult == null) {
                          print("Error Signing In");
                          setState(() {
                            signInError = true;
                          });
                        } else {
                          print("Signed In");
                          print(customUserResult.userID);
                          print(customUserResult.userName);
                          await setLoginState.setString('userId', customUserResult.userID);
                          await setLoginState.setString('userName', customUserResult.userName);
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) => NotesPage(
                                    isDarkModeTrue: widget.isDarkModeTrue,
                                    storage: widget.storage,
                                    customUser: customUserResult,
                                  )));
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
