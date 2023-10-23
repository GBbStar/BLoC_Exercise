// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:todo_example/core/provider/core_provider.dart';
//
// class TodoItem extends ConsumerWidget {
//   const TodoItem({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final todo = ref.watch(currentTodoProvider);
//     final itemFocusNode = FocusNode();
//     itemFocusNode.addListener(() => setState());
//     final itemIsFocused = itemFocusNode.hasFocus;
//
//     final textEditingController = TextEditingController();
//     final textFieldFocusNode = FocusNode();
//
//     return Material(
//       color: Colors.white,
//       elevation: 6,
//       child: Focus(
//         focusNode: itemFocusNode,
//         onFocusChange: (focused) {
//           if (focused) {
//             textEditingController.text = todo.description;
//           } else {
//             ref
//                 .read(todoListProvider.notifier)
//                 .edit(id: todo.id, description: textEditingController.text);
//           }
//         },
//         child: ListTile(
//           onTap: () {
//             itemFocusNode.requestFocus();
//             textFieldFocusNode.requestFocus();
//           },
//           leading: Checkbox(
//             value: todo.completed,
//             onChanged: (value) =>
//                 ref.read(todoListProvider.notifier).toggle(todo.id),
//           ),
//           title: itemIsFocused
//               ? TextField(
//             autofocus: true,
//             focusNode: textFieldFocusNode,
//             controller: textEditingController,
//           )
//               : Text(todo.description),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_bloc/domain/bloc/edit_todo/edit_todo_bloc.dart';
import 'package:flutter_todos_bloc/domain/bloc/todo_list/todo_list_bloc.dart';
import 'package:flutter_todos_bloc/domain/event/edit_todo/edit_todo_event.dart';
import 'package:flutter_todos_bloc/domain/event/todo_list/todo_list_event.dart';
import 'package:flutter_todos_bloc/domain/state/edit_todo/edit_todo_state.dart';
import 'package:flutter_todos_bloc/domain/state/todo_list/todo_list_state.dart';
import 'package:todos_repository/todos_repository.dart';

class TodoItemView extends StatelessWidget {
  final Todo? initialTodo;

  TodoItemView({this.initialTodo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditTodoBloc(
        todosRepository: context.read<TodosRepository>(),
        initialTodo: initialTodo,
      ),
      child: const TodoItem(),
    );
  }
}

class TodoItem extends StatefulWidget {
  const TodoItem({super.key});

  @override
  State<StatefulWidget> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  _TodoItemState();

  bool itemIsFocused = false;

  late final itemFocusNode;
  late final textFieldFocusNode;
  late final textEditingController;

  @override
  void initState() {
    super.initState();
    itemFocusNode = FocusNode();
    textFieldFocusNode = FocusNode();
    textEditingController = TextEditingController();
    itemFocusNode.addListener(() => setState(() {
          itemIsFocused = itemFocusNode.hasFocus;
        }));
  }

  @override
  Widget build(BuildContext context) {
    // final status = context.select((EditTodoBloc bloc) => bloc.state.status);
    // final isNewTodo = context.select(
    //   (EditTodoBloc bloc) => bloc.state.isNewTodo,
    // );
    // final state = context.watch<EditTodoBloc>().state;

    return BlocBuilder<EditTodoBloc, EditTodoState>(builder: (context, state) {
      return  Material(
        color: Colors.white,
        elevation: 6,
        child: Focus(
          focusNode: itemFocusNode,
          onFocusChange: (focused) {
            if (focused) {
              // textEditingController.text = state.initialTodo?.description ?? "";
              textEditingController.text = state.description;
            } else {
              context
                  .read<EditTodoBloc>()
                  .add(EditTodoDescriptionChanged(textEditingController.text));
              ;
              // if (!status.isLoadingOrSuccess)
              //   context.read<EditTodoBloc>().add(const EditTodoSubmitted());
              // ref
              //     .read(todoListProvider.notifier)
              //     .edit(id: todo.id, description: textEditingController.text);
              context.read<EditTodoBloc>().add(const EditTodoSubmitted());

            }
          },
          child: ListTile(
            onTap: () {
              itemFocusNode.requestFocus();
              textFieldFocusNode.requestFocus();
            },
            leading: Checkbox(
              // value: state.initialTodo?.isCompleted,
              value: state.isComplete,
              // onChanged: (value) =>
              //     ref.read(todoListProvider.notifier).toggle(todo.id),
              onChanged: (isCompleted) {
                context.read<EditTodoBloc>().add(
                      EditTodoCompletionToggled(
                        isCompleted: isCompleted ?? false,
                      ),
                    );
                if (!context
                    .read<EditTodoBloc>()
                    .state
                    .status
                    .isLoadingOrSuccess)
                  context.read<EditTodoBloc>().add(const EditTodoSubmitted());
              },
            ),
            title: itemIsFocused
                ? TextField(
                    autofocus: true,
                    focusNode: textFieldFocusNode,
                    controller: textEditingController,
                  )
                : Text(state.description),
          ),
        ),
      );
    });
  }
}
