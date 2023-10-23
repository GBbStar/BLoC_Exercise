import 'package:equatable/equatable.dart';

sealed class EditTodoEvent extends Equatable {
  const EditTodoEvent();

  @override
  List<Object> get props => [];
}
final class EditTodoCompletionToggled extends EditTodoEvent {
  const EditTodoCompletionToggled({
    required this.isCompleted,
  });

  final bool isCompleted;

  @override
  List<Object> get props => [ isCompleted];
}

final class EditTodoTitleChanged extends EditTodoEvent {
  const EditTodoTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

final class EditTodoDescriptionChanged extends EditTodoEvent {
  const EditTodoDescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

final class EditTodoSubmitted extends EditTodoEvent {
  const EditTodoSubmitted();
}
