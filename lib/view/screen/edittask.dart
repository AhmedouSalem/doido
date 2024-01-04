import '../widget/customtopform.dart';
import 'package:doido/controller/edittaskcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditTask extends StatelessWidget {
  const EditTask({super.key});

  @override
  Widget build(BuildContext context) {
    EditTaskController editTaskController = Get.find();
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 139, 157, 255),
        body: Form(
          key: editTaskController.formstate,
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
                            "Edit Task".tr,
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
                    fieldController: editTaskController.title,
                    iconPrefix: const Icon(Icons.title),
                    validatorInput: (p0) {
                      return editTaskController.valid(p0!, 3, 25);
                    },
                  ),
                  GetBuilder<EditTaskController>(
                    builder: (controller) => CustomTopForm(
                      colorUnderline: Colors.white,
                      colorPrefixIcon: Colors.white,
                      styleLabel: const TextStyle(color: Colors.white),
                      textLabel: 'Date'.tr,
                      testReadOnly: true,
                      fieldController: editTaskController.dateText,
                      iconPrefix: const Icon(Icons.calendar_today_outlined),
                      validatorInput: (p0) {
                        return editTaskController.valid(p0!, 6, 15);
                      },
                      onTapField: () => editTaskController.selectDate(
                        context,
                        editTaskController.dateText,
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
                          child: GetBuilder<EditTaskController>(
                            builder: (controller) => CustomTopForm(
                              colorUnderline: Colors.indigoAccent,
                              colorPrefixIcon: Colors.indigoAccent,
                              styleLabel:
                                  const TextStyle(color: Colors.indigoAccent),
                              textLabel: 'Start'.tr,
                              testReadOnly: true,
                              fieldController:
                                  editTaskController.timeInputStart,
                              iconPrefix: const Icon(Icons.timer),
                              validatorInput: (p0) {
                                return editTaskController.valid(p0!, 4, 15);
                              },
                              onTapField: () => editTaskController.selectTime(
                                  context, editTaskController.timeInputStart),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GetBuilder<EditTaskController>(
                            builder: (controller) => CustomTopForm(
                              colorUnderline: Colors.indigoAccent,
                              colorPrefixIcon: Colors.indigoAccent,
                              styleLabel:
                                  const TextStyle(color: Colors.indigoAccent),
                              textLabel: 'End'.tr,
                              testReadOnly: true,
                              fieldController: editTaskController.timeInputEnd,
                              iconPrefix: const Icon(Icons.timer),
                              validatorInput: (p0) {
                                return editTaskController.valid(p0!, 4, 15);
                              },
                              onTapField: () => editTaskController.selectTime(
                                  context, editTaskController.timeInputEnd),
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
                      fieldController: editTaskController.description,
                      iconPrefix: const Icon(Icons.description),
                      validatorInput: (p0) {
                        return editTaskController.valid(p0!, 3, 30);
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
                        await editTaskController.sendData(
                          editTaskController.formstate,
                          editTaskController.title.text,
                          editTaskController.timeInputStart.text,
                          editTaskController.timeInputEnd.text,
                          editTaskController.description.text,
                          editTaskController.dateText.text,
                        );
                      },
                      child: Text("Edit Task".tr),
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
