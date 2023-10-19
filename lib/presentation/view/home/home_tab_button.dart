import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_bloc/domain/cubit/home/home_cubit.dart';
import 'package:flutter_todos_bloc/domain/state/home/home_state.dart';

class HomeTabButton extends StatelessWidget {
  const HomeTabButton({
    required this.groupValue,
    required this.value,
    required this.icon,
  });

  final HomeTab groupValue;
  final HomeTab value;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<HomeCubit>().setTab(value),
      iconSize: 32,
      color:
      groupValue != value ? null : Theme.of(context).colorScheme.secondary,
      icon: icon,
    );
  }
}