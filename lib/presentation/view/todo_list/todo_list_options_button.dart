import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_bloc/domain/bloc/todo_list/todo_list_bloc.dart';
import 'package:flutter_todos_bloc/domain/event/todo_list/todo_list_event.dart';

@visibleForTesting
enum TodoListOption { toggleAll, clearCompleted }

class TodoListOptionsButton extends StatelessWidget {
  const TodoListOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = context.select((TodoListBloc bloc) => bloc.state.todos);
    final hasTodos = todos.isNotEmpty;
    final completedTodosAmount = todos.where((todo) => todo.isCompleted).length;

    return PopupMenuButton<TodoListOption>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      tooltip: "툴팁",
      onSelected: (options) {
        switch (options) {
          case TodoListOption.toggleAll:
            context
                .read<TodoListBloc>()
                .add(const TodoListToggleAllRequested());
          case TodoListOption.clearCompleted:
            context
                .read<TodoListBloc>()
                .add(const TodoListClearCompletedRequested());
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: TodoListOption.toggleAll,
            enabled: hasTodos,
            child: Text(
              completedTodosAmount == todos.length
                  ? "1"
                  : "2"
            ),
          ),
          PopupMenuItem(
            value: TodoListOption.clearCompleted,
            enabled: hasTodos && completedTodosAmount > 0,
            child: Text("3"),
          ),
        ];
      },
      icon: const Icon(Icons.more_vert_rounded),
    );
  }
}
