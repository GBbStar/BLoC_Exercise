import 'package:equatable/equatable.dart';
import 'package:todos_repository/todos_repository.dart';

enum EditTodoStatus { initial, loading, success, failure }

extension EditTodoStatusX on EditTodoStatus {
  bool get isLoadingOrSuccess => [
        EditTodoStatus.loading,
        EditTodoStatus.success,
      ].contains(this);
}

final class EditTodoState extends Equatable {
  final EditTodoStatus status;
  final Todo? initialTodo;
  final String title;
  final String description;
  final bool isComplete;

  const EditTodoState({
    this.status = EditTodoStatus.initial,
    this.initialTodo,
    this.title = '',
    this.description = '',
    this.isComplete = false,
  });

  // bool get isNewTodo => initialTodo == null;

  EditTodoState copyWith({
    EditTodoStatus? status,
    Todo? initialTodo,
    String? title,
    String? description,
    bool? isComplete,
  }) {
    return EditTodoState(
      status: status ?? this.status,
      initialTodo: initialTodo ?? this.initialTodo,
      title: title ?? this.title,
      description: description ?? this.description,
      isComplete: isComplete ?? false,
    );
  }

  @override
  // List<Object?> get props => [status, initialTodo, title, description, isComplete,];
  List<Object?> get props => [status, title, description, isComplete,];
}
