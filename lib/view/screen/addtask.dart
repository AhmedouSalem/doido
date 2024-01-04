import '../widget/customtopform.dart';
import '../../controller/addtaskcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTask extends StatelessWidget {
  const AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    AddTaskController addTaskController = Get.find();
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 139, 157, 255),
        body: Form(
          key: addTaskController.formstate,
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: IconButton(
                          isSelected: true,
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30.0,
                            weight: 20.0,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 60.0),
                          child: Text(
                            "Add Task".tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: "CrimsonText",
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomTopForm(
                    colorUnderline: Colors.white,
                    colorPrefixIcon: Colors.white,
                    styleLabel: const TextStyle(color: Colors.white),
                    textLabel: 'Title'.tr,
                    testReadOnly: false,
                    fieldController: addTaskController.title,
                    iconPrefix: const Icon(Icons.title),
                    validatorInput: (p0) {
                      return addTaskController.valid(p0!, 3, 25);
                    },
                  ),
                  GetBuilder<AddTaskController>(
                    builder: (controller) => CustomTopForm(
                      colorUnderline: Colors.white,
                      colorPrefixIcon: Colors.white,
                      styleLabel: const TextStyle(color: Colors.white),
                      textLabel: 'Date'.tr,
                      testReadOnly: true,
                      fieldController: addTaskController.dateText,
                      iconPrefix: const Icon(Icons.calendar_today_outlined),
                      validatorInput: (p0) {
                        return addTaskController.valid(p0!, 6, 15);
                      },
                      onTapField: () => addTaskController.selectDate(
                        context,
                        addTaskController.dateText,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100.0),
                    topRight: Radius.circular(100.0),
                    bottomLeft: Radius.elliptical(1000, 200),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GetBuilder<AddTaskController>(
                            builder: (controller) => CustomTopForm(
                              colorUnderline: Colors.indigoAccent,
                              colorPrefixIcon: Colors.indigoAccent,
                              styleLabel:
                                  const TextStyle(color: Colors.indigoAccent),
                              textLabel: 'Start'.tr,
                              testReadOnly: true,
                              fieldController: addTaskController.timeInputStart,
                              iconPrefix: const Icon(Icons.timer),
                              validatorInput: (p0) {
                                return addTaskController.valid(p0!, 4, 15);
                              },
                              onTapField: () => addTaskController.selectTime(
                                  context, addTaskController.timeInputStart),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GetBuilder<AddTaskController>(
                            builder: (controller) => CustomTopForm(
                              colorUnderline: Colors.indigoAccent,
                              colorPrefixIcon: Colors.indigoAccent,
                              styleLabel:
                                  const TextStyle(color: Colors.indigoAccent),
                              textLabel: 'End'.tr,
                              testReadOnly: true,
                              fieldController: addTaskController.timeInputEnd,
                              iconPrefix: const Icon(Icons.timer),
                              validatorInput: (p0) {
                                return addTaskController.valid(p0!, 4, 15);
                              },
                              onTapField: () => addTaskController.selectTime(
                                  context, addTaskController.timeInputEnd),
                            ),
                          ),
                        ),
                      ],
                    ),
                    CustomTopForm(
                      colorUnderline: Colors.indigoAccent,
                      colorPrefixIcon: Colors.indigoAccent,
                      styleLabel: const TextStyle(color: Colors.indigoAccent),
                      textLabel: 'Description'.tr,
                      testReadOnly: false,
                      fieldController: addTaskController.description,
                      iconPrefix: const Icon(Icons.description),
                      validatorInput: (p0) {
                        return addTaskController.valid(p0!, 3, 30);
                      },
                    ),
                    MaterialButton(
                      padding: const EdgeInsets.all(20.0),
                      color: Colors.indigoAccent.shade700,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      onPressed: () async {
                        await addTaskController.sendData(
                          addTaskController.formstate,
                          addTaskController.title.text,
                          addTaskController.timeInputStart.text,
                          addTaskController.timeInputEnd.text,
                          addTaskController.description.text,
                          addTaskController.dateText.text,
                        );
                      },
                      child: Text("Add Task".tr),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
