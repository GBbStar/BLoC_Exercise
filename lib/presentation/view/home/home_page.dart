import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_bloc/domain/bloc/edit_todo/edit_todo_bloc.dart';
import 'package:flutter_todos_bloc/domain/bloc/todo_list/todo_list_bloc.dart';
import 'package:flutter_todos_bloc/domain/event/edit_todo/edit_todo_event.dart';
import 'package:flutter_todos_bloc/domain/event/todo_list/todo_list_event.dart';
import 'package:flutter_todos_bloc/domain/state/todo_list/todo_list_state.dart';
import 'package:flutter_todos_bloc/presentation/view/common/title.dart';
import 'package:flutter_todos_bloc/presentation/view/common/toolbar.dart';
import 'package:flutter_todos_bloc/presentation/view/todo/todo_item.dart';
import 'package:todos_repository/todos_repository.dart';

final addTodoKey = UniqueKey();

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodoListBloc(
            todosRepository: context.read<TodosRepository>(),
          )..add(const TodoListSubscriptionRequested()),
        ),
        BlocProvider(
          create: (context) => EditTodoBloc(
            todosRepository: context.read<TodosRepository>(),
          ),
        )
      ],
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController newTodoController = TextEditingController();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        children: [
          MyTitle(),
          TextFormField(
            controller: newTodoController,
            decoration: const InputDecoration(
              labelText: 'What needs to be done?',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onFieldSubmitted: (field) {
              if (field.isEmpty) return;
              context
                  .read<EditTodoBloc>()
                  .add(EditTodoDescriptionChanged(field));

              context.read<EditTodoBloc>().add(const EditTodoSubmitted());

              FocusScope.of(context).unfocus();
            },
          ),
          const SizedBox(height: 42),
          Toolbar(),
          todoList(),
        ],
      ),
    );
  }

  Widget todoList() {
    return BlocBuilder<TodoListBloc, TodoListState>(
      builder: (context, state) {
        final todos = state.filteredTodos.toList();
        return Column(
          children: [
            if (todos.isNotEmpty) const Divider(height: 0),
            for (var i = 0; i < todos.length; i++) ...[
              if (i > 0) const Divider(height: 0),
              Dismissible(
                key: ValueKey(todos[i].id),
                child: TodoItemView(
                  initialTodo: todos[i],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
