import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_bloc/widgets/todo_card.dart';

import '../bloc/todo_bloc.dart';
import '../data/todo.dart';

class TodoListWidget extends StatelessWidget {
  final Function(Todo) addTodo;
  final Function(Todo) removeTodo;
  final Function(int) altertTodo;

  const TodoListWidget({
    super.key,
    required this.addTodo,
    required this.removeTodo,
    required this.altertTodo,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state.status == TodoStatus.success) {
          return ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (context, int i) {
              return TodoCardWidget(
                todo: state.todos[i],
                removeTodo: removeTodo,
                altertTodo: altertTodo,
                index: i,
              );
            },
          );
        } else if (state.status == TodoStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Container();
        }
      },
    );
  }
}
