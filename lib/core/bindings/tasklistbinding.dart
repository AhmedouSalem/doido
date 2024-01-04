import 'package:doido/controller/tasklistcontroller.dart';
import 'package:get/get.dart';

class TaskListBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(TaskListController());
  }
}
