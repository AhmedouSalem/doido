import 'package:doido/controller/addtaskcontroller.dart';
import 'package:get/get.dart';

class AddTaskBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AddTaskController());
  }
}
