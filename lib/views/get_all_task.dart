import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:waseem_api/views/search_task.dart';
import 'package:waseem_api/views/update_task.dart';

import '../models/taskListing.dart';
import '../providers/user_token_provider.dart';
import '../service/task.dart';
import 'create_task.dart';
import 'filter_task.dart';
import 'get_Completed_task.dart';
import 'get_incompleted_task.dart';

class GetAllTaskView extends StatefulWidget {
  const GetAllTaskView({super.key});

  @override
  State<GetAllTaskView> createState() => _GetAllTaskViewState();
}

class _GetAllTaskViewState extends State<GetAllTaskView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Get All Task"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchTaskView()));
              },
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FilterTaskView()));
              },
              icon: Icon(Icons.filter)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GetCompletedTaskView()));
              },
              icon: Icon(Icons.circle)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GetInCompletedTaskView()));
              },
              icon: Icon(Icons.incomplete_circle)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateTaskView()));
        },
        child: Icon(Icons.add),
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        // color: Colors.transparent,
        child: FutureProvider.value(
          value: TaskServices().getAllTask(userProvider.getToken().toString()),
          initialData: TaskListingModel(),
          builder: (context, child) {
            TaskListingModel taskListingModel =
            context.watch<TaskListingModel>();
            return taskListingModel.tasks == null
                ? Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
                itemCount: taskListingModel.tasks!.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    leading: Icon(Icons.task),
                    title: Text(
                        taskListingModel.tasks![i].description.toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () async {
                              try {
                                isLoading = true;
                                setState(() {});
                                await TaskServices()
                                    .deleteTask(
                                    token: userProvider
                                        .getToken()
                                        .toString(),
                                    taskID: taskListingModel
                                        .tasks![i].id
                                        .toString())
                                    .then((val) {
                                  isLoading = false;
                                  setState(() {});
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                      content: Text(
                                          "Task has been deleted successfully")));
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())));
                              }
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                        IconButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateTaskView(
                                          model:
                                          taskListingModel.tasks![i])));
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            )),
                      ],
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}