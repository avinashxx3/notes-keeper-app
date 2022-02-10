import 'package:flutter/material.dart';

class CustomUser {
  String userID;
  String userName;

  CustomUser({
    this.userID,
    this.userName,
  });
}

class UserData {
  final String noteID;
  final String noteHeading;
  final String noteContent;

  UserData({
    this.noteID,
    this.noteContent,
    this.noteHeading
  });
}