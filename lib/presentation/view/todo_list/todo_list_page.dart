import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_bloc/domain/bloc/todo_list/todo_list_bloc.dart';
import 'package:flutter_todos_bloc/domain/event/todo_list/todo_list_event.dart';
import 'package:flutter_todos_bloc/domain/state/todo_list/todo_list_state.dart';
import 'package:flutter_todos_bloc/presentation/view/edit_todo/edit_todo_page.dart';
import 'package:flutter_todos_bloc/presentation/view/todo_list/todo_list_filter_button.dart';
import 'package:flutter_todos_bloc/presentation/view/todo_list/todo_list_options_button.dart';
import 'package:flutter_todos_bloc/presentation/view/todo_list/todo_list_tile.dart';
import 'package:todos_repository/todos_repository.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoListBloc(
        todosRepository: context.read<TodosRepository>(),
      )..add(const TodoListSubscriptionRequested()),
      child: const TodoListView(),
    );
  }
}

class TodoListView extends StatelessWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Todo Bloc Example"),
        actions: const [
          TodoListFilterButton(),
          TodoListOptionsButton(),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TodoListBloc, TodoListState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == TodoListStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text("에러"),
                    ),
                  );
              }
            },
          ),
          BlocListener<TodoListBloc, TodoListState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedTodo != current.lastDeletedTodo &&
                current.lastDeletedTodo != null,
            listener: (context, state) {
              final deletedTodo = state.lastDeletedTodo!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text("삭제"),
                    action: SnackBarAction(
                      label: "삭제",
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<TodoListBloc>()
                            .add(const TodoListUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<TodoListBloc, TodoListState>(
          builder: (context, state) {
            if (state.todos.isEmpty) {
              if (state.status == TodoListStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != TodoListStatus.success) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text(
                    "빈",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
            }

            return CupertinoScrollbar(
              child: ListView(
                children: [
                  for (final todo in state.filteredTodos)
                    TodoListTile(
                      todo: todo,
                      onToggleCompleted: (isCompleted) {
                        context.read<TodoListBloc>().add(
                              TodoListTodoCompletionToggled(
                                todo: todo,
                                isCompleted: isCompleted,
                              ),
                            );
                      },
                      onDismissed: (_) {
                        context
                            .read<TodoListBloc>()
                            .add(TodoListTodoDeleted(todo));
                      },
                      onTap: () {
                        Navigator.of(context).push(
                          EditTodoPage.route(initialTodo: todo),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
