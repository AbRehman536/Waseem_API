import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waseem_api/providers/user_token_provider.dart';
import 'package:waseem_api/service/task.dart';

import 'get_all_task.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Task"),
      ),
      body: Column(children: [
        TextField(controller: descriptionController,),
        isLoading ? Center(child: CircularProgressIndicator(),)
            :ElevatedButton(onPressed: ()async{
              try{
                isLoading = true;
                setState(() {});
                await TaskServices()
                    .createTask(
                    token: userProvider.getToken().toString(),
                    description: descriptionController.text)
                    .then((value){
                  isLoading = false;
                  setState(() {});
                      showDialog(context: context, builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text("Create Successfully"),
                          actions: [
                            TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>GetAllTask()));
                            }, child: Text("Okay"))
                          ],
                        );
                      }, );
                });
              }catch(e){
                isLoading = false;
                setState(() {});
                ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));
              }
        }, child: Text("Create Task"))
      ],),
    );
  }
}
