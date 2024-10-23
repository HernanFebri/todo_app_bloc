import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app_bloc/bloc/todo_bloc.dart';
import 'package:todo_app_bloc/data/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Define FocusNode for task title and description
  final FocusNode _taskTitleFocus = FocusNode();
  final FocusNode _taskDescriptionFocus = FocusNode();

  @override
  void dispose() {
    // Dispose focus nodes when no longer needed
    _taskTitleFocus.dispose();
    _taskDescriptionFocus.dispose();
    super.dispose();
  }

  addTodo(Todo todo) {
    context.read<TodoBloc>().add(
          AddTodo(todo),
        );
  }

  removeTodo(Todo todo) {
    context.read<TodoBloc>().add(
          RemoveTodo(todo),
        );
  }

  altertTodo(int index) {
    context.read<TodoBloc>().add(
          AlterTodo(index),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Todo App',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state.status == TodoStatus.success) {
              return ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, int i) {
                  return Card(
                    color: Theme.of(context).colorScheme.primary,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Slidable(
                      key: const ValueKey(0),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) {
                              removeTodo(state.todos[i]);
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          state.todos[i].title,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          state.todos[i].subtitle,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        trailing: Checkbox(
                          value: state.todos[i].isDone,
                          activeColor: Theme.of(context)
                              .colorScheme
                              .secondary, // Warna saat aktif
                          checkColor:
                              Colors.white, // Warna centang di dalam checkbox
                          onChanged: (value) {
                            altertTodo(i);
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state.status == TodoStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Container();
            }
          },
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              TextEditingController controller1 = TextEditingController();
              TextEditingController controller2 = TextEditingController();
              return AlertDialog(
                title: const Center(
                  child: Text(
                    'Add a Task',
                  ),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller1,
                        focusNode:
                            _taskTitleFocus, // Set focus node for task title
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Task Title...',
                          hintStyle: const TextStyle(
                              color: Colors.grey), // Warna hint text abu-abu
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        onSubmitted: (value) {
                          // Move focus to task description when enter is pressed
                          FocusScope.of(context)
                              .requestFocus(_taskDescriptionFocus);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: controller2,
                        focusNode:
                            _taskDescriptionFocus, // Set focus node for task description
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Task Description...',
                          hintStyle: const TextStyle(
                              color: Colors.grey), // Warna hint text abu-abu
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextButton(
                      onPressed: () {
                        addTodo(
                          Todo(
                            title: controller1.text,
                            subtitle: controller2.text,
                          ),
                        );
                        controller1.text = '';
                        controller2.text = '';
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        foregroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Icon(
                          CupertinoIcons.check_mark,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          CupertinoIcons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
