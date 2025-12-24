import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waseem_api/models/task.dart';
import 'package:waseem_api/providers/user_token_provider.dart';
import 'package:waseem_api/service/task.dart';
import 'package:waseem_api/views/get_all_task.dart';

class UpdateTask extends StatefulWidget {
  final Task model;
  const UpdateTask({super.key, required this.model});

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Task"),
      ),
      body: Column(children: [
        TextField(
          controller: descriptionController,
        ),
        isLoading ? Center(child: CircularProgressIndicator(),)
            :ElevatedButton(onPressed: ()async{
              try{
                isLoading = true;
                setState(() {});
                await TaskServices().updateTask(
                    token: userProvider.getToken().toString(),
                    taskID: widget.model.id.toString(),
                    description: descriptionController.text.toString())
                    .then((value){
                  isLoading = false;
                  setState(() {});
                  showDialog(context: context, builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text("Update Successfully"),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> GetAllTask()));
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
        }, child: Text("Update Task"))
      ],),
    );
  }
}
