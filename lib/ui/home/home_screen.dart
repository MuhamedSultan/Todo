import 'package:flutter/material.dart';
import 'package:to_do/ui/home/add_task_bottomsheet.dart';
import 'package:to_do/ui/home/settings/settings_tab.dart';
import 'package:to_do/ui/home/todo_list/todo_list_tab.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home_screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Todo App"),
      ),
      floatingActionButton: FloatingActionButton(
        shape: StadiumBorder(side: BorderSide(color: Colors.white, width: 4)),
        onPressed: () {
          showAddTaskSheet();
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.list,
                  size: 32,
                ),
                label: "list"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  size: 32,
                ),
                label: "settings")
          ],
        ),
      ),
      body: tabs[selectedIndex],
    );
  }

  var tabs = [Todolistab(), SettingsTab()];

  void showAddTaskSheet() {
    showModalBottomSheet(context: context, builder: (BuildContext){
      return AddTaskBottomSheet();
    });
  }
}
