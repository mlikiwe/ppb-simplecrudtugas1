import 'package:flutter/material.dart';
import 'package:tugas1/utils/todo_list.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  List toDoList = [
    ['mangan', false],
    ['turu', false],
    ['mangan kedua', false],
    ['turu kedua', false],
  ];

  void checkBoxChanged(int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
      sortTasks();
    });
  }

  void saveNewTask() {
    setState(() {
      toDoList.insert(0, [_controller.text, false]);
      _controller.clear();
      sortTasks();
    });
  }

  void deleteTask(int index) {
    setState(() {
      toDoList.removeAt(index);
    });
  }

  void sortTasks() {
    toDoList.sort((a, b) => a[1] ? 1 : -1);
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Task', style: TextStyle(fontFamily: 'Poppins'),),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Enter task name', labelStyle: TextStyle(fontFamily: 'Poppins')),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.red, fontFamily: 'Poppins', fontSize: 15)),
              onPressed: () {
                _controller.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save', style: TextStyle(fontFamily: 'Poppins'),),
              onPressed: () {
                saveNewTask();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditTaskDialog(int index) {
    _controller.text = toDoList[index][0];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Task', style: TextStyle(fontFamily: 'Poppins'),),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Enter task name', labelStyle: TextStyle(fontFamily: 'Poppins')),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.red, fontFamily: 'Poppins', fontSize: 15)),
              onPressed: () {
                _controller.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save', style: TextStyle(fontFamily: 'Poppins'),),
              onPressed: () {
                setState(() {
                  toDoList[index][0] = _controller.text;
                });
                _controller.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List uncompletedTasks = toDoList.where((task) => !task[1]).toList();
    List completedTasks = toDoList.where((task) => task[1]).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tasks',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 199, 149, 0),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                  bottom: 0,
                ),
                child: Text(
                  'Uncompleted Tasks',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ...uncompletedTasks.map((task) {
            int index = toDoList.indexOf(task);
            return TodoList(
              taskName: task[0],
              taskCompleted: task[1],
              onChanged: (value) => checkBoxChanged(index),
              deleteFunction: (context) => deleteTask(index),
              editFunction: (context) => _showEditTaskDialog(index),
            );
          }).toList(),
            Padding(
              padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 20,
                right: 20,
                bottom: 0,
              ),
              child: Text(
                'Completed Tasks',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ...completedTasks.map((task) {
            int index = toDoList.indexOf(task);
            return TodoList(
              taskName: task[0],
              taskCompleted: task[1],
              onChanged: (value) => checkBoxChanged(index),
              deleteFunction: (context) => deleteTask(index),
              editFunction: (context) => _showEditTaskDialog(index),
            );
          }).toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 199, 149, 0),
      ),
    );
  }
}