import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../data/todo.dart';

class TodoCardWidget extends StatelessWidget {
  final Todo todo;
  final Function(Todo) removeTodo;
  final Function(int) altertTodo;
  final int index;

  const TodoCardWidget({
    super.key,
    required this.todo,
    required this.removeTodo,
    required this.altertTodo,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 10,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Slidable(
        key: ValueKey(todo),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                removeTodo(todo);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          title: Text(
            todo.title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            todo.subtitle,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
          trailing: GestureDetector(
            onTap: () {
              altertTodo(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: todo.isDone
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 2,
                ),
              ),
              child: Icon(
                todo.isDone ? Icons.check_circle : Icons.check_circle_outline,
                color: todo.isDone
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
