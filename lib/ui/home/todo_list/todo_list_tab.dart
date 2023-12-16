import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/providers/auth_provider.dart';
import 'package:to_do/ui/database/model/task.dart';
import 'package:to_do/ui/database/my_database.dart';
import 'package:to_do/ui/home/todo_list/task_item.dart';

class TodolistTab extends StatefulWidget {
  @override
  State<TodolistTab> createState() => _TodolistTabState();
}

class _TodolistTabState extends State<TodolistTab> {
  // --
  // List<Task> tasksList = [];

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<MyAuthProvider>(context);
    // --
    // if (tasksList.isEmpty) {
    //   readTasksFromDatabase();
    // }
    return Container(
      child: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot<Task>>(
            stream: MyDatabase.getTasksRealTimeUpdate(authProvider.currentUser?.id ?? ""),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              var tasksList =
                  snapshot.data?.docs.map((docs) => docs.data()).toList();
              if (tasksList?.isEmpty == true) {
                return Center(child: Text("No tasks"));
              }
              return ListView.builder(
                itemBuilder: (context, position) {
                  return TaskItem(tasksList![position]);
                },
                itemCount: tasksList?.length,
              );
            },
          )
              // --
              // tasksList.isEmpty
              //     ? const Center(
              //   child: CircularProgressIndicator(),
              // )
              //     : ListView.builder(
              //   itemBuilder: (buildContext, position) {
              //     return TaskItem(tasksList[position]);
              //   },
              //   itemCount: tasksList.length,
              // )
              )
        ],
      ),
    );
  }

//another way to read tasks from database but not efficient --
// readTasksFromDatabase() async {
//   var authProvider = Provider.of<MyAuthProvider>(context, listen: false);
//   var result = await MyDatabase.getTasks(authProvider.currentUser?.id ?? "");
//   tasksList = result.docs.map((docSnapshot) => docSnapshot.data()).toList();
//   setState(() {});
// }
}
