import 'package:chat/database/DataBaseHelper.dart';
import 'package:chat/model/User.dart' as MyUser;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyThemeData{
  static const primaryColor = Color.fromARGB(255, 53, 152, 219);
  static const white = Color.fromARGB(255, 255, 255, 255);
}
class AppProvider extends ChangeNotifier{
  MyUser.User? currentUser;

  bool checkLoggedInUser(){
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if(firebaseUser!=null){
      getUsersCollectionWithConverter()
          .doc(firebaseUser.uid).get()
          .then((retUser) {
        if(retUser.data()!=null)
        {
          currentUser=retUser.data();
        }
      });

    }
    return firebaseUser!=null;
  }
  void updateUser(MyUser.User? user){
    currentUser  = user;
    notifyListeners();
  }
}