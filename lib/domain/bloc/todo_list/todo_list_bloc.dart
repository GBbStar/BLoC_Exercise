import 'package:bloc/bloc.dart';
import 'package:flutter_todos_bloc/domain/event/todo_list/todo_list_event.dart';
import 'package:flutter_todos_bloc/domain/state/todo_list/todo_list_state.dart';
import 'package:todos_repository/todos_repository.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc({
    required TodosRepository todosRepository,
  })  : _todosRepository = todosRepository,
        super(const TodoListState()) {
    on<TodoListSubscriptionRequested>(_onSubscriptionRequested);
    on<TodoListTodoDeleted>(_onTodoDeleted);
    on<TodoListUndoDeletionRequested>(_onUndoDeletionRequested);
    on<TodoListFilterChanged>(_onFilterChanged);
    on<TodoListToggleAllRequested>(_onToggleAllRequested);
    on<TodoListClearCompletedRequested>(_onClearCompletedRequested);
  }

  final TodosRepository _todosRepository;

  Future<void> _onSubscriptionRequested(
      TodoListSubscriptionRequested event,
    Emitter<TodoListState> emit,
  ) async {
    emit(state.copyWith(status: () => TodoListStatus.loading));

    await emit.forEach<List<Todo>>(
      _todosRepository.getTodos(),
      onData: (todos) => state.copyWith(
        status: () => TodoListStatus.success,
        todos: () => todos,
      ),
      onError: (_, __) => state.copyWith(
        status: () => TodoListStatus.failure,
      ),
    );
  }

  Future<void> _onTodoDeleted(
      TodoListTodoDeleted event,
    Emitter<TodoListState> emit,
  ) async {
    emit(state.copyWith(lastDeletedTodo: () => event.todo));
    await _todosRepository.deleteTodo(event.todo.id);
  }

  Future<void> _onUndoDeletionRequested(
      TodoListUndoDeletionRequested event,
    Emitter<TodoListState> emit,
  ) async {
    assert(
      state.lastDeletedTodo != null,
      'Last deleted todo can not be null.',
    );

    final todo = state.lastDeletedTodo!;
    emit(state.copyWith(lastDeletedTodo: () => null));
    await _todosRepository.saveTodo(todo);
  }

  void _onFilterChanged(
      TodoListFilterChanged event,
    Emitter<TodoListState> emit,
  ) {
    emit(state.copyWith(filter: () => event.filter));
  }

  Future<void> _onToggleAllRequested(
      TodoListToggleAllRequested event,
    Emitter<TodoListState> emit,
  ) async {
    final areAllCompleted = state.todos.every((todo) => todo.isCompleted);
    await _todosRepository.completeAll(isCompleted: !areAllCompleted);
  }

  Future<void> _onClearCompletedRequested(
      TodoListClearCompletedRequested event,
    Emitter<TodoListState> emit,
  ) async {
    await _todosRepository.clearCompleted();
  }
}
