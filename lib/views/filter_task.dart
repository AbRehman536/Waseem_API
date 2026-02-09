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
                if (firstDate == null || lastDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please pick both start and end dates")),
                  );
                  return;
                }

                try {
                  setState(() {
                    isLoading = true;
                    taskListingModel = null;
                  });

                  // Convert dates to ISO string
                  final start = firstDate!.toUtc().toIso8601String();
                  final end = lastDate!.add(const Duration(days: 1)).toUtc().toIso8601String();

                  TaskListingModel filteredTasks = await TaskServices().filterTask(
                    token: user.getToken().toString(),
                    startDate: start,
                    endDate: end,
                  );

                  setState(() {
                    isLoading = false;
                    taskListingModel = filteredTasks;
                  });
                } catch (e) {
                  setState(() => isLoading = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              child: const Text("Filter Task"),
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