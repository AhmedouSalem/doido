import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/di.dart';
import 'features/tasks/presentation/bloc/tasks_list_bloc.dart';
import 'features/tasks/presentation/pages/tasks_list_page.dart';

void main() {
  runApp(const TodoManagerApp());
}

class TodoManagerApp extends StatelessWidget {
  const TodoManagerApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.indigo);

    return Semantics(
      label: 'todo_manager_app',
      child: MaterialApp(
        key: const Key('todo_manager_app'),
        navigatorKey: navigatorKey,
        title: 'TodoManager',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,
          appBarTheme: AppBarTheme(
            centerTitle: false,
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        home: KeyedSubtree(
          key: const Key('home_root'),
          child: BlocProvider(
            create: (_) => TasksListBloc(
              getTasks: DI.getTasks,
              deleteTask: DI.deleteTask,
              completeTask: DI.completeTask,
            ),
            child: const TasksListPage(),
          ),
        ),
      ),
    );
  }
}
