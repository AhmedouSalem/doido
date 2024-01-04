import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/tasklistcontroller.dart';
import 'tasklist.dart';

class CustomSlider extends StatelessWidget {
  const CustomSlider({super.key});

  @override
  Widget build(BuildContext context) {
    TaskListController taskListController = Get.find();
    return GetBuilder<TaskListController>(
      builder: (controllrer) => TabBarView(
        controller: taskListController.tabBarController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          taskListController.numberOfDays,
          (index) {
            index++;
            return TaskList(
              numDay: index,
            );
          },
        ),
      ),
    );
  }
}
