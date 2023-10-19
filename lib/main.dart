import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_bloc/app.dart';
import 'package:flutter_todos_bloc/core/bloc_observer/app_bloc_observer.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:todos_repository/todos_repository.dart';

Future<void> main() async {
  Bloc.observer = const AppBlocObserver();

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final todosApi = LocalStorageTodosApi(
      plugin: await SharedPreferences.getInstance(),
    );
    final todosRepository = TodosRepository(todosApi: todosApi);

    runApp(App(todosRepository: todosRepository));
    // Modular Main Setting
    // runApp(ModularApp(module: AppRoutesModular(), child: const MyApp()));
  }, (error, stackTrace) => log(error.toString(), stackTrace: stackTrace));
}
