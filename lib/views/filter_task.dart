import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/taskListing.dart';
import '../providers/user_token_provider.dart';
import '../service/task.dart';

class FilterTaskView extends StatefulWidget {
  const FilterTaskView({super.key});

  @override
  State<FilterTaskView> createState() => _FilterTaskViewState();
}

class _FilterTaskViewState extends State<FilterTaskView> {
  TaskListingModel? taskListingModel;
  bool isLoading = false;
  DateTime? firstDate;
  DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Filter Task"),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          showDatePicker(
                              context: context,
                              firstDate: DateTime(1970),
                              lastDate: DateTime.now())
                              .then((val) {
                            firstDate = val;
                            setState(() {});
                          });
                        },
                        child: Text("Pick First Date")),
                    if (firstDate != null)
                      Text(DateFormat.yMMMMd().format(firstDate!))
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          showDatePicker(
                              context: context,
                              firstDate: DateTime(1970),
                              lastDate: DateTime.now())
                              .then((val) {
                            lastDate = val;
                            setState(() {});
                          });
                        },
                        child: Text("Pick Last Date")),
                    if (lastDate != null)
                      Text(DateFormat.yMMMMd().format(lastDate!))
                  ],
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    isLoading = true;

                    taskListingModel = null;
                    setState(() {});

                    await TaskServices()
                        .filterTask(
                        token: user.getToken().toString(),
                        startDate: firstDate.toString(),
                        endDate: lastDate.toString())
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
                child: Text("Filter Task")),
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