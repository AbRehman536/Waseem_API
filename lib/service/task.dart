import 'dart:convert';

import 'package:waseem_api/models/task.dart';
import 'package:http/http.dart' as http;
import 'package:waseem_api/models/taskListing.dart';
class TaskServices{

  //Create Task
  Future<TaskModel> createTask({
    required String token, required String description
})async {
    try{
      http.Response response = await http.post(
        Uri.parse("{{TODO_URL}}/todos/add"),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json'},
        body: jsonEncode({"description": description,}),
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return TaskModel.fromJson(jsonDecode(response.body));
      }
      else{
        throw Exception(response.reasonPhrase.toString());
      }
    }catch(e){
      throw Exception(e.toString());

    }
  }
  //Get All Task
  Future<TaskListingModel> getAllTask(String token)async {
    try{
      http.Response response = await http.get(
        Uri.parse("{{TODO_URL}}/todos/get"),
        headers: {'Authorization': token,},
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return TaskListingModel.fromJson(jsonDecode(response.body));
      }
      else{
        throw Exception(response.reasonPhrase.toString());
      }
    }catch(e){
      throw Exception(e.toString());

    }
  }
  //Get Completed Task
  Future<TaskListingModel> getCompletedTask(String token)async {
    try{
      http.Response response = await http.get(
        Uri.parse("{{TODO_URL}}/todos/completed"),
        headers: {'Authorization': token,},
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return TaskListingModel.fromJson(jsonDecode(response.body));
      }
      else{
        throw Exception(response.reasonPhrase.toString());
      }
    }catch(e){
      throw Exception(e.toString());

    }
  }
  //Get InCompleted Task
  Future<TaskListingModel> getInCompletedTask(String token)async {
    try{
      http.Response response = await http.get(
        Uri.parse("{{TODO_URL}}/todos/incomplete"),
        headers: {'Authorization': token,},
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return TaskListingModel.fromJson(jsonDecode(response.body));
      }
      else{
        throw Exception(response.reasonPhrase.toString());
      }
    }catch(e){
      throw Exception(e.toString());

    }
  }
  //Update Task
  Future<bool> updateTask({
    required String token, required String taskID, required String description
  })async {
    try{
      http.Response response = await http.put(
        Uri.parse("{{TODO_URL}}/todos/update/$taskID"),
        headers: {'Authorization': token,
          'Content-Type': 'application/json'},
        body: jsonEncode({"description": description,}),
      );

      if(response.statusCode == 200 || response.statusCode == 201){
        return true;
      }
      else{
        throw Exception(response.reasonPhrase.toString());
      }
    }catch(e){
      throw Exception(e.toString());

    }
  }
  //Delete Task
  Future<bool> deleteTask({
    required String token, required String taskID
  })async {
    try{
      http.Response response = await http.get(
        Uri.parse("{{TODO_URL}}/todos/delete/$taskID"),
        headers: {'Authorization': token,},
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return true;
      }
      else{
        throw Exception(response.reasonPhrase.toString());
      }
    }catch(e){
      throw Exception(e.toString());

    }
  }
  //Filter Task
  Future<TaskListingModel> filterTask({
    required String token, required String startDate , required String endDate
  })async {
    try{
      http.Response response = await http.get(
        Uri.parse("{{TODO_URL}}/todos/filter?startDate=$startDate&endDate=$endDate"),
        headers: {'Authorization': token,},
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return TaskListingModel.fromJson(jsonDecode(response.body));
      }
      else{
        throw Exception(response.reasonPhrase.toString());
      }
    }catch(e){
      throw Exception(e.toString());

    }
  }
  //Search Task
  Future<TaskListingModel> searchTask({
    required String token, required String searchKey
})async {
    try{
      http.Response response = await http.get(
        Uri.parse("{{TODO_URL}}/todos/search?keywords=$searchKey"),
        headers: {'Authorization': token,},
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return TaskListingModel.fromJson(jsonDecode(response.body));
      }
      else{
        throw Exception(response.reasonPhrase.toString());
      }
    }catch(e){
      throw Exception(e.toString());

    }
  }
}