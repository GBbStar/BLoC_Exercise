// import 'package:flutter/material.dart';
//
// class Toolbar extends ConsumerWidget {
//   const Toolbar({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final filter = ref.watch(todoListProvider);
//
//     Color? textColorFor(TodoListFilter value) {
//       return filter == value ? Colors.blue : Colors.black;
//     }
//
//     return Material(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Text(
//               '${ref.watch(uncompletedTodosCountProvider)} items left',
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           Tooltip(
//             key: allFilterKey,
//             message: 'All todos',
//             child: TextButton(
//               onPressed: () =>
//               ref.read(todoListFilteredProvider.notifier).state = TodoListFilter.all,
//               style: ButtonStyle(
//                 visualDensity: VisualDensity.compact,
//                 foregroundColor:
//                 MaterialStateProperty.all(textColorFor(TodoListFilter.all)),
//               ),
//               child: const Text('All'),
//             ),
//           ),
//           Tooltip(
//             key: activeFilterKey,
//             message: 'Only uncompleted todos',
//             child: TextButton(
//               onPressed: () => ref.read(todoListFilteredProvider.notifier).state =
//                   TodoListFilter.active,
//               style: ButtonStyle(
//                 visualDensity: VisualDensity.compact,
//                 foregroundColor: MaterialStateProperty.all(
//                   textColorFor(TodoListFilter.active),
//                 ),
//               ),
//               child: const Text('Active'),
//             ),
//           ),
//           Tooltip(
//             key: completedFilterKey,
//             message: 'Only completed todos',
//             child: TextButton(
//               onPressed: () => ref.read(todoListFilteredProvider.notifier).state =
//                   TodoListFilter.completed,
//               style: ButtonStyle(
//                 visualDensity: VisualDensity.compact,
//                 foregroundColor: MaterialStateProperty.all(
//                   textColorFor(TodoListFilter.completed),
//                 ),
//               ),
//               child: const Text('Completed'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_bloc/domain/bloc/todo_list/todo_list_bloc.dart';
import 'package:flutter_todos_bloc/domain/event/todo_list/todo_list_event.dart';
import 'package:flutter_todos_bloc/domain/state/todo_list/todo_list_state.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({
    super.key,
  });

  Color? textColorFor(TodosViewFilter filter, TodosViewFilter currentFilter) {
    return currentFilter == filter ? Colors.blue : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoListBloc, TodoListState>(
      builder: (context, state) {
        return Material(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${state.filteredTodoCount(TodosViewFilter.activeOnly)}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Tooltip(
                // key: allFilterKey,
                message: 'All todos',
                child: TextButton(
                  // onPressed: () => ref
                  //     .read(todoListFilteredProvider.notifier)
                  //     .state = TodoListFilter.all,
                  onPressed: () {
                    context
                        .read<TodoListBloc>()
                        .add(TodoListFilterChanged(TodosViewFilter.all));
                  },
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: MaterialStateProperty.all(
                        textColorFor(state.filter, TodosViewFilter.all)),
                  ),
                  child: const Text('All'),
                ),
              ),
              Tooltip(
                // key: activeFilterKey,
                message: 'Only uncompleted todos',
                child: TextButton(
                  // onPressed: () => ref
                  //     .read(todoListFilteredProvider.notifier)
                  //     .state = TodoListFilter.active,
                  onPressed: () {
                    context
                        .read<TodoListBloc>()
                        .add(TodoListFilterChanged(TodosViewFilter.activeOnly));
                  },
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: MaterialStateProperty.all(
                      textColorFor(state.filter, TodosViewFilter.activeOnly),
                    ),
                  ),
                  child: const Text('Active'),
                ),
              ),
              Tooltip(
                // key: completedFilterKey,
                message: 'Only completed todos',
                child: TextButton(
                  // onPressed: () => ref
                  //     .read(todoListFilteredProvider.notifier)
                  //     .state = TodoListFilter.completed,
                  onPressed: () {
                    context.read<TodoListBloc>().add(
                        TodoListFilterChanged(TodosViewFilter.completedOnly));
                  },
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: MaterialStateProperty.all(
                      textColorFor(state.filter, TodosViewFilter.completedOnly),
                    ),
                  ),
                  child: const Text('Completed'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
