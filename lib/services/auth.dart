import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_keeper/models/user_model.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on firebase user
  CustomUser _userFromFirebase({User user, String userName}) {
    return user!=null ? CustomUser(userID: user.uid, userName: userName) : null;
  }

  //auth change CustomUser stream
  Stream<CustomUser> get userStream {
    return _auth.authStateChanges()
        .map((User user) => _userFromFirebase(user: user, userName: user.displayName));
  }

  //sign in anonymously
  Future signInAnonymously() async{
    try{
      UserCredential userCredential = await _auth.signInAnonymously();
      User user = userCredential.user;
      return _userFromFirebase(user: user, userName:  "");
    }
    catch(error){
      print(error.toString());
      return null;
    }
    }


  //sign in with email
  Future signInWithNameEmailAndPassword(String email, String password) async{
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      return _userFromFirebase(user: user, userName: user.displayName);
    }catch(error){
      print(error.toString());
      return null;
    }
  }

  //register with email
  Future registerWithNameEmailAndPassword(String email, String password, String name) async{
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      user.updateProfile(displayName: name);
      return _userFromFirebase(user: user, userName: user.displayName);
    }catch(error){
      print(error.toString());
      return null;
    }
  }

  //update user data
  Future updateUserData(String name) async{
    try{
      User user = _auth.currentUser;
      await user.updateProfile(displayName: name);
      print("name changed successfully");
      return user.uid;
    }catch(error){
      print(error.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(error) {
      print(error.toString());
      return null;
    }
  }
}