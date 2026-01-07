import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/taskListing.dart';
import '../providers/user_token_provider.dart';
import '../service/task.dart';

class SearchTaskView extends StatefulWidget {
  const SearchTaskView({super.key});

  @override
  State<SearchTaskView> createState() => _SearchTaskViewState();
}

class _SearchTaskViewState extends State<SearchTaskView> {
  TaskListingModel? taskListingModel;
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Search Task"),
        ),
        body: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (val) async {
                try {
                  isLoading = true;

                  taskListingModel = null;
                  setState(() {});

                  await TaskServices()
                      .searchTask(
                      token: user.getToken().toString(), searchTask: val)
                      .then((val) {
                    isLoading = false;
                    taskListingModel = val;
                    setState(() {});
                  });
                } catch (e) {
                  isLoading = false;
                  setState(() {});
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
            ),
            if (isLoading == true)
              Center(
                child: CircularProgressIndicator(),
              ),
            if (taskListingModel == null)
              Center(
                child: Text("Type here to search"),
              )
            else
              Expanded(
                child: ListView.builder(
                    itemCount: taskListingModel!.tasks!.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        leading: Icon(Icons.task),
                        title: Text(
                            taskListingModel!.tasks![i].description.toString()),
                      );
                    }),
              ),
          ],
        ));
  }
}