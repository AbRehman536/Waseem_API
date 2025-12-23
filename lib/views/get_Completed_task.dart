import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waseem_api/models/taskListing.dart';
import 'package:waseem_api/service/task.dart';

import '../providers/user_token_provider.dart';

class GetcompletedTask extends StatelessWidget {
  const GetcompletedTask({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Completed Task"),
      ),
      body: FutureProvider.value(
        value: TaskServices().getCompletedTask(userProvider.getToken().toString()),
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
                trailing: Icon(Icons.arrow_forward_ios),
              );
            },);
        },
      ),
    );
  }
}
