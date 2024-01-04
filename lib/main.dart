import 'core/bindings/addtaskbinding.dart';
import 'core/bindings/edittaskbinding.dart';
import 'core/bindings/tasklistbinding.dart';
import './controller/locale.dart';
import 'view/screen/addtask.dart';
import 'view/screen/edittask.dart';
import 'view/screen/read.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(
          labelSmall: TextStyle(),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      translations: MyLocaleController(),
      locale: Get.deviceLocale,
      initialRoute: "/read",
      getPages: [
        GetPage(
          name: "/read",
          page: () => const Read(),
          binding: TaskListBindings(),
        ),
        GetPage(
          name: "/addTask",
          page: () => const AddTask(),
          binding: AddTaskBinding(),
        ),
        GetPage(
          name: "/editTask",
          page: () => const EditTask(),
          binding: EditTaskBinding(),
        )
      ],
    );
  }
}
