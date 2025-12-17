import 'package:flutter/cupertino.dart';
import 'package:waseem_api/models/user.dart';

class UserProvider extends ChangeNotifier{
  UserModel? _userModel;
  String? _token;

  //set User and token
  void setUser(UserModel value){
    _userModel = value;
    notifyListeners();
  }

  void setToken(String value){
    _token = value;
    notifyListeners();
  }

  //get USer and token
  UserModel? getUser() => _userModel;
  String? getToken() => _token;
}