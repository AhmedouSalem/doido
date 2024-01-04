import 'searchtask.dart';
import '../../controller/tasklistcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/functions/functions_used.dart';

class HeaderTask extends StatelessWidget {
  const HeaderTask({super.key});

  @override
  Widget build(BuildContext context) {
    TaskListController taskListController = Get.find();
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50.0),
          bottomRight: Radius.circular(50.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  taskListController.scaffoldKey.currentState!.openDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  size: 30.0,
                ),
              ),
              Text(
                "titre".tr,
                style: const TextStyle(
                  fontFamily: "CrimsonText",
                  fontSize: 25.0,
                ),
              ),
              IconButton(
                onPressed: () async {
                  List<Map<String, Object?>> task = await fetchAllData();
                  await showSearch(
                    context: context,
                    delegate: SearchTask(taskList: task),
                  );
                },
                icon: const Icon(
                  Icons.search,
                  size: 30.0,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await taskListController.decrementMonth();
                      },
                      icon: const Icon(Icons.chevron_left_outlined),
                    ),
                    GetBuilder<TaskListController>(
                        builder: (controller) => Text(
                              "${taskListController.myLocaleController.keys[Get.locale!.languageCode]!['months']!.split('_')[taskListController.dateNow.month - 1]}"
                              " ${taskListController.dateNow.year}",
                            )),
                    IconButton(
                      onPressed: () async {
                        taskListController.incrementMonth();
                      },
                      icon: const Icon(Icons.chevron_right_outlined),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                color: Colors.indigoAccent.shade700,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                onPressed: () async {
                  await Get.toNamed("/addTask");
                },
                child: Text("addTask".tr),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: GetBuilder<TaskListController>(
              builder: (controller) => TabBar(
                controller: taskListController.tabBarController,
                indicator: const BoxDecoration(),
                dividerColor: Colors.transparent,
                padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                isScrollable: true,
                tabs: List.generate(
                  taskListController.numberOfDays,
                  (index) {
                    DateTime date = DateTime(
                      taskListController.dateNow.year,
                      taskListController.dateNow.month,
                      index + 1,
                    );
                    String dayName = taskListController.myLocaleController
                        .keys[Get.locale!.languageCode]!['daysOfWeek']!
                        .split('_')[date.weekday - 1];
                    index++;
                    return Tab(
                      height: 80.0,
                      child: Card(
                        color: (taskListController.getCurrentTabIndex(context) +
                                    1) ==
                                index
                            ? Colors.indigoAccent.shade700
                            : Colors.white,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "$index",
                                style: TextStyle(
                                  color: (taskListController
                                                  .getCurrentTabIndex(context) +
                                              1) ==
                                          index
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                dayName,
                                style: TextStyle(
                                  color: (taskListController
                                                  .getCurrentTabIndex(context) +
                                              1) ==
                                          index
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
