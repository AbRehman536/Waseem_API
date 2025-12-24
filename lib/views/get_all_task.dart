import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waseem_api/models/task.dart';
import 'package:waseem_api/models/taskListing.dart';
import 'package:waseem_api/service/task.dart';
import 'package:waseem_api/views/create_task.dart';
import 'package:waseem_api/views/filter_task.dart';
import 'package:waseem_api/views/get_Completed_task.dart';
import 'package:waseem_api/views/get_incompleted_task.dart';
import 'package:waseem_api/views/search_task.dart';
import 'package:waseem_api/views/update_task.dart';

import '../providers/user_token_provider.dart';

class GetAllTask extends StatelessWidget {
  const GetAllTask({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Get All Task"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>GetcompletedTask()));

          }, icon: Icon(Icons.circle)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>GetIncompletedTask()));

          }, icon: Icon(Icons.incomplete_circle)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchTask()));

          }, icon: Icon(Icons.search)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>FilterTask()));

          }, icon: Icon(Icons.filter)),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateTask()));
      }),
      body: FutureProvider.value(
          value: TaskServices().getAllTask(userProvider.getToken().toString()),
          initialData: [TaskListingModel()],
      builder: (context, child){
            TaskListingModel taskListingModel = context.watch<TaskListingModel>();
             return taskListingModel.tasks == null ?
                Center(child: CircularProgressIndicator(),)
            : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.task),
                  title: Text(taskListingModel.tasks![index].description.toString()),
                  trailing: Row(children: [
                    IconButton(onPressed: ()async{
                      try{
                        await TaskServices().deleteTask(
                            token: userProvider.getToken().toString(),
                            taskID: taskListingModel.tasks![index].id.toString())
                            .then((value){
                              showDialog(context: context, builder: (BuildContext context) {
                                return AlertDialog(
                                 content: Text("Task delete successfully"),
                                  actions: [
                                    TextButton(onPressed: (){
                                      Navigator.pop(context);
                                    }, child: Text("Okay"))
                                  ],
                                );
                              }, );
                        });
                      }catch(e){
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }, icon: Icon(Icons.delete)),
                    IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateTask(model: Task())));
                    }, icon: Icon(Icons.edit))
                  ],),
                );
              },);
      },
      ),
    );
  }
}
