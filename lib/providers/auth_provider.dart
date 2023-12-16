import 'package:flutter/material.dart';
import 'package:to_do/ui/database/model/user.dart';

class MyAuthProvider extends ChangeNotifier{
  User? currentUser;
  void updateUser(User loggedInUser){
    currentUser = loggedInUser;
    notifyListeners();
  }
}