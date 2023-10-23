import 'package:equatable/equatable.dart';
import 'package:flutter_todos_bloc/domain/event/todo_list/todo_list_event.dart';
import 'package:todos_repository/todos_repository.dart';

enum TodoListStatus { initial, loading, success, failure }

final class TodoListState extends Equatable {
  const TodoListState({
    this.status = TodoListStatus.initial,
    this.todos = const [],
    this.filter = TodosViewFilter.all,
    this.lastDeletedTodo,
  });

  final TodoListStatus status;
  final List<Todo> todos;
  final TodosViewFilter filter;
  final Todo? lastDeletedTodo;

  Iterable<Todo> get filteredTodos => filter.applyAll(todos);

  int filteredTodoCount(TodosViewFilter filter) {
    switch (filter) {
      case TodosViewFilter.all:
        return  todos.length;
      case TodosViewFilter.activeOnly:
        return  todos.where((Todo todo) => !todo.isCompleted).length;
      case TodosViewFilter.completedOnly:
        return  todos.where((Todo todo) => todo.isCompleted).length;
      default:
        return -1;
    }
  }

  TodoListState copyWith({
    TodoListStatus Function()? status,
    List<Todo> Function()? todos,
    TodosViewFilter Function()? filter,
    Todo? Function()? lastDeletedTodo,
  }) {
    return TodoListState(
      status: status != null ? status() : this.status,
      todos: todos != null ? todos() : this.todos,
      filter: filter != null ? filter() : this.filter,
      lastDeletedTodo:
          lastDeletedTodo != null ? lastDeletedTodo() : this.lastDeletedTodo,
    );
  }

  @override
  List<Object?> get props => [
        status,
        todos,
        filter,
        lastDeletedTodo,
      ];
}
