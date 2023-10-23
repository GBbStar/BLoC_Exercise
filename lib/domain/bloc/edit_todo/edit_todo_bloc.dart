import 'package:bloc/bloc.dart';
import 'package:flutter_todos_bloc/domain/event/edit_todo/edit_todo_event.dart';
import 'package:flutter_todos_bloc/domain/state/edit_todo/edit_todo_state.dart';
import 'package:todos_repository/todos_repository.dart';

class EditTodoBloc extends Bloc<EditTodoEvent, EditTodoState> {
  EditTodoBloc({
    required TodosRepository todosRepository,
    Todo? initialTodo,
  })  : _todosRepository = todosRepository,
        super(
          EditTodoState(
            initialTodo: initialTodo,
            title: initialTodo?.title ?? '',
            description: initialTodo?.description ?? '',
            isComplete: initialTodo?.isCompleted ?? false,
          ),
        ) {
    on<EditTodoTitleChanged>(_onTitleChanged);
    on<EditTodoDescriptionChanged>(_onDescriptionChanged);
    on<EditTodoSubmitted>(_onSubmitted);
    on<EditTodoCompletionToggled>(_onTodoCompletionToggled);
  }

  final TodosRepository _todosRepository;

  void _onTitleChanged(
    EditTodoTitleChanged event,
    Emitter<EditTodoState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onDescriptionChanged(
    EditTodoDescriptionChanged event,
    Emitter<EditTodoState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  Future<void> _onSubmitted(
    EditTodoSubmitted event,
    Emitter<EditTodoState> emit,
  ) async {
    // emit(state.copyWith(status: EditTodoStatus.loading));
    final todo = (state.initialTodo ?? Todo(title: '')).copyWith(
      title: state.title,
      description: state.description,
      isCompleted: state.isComplete,
    );

    try {
      await _todosRepository.saveTodo(todo);
    } catch (e) {
    }
  }

  Future<void> _onTodoCompletionToggled(
      EditTodoCompletionToggled event,
      Emitter<EditTodoState> emit,
      ) async {
    emit(state.copyWith(isComplete: event.isCompleted));
  }
}
