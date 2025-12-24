import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:waseem_api/models/taskListing.dart';
import 'package:waseem_api/providers/user_token_provider.dart';
import 'package:waseem_api/service/task.dart';

class FilterTask extends StatefulWidget {
  const FilterTask({super.key});

  @override
  State<FilterTask> createState() => _FilterTaskState();
}

class _FilterTaskState extends State<FilterTask> {
  TaskListingModel? taskListingModel;
  bool isLoading = false;
  DateTime? firstDate;
  DateTime? lastDate;
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter Task"),
      ),
      body: Column(children: [
        Row(children: [
          ElevatedButton(onPressed: (){
            showDatePicker(
                context: context, 
                firstDate: DateTime(1970), 
                lastDate: DateTime.now())
                .then((value){
                  setState(() {
                    firstDate = value;
                  });
            });
          }, child: Text("Select First Date")),
          if(taskListingModel != null)
            Text(DateFormat.yMMMMEEEEd().format(firstDate!)),
          ElevatedButton(onPressed: (){
            showDatePicker(
                context: context,
                firstDate: DateTime(1970),
                lastDate: DateTime.now())
                .then((value){
              setState(() {
                lastDate = value;
              });
            });
          }, child: Text("Select Last Date")),
          if(taskListingModel != null)
            Text(DateFormat.yMMMMEEEEd().format(lastDate!)),

          ElevatedButton(onPressed: ()async{
            try{
              isLoading = true;
              taskListingModel == null;
              setState(() {});
              await TaskServices().filterTask(
                  token: userProvider.getToken().toString(),
                  startDate: firstDate.toString(),
                  endDate: lastDate.toString())
              .then((val){
                isLoading = false;
                taskListingModel = val;
                setState(() {});
              });
            }catch(e){
              isLoading = false;
              setState(() {});
              ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
            }
          }, child: Text("Filter Task")),
    if(isLoading == true)
    Center(child: CircularProgressIndicator(),),
    if(taskListingModel == null)
    Center(child: Text("Filter Task"),),
    Center(
    child: ListView.builder(itemBuilder: (BuildContext context, int index) {
    return ListTile(
    leading: Icon(Icons.task),
    title: Text(taskListingModel!.tasks![index].description.toString()),
    );
    },),),

        ],)
      ],),
    );
  }
}
