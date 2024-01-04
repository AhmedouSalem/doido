import 'package:doido/controller/edittaskcontroller.dart';
import 'package:get/get.dart';

class EditTaskBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(EditTaskController());
  }
}
