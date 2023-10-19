import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_bloc/domain/bloc/todo_list/todo_list_bloc.dart';
import 'package:flutter_todos_bloc/domain/event/todo_list/todo_list_event.dart';

class TodoListFilterButton extends StatelessWidget {
  const TodoListFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final activeFilter =
        context.select((TodoListBloc bloc) => bloc.state.filter);

    return PopupMenuButton<TodosViewFilter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: activeFilter,
      tooltip: "툴팁",
      onSelected: (filter) {
        context
            .read<TodoListBloc>()
            .add(TodoListFilterChanged(filter));
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: TodosViewFilter.all,
            child: Text("전체 목록"),
          ),
          PopupMenuItem(
            value: TodosViewFilter.activeOnly,
            child: Text("남은 목록"),
          ),
          PopupMenuItem(
            value: TodosViewFilter.completedOnly,
            child: Text("완료 목록"),
          ),
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}
