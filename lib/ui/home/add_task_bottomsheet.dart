import 'package:flutter/material.dart';
import 'package:to_do/date_utils.dart';
import 'package:to_do/ui/components/custom_form_field.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var titleController = TextEditingController();

  var descriptionController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "add new task ",
              style: Theme.of(context).textTheme.headline4,
            ),
            CustomFormField(
                label: "Task title",
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'please enter task title';
                  }
                },
                controller: titleController),
            CustomFormField(
                label: "Task description",
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'please enter task description';
                  }
                },
                lines: 5,
                controller: descriptionController),
            SizedBox(
              height: 12,
            ),
            Text(
              "Task Date",
              style: TextStyle(fontSize: 12),
            ),
            InkWell(
              onTap: () {
                showTakeDatePicker();
              },
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: Colors.black26),
                  )),
                  child: Text(
                      "${MyDateUtils.formatTaskDate(selectedDate)}",
                      style: TextStyle(fontSize: 18))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(16)),
              onPressed: () {
                addTask();
              },
              child: Text(
                "Add task",
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }

  void addTask() {
    if (formKey.currentState?.validate() == false) {
      return;
    }
  }

  var selectedDate = DateTime.now();

  void showTakeDatePicker() async {
    var date = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (date == null) return;
    setState(() {
      selectedDate = date;
    });
  }
}