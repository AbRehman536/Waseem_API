import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:waseem_api/models/login.dart';
import 'package:waseem_api/models/register.dart';
import 'package:waseem_api/models/user.dart';
class AuthServices{
  String baseURL = "https://todo-nu-plum-19.vercel.app/";

  //Register User
  Future<RegisterModel> registerUser({
    required String email,
    required String password,
    required String name,
}) async{
    try{
    http.Response response = await http.post(
      Uri.parse("$baseURL/users/register"),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password
      })
    );
    if(response.statusCode == 200 || response.statusCode == 201){
      return RegisterModel.fromJson(jsonDecode(response.body));
    }else{
      throw Exception(response.reasonPhrase.toString());
    }
    }catch(e){
    throw Exception(e.toString());
    }
  }
  //Login User
  Future<LoginModel> loginUser({
    required String email,
    required String password,
  }) async{
    try{
      http.Response response = await http.post(
          Uri.parse("$baseURL/users/login"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "email": email,
            "password": password
          })
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return LoginModel.fromJson(jsonDecode(response.body));
      }else{
        throw Exception(response.reasonPhrase.toString());
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }
  //User Profile
  Future<UserModel> getProfile(String token) async{
    try{
      http.Response response = await http.get(
          Uri.parse("$baseURL/users/profile"),
          headers: {
            'Authorization': token
          },
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return UserModel.fromJson(jsonDecode(response.body));
      }else{
        throw Exception(response.reasonPhrase.toString());
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }
  //Update Profile
  Future<bool> updateProfile({required String token, required String name}) async{
    try{
      http.Response response = await http.put(
        Uri.parse("$baseURL/users/profile"),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json'
        },
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return true;
      }else{
        throw Exception(response.reasonPhrase.toString());
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }
}