import 'package:equatable/equatable.dart';
import 'package:todos_repository/todos_repository.dart';

enum TodosViewFilter { all, activeOnly, completedOnly }

extension TodosViewFilterX on TodosViewFilter {
  bool apply(Todo todo) {
    switch (this) {
      case TodosViewFilter.all:
        return true;
      case TodosViewFilter.activeOnly:
        return !todo.isCompleted;
      case TodosViewFilter.completedOnly:
        return todo.isCompleted;
    }
  }

  Iterable<Todo> applyAll(Iterable<Todo> todos) {
    return todos.where(apply);
  }
}

sealed class TodoListEvent extends Equatable {
  const TodoListEvent();

  @override
  List<Object> get props => [];
}

final class TodoListSubscriptionRequested extends TodoListEvent {
  const TodoListSubscriptionRequested();
}

final class TodoListTodoDeleted extends TodoListEvent {
  const TodoListTodoDeleted(this.todo);

  final Todo todo;

  @override
  List<Object> get props => [todo];
}

final class TodoListUndoDeletionRequested extends TodoListEvent {
  const TodoListUndoDeletionRequested();
}

class TodoListFilterChanged extends TodoListEvent {
  const TodoListFilterChanged(this.filter);

  final TodosViewFilter filter;

  @override
  List<Object> get props => [filter];
}

class TodoListToggleAllRequested extends TodoListEvent {
  const TodoListToggleAllRequested();
}

class TodoListClearCompletedRequested extends TodoListEvent {
  const TodoListClearCompletedRequested();
}
