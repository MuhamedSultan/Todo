import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:to_do/providers/auth_provider.dart';
import 'package:to_do/ui/database/my_database.dart';
import 'package:to_do/ui/dialouge_utlis.dart';

import '../../database/model/task.dart';

class TaskItem extends StatefulWidget {
  Task task;

  TaskItem(this.task);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: .3,
          motion: DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (buildContext) {
                deleteTask();
              },
              icon: Icons.delete,
              backgroundColor: Colors.red,
              label: 'Delete',
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18)),
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18))),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(18)),
                width: 8,
                height: 80,
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.task.title}',
                    style: TextStyle(
                        fontSize: 18, color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Text('${widget.task.description}'),
                ],
              )),
              const SizedBox(
                width: 12,
              ),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 21, vertical: 7),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void deleteTask() {
    var authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    DialogUtils.showMessage(context, 'Do you want to delete task',
        posActionName: 'Yes', posAction: () async {
      try {
        await MyDatabase.deleteTask(
            authProvider.currentUser?.id ?? "", widget.task.id ?? "");
      } catch (e) {
        DialogUtils.showMessage(
            context,
            'Something went wrong'
            '${e.toString()}');
        Fluttertoast.showToast(msg: 'Task Deleted Successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
      }
      setState(() {
      });
    }, negActionName: 'Cancel');
  }
}
