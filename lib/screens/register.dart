import 'package:flutter/material.dart';
import 'package:notes_keeper/services/auth.dart';
import 'package:notes_keeper/theme_data/custom_colors.dart';
import 'package:notes_keeper/theme_data/theme_data.dart';

import 'home.dart';

class RegisterPage extends StatefulWidget {

  RegisterPage({@required this.isDarkModeTrue, @required this.storage});

  final isDarkModeTrue;
  final CounterStorage storage;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
  CustomColors customColors = CustomColors();
  final _minimumPadding = 5.0;

  AuthService _auth = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String name = "";
  String password = "";
  String email = "";
  String confirmPassword = "";
  final _formKey = GlobalKey<FormState>();
  bool isLoading;
  bool didRegisterSuccessfully = false;
  bool registerError = false;

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
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (didRegisterSuccessfully == false) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60.0,
          title: Text(
            "Register",
            style: TextStyle(fontSize: 25.0),
          ),
          backgroundColor: customColors.backgroundColor,
        ),
        body: isLoading == true
            ? Center(
                child: Container(
                    color: customColors.foregroundColor, child: CircularProgressIndicator()))
            : GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  TextEditingController().clear();
                },
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height - 60,
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
                          TextFormField(
                            controller: nameController,
                            style: TextStyle(fontSize: 15.0),
                            decoration: InputDecoration(
                              //labelText: "Name",
                              hintText: "Enter your Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: customColors.textFieldBorderColor),
                              ),
                              fillColor: customColors.textFieldColor,
                              filled: true,
                            ),
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                            validator: (value) => value.isEmpty ? 'Enter a name' : null,
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
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Enter an E-mail';
                              }
                              if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                  .hasMatch(value)) {
                                return 'Please enter a valid Email';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: _minimumPadding),
                          ),
                          TextFormField(
                            controller: passwordController,
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
                            obscureText: true,
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Enter a password';
                              }
                              String pattern =
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                              //if (!RegExp(pattern)
                              //    .hasMatch(value)) {
                              //  return 'Password should contain one upper case,one lowercase letter,'
                              //      'one digit,one special character and must be of min 8 characters';
                              //}
                              if (value.length < 8) {
                                return "Must contain at least 8 characters";
                              }
                              if (value.contains(RegExp(r'[a-z]')) &&
                                  !value.contains(RegExp(r'[0-9]'))) {
                                return "Include a number";
                              }
                              if (!value.contains(RegExp(r'[a-z]')) &&
                                  value.contains(RegExp(r'[0-9]'))) {
                                return "Include a letter";
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: _minimumPadding),
                          ),
                          TextFormField(
                            controller: confirmPasswordController,
                            style: TextStyle(fontSize: 15.0),
                            decoration: InputDecoration(
                              //labelText: "Confirm Password",
                              hintText: "Confirm your Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: customColors.textFieldBorderColor),
                              ),
                              fillColor: customColors.textFieldColor,
                              filled: true,
                            ),
                            obscureText: true,
                            onChanged: (value) {
                              setState(() {
                                confirmPassword = value;
                              });
                            },
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Re-enter the Password';
                              }
                              if (confirmPassword != password) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: _minimumPadding),
                          ),
                          Text(
                            registerError ? "Some error occurred.\nPlease Try again" : "",
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
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                print(this.name);
                                print(this.email);
                                print(this.password);
                                print(this.confirmPassword);
                                dynamic customUserResult =
                                    await _auth.registerWithNameEmailAndPassword(
                                  this.email,
                                  this.password,
                                  this.name,
                                );
                                setState(() {
                                  isLoading = false;
                                });
                                if (customUserResult == null) {
                                  print("Error Registering. Please Try Again.");
                                  setState(() {
                                    registerError = true;
                                  });
                                } else {
                                  print("Registered Successfully");
                                  print(customUserResult.userID);
                                  print(customUserResult.userName);
                                  setState(() {
                                    didRegisterSuccessfully = true;
                                  });
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
    } else {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60.0,
          title: Text(
            "Register",
            style: TextStyle(fontSize: 25.0),
          ),
          backgroundColor: customColors.backgroundColor,
        ),
        body: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 5,
            right: MediaQuery.of(context).size.width / 6,
            left: MediaQuery.of(context).size.width / 6,
          ),
          color: customColors.foregroundColor,
          width: double.infinity,
          child: Column(
            children: [
              Text(
                "Registered Successfully.\nTap button to go back.",
                style: TextStyle(color: customColors.textColor, fontSize: 20.0),
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
                  " Go Back ",
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  //Navigator.of(context).push(MaterialPageRoute(
                  //    builder: (context) =>
                  //        HomePage(
                  //          storage: widget.storage,
                  //        )));
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}
