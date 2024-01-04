// ignore_for_file: avoid_print

import '../core/bindings/tasklistbinding.dart';
import '../core/functions/functions_used.dart';
import '../view/screen/read.dart';
import '../model/database/doidodb.dart';
import '../model/modeltaskmanager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditTaskController extends GetxController {
  TextEditingController timeInputStart = TextEditingController();
  TextEditingController timeInputEnd = TextEditingController();

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  TextEditingController dateText = TextEditingController();
  TextEditingController nomStatut = TextEditingController();

  Map? taskData;
  late ModelTaskManager modelTaskManager;

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  DoidoDb db = DoidoDb();
  sendData(formStateData, titleTache, timeStart, timeEnd, descriptionTache,
      dateEcheance) async {
    if (formStateData.currentState!.validate()) {
      int response = await db.insertData("""
      UPDATE Tache
      SET 
        Title = '$titleTache',
        time_start = '$timeStart',
        time_end = '$timeEnd',
        Description = '$descriptionTache',
        DateEcheance = '$dateEcheance'
      WHERE
        ID = ${modelTaskManager.iD}
       """);
      if (response != 0) {
        List<Map<String, Object?>> selectRows = await db
            .readData("SELECT DateEcheance FROM Tache WHERE ID = $response");
        int WaitedIndex =
            extractMonth(selectRows[0]["DateEcheance"].toString());
        print(WaitedIndex);
        await Get.offAll(
          binding: TaskListBindings(),
          () => Read(
            indexWaited: WaitedIndex,
          ),
        );
      }
    }
  }

  valid(String val, int min, int max) {
    if (val.isEmpty) {
      return "This field can't be void";
    } else if (val.length < min) {
      return "This field can't be less then $min";
    } else if (val.length > max) {
      return "This field can't be gritter than $max";
    }
  }

  selectDate(context, TextEditingController dateInput) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      print(pickedDate);
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      print(formattedDate);
      dateInput.text = formattedDate;
    } else {
      print("Date is not selected");
    }
  }

  selectTime(context, TextEditingController controllerForm) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (pickedTime != null) {
      print(pickedTime.format(context)); // Affiche l'heure sélectionnée
      String formattedTime = pickedTime.format(context);
      print(formattedTime); // Affiche l'heure sélectionnée au format hh:mm a
      controllerForm.text = formattedTime;
    } else {
      print("Time is not selected");
    }
  }

  @override
  void onInit() {
    Map<String, dynamic> taskData = Get.arguments;
    modelTaskManager = ModelTaskManager.fromJson(taskData);
    title.text = modelTaskManager.title!;
    timeInputStart.text = modelTaskManager.timeStart!;
    timeInputEnd.text = modelTaskManager.timeEnd!;
    description.text = modelTaskManager.dateEcheance!;
    dateText.text = modelTaskManager.dateEcheance!;
    nomStatut.text = modelTaskManager.statutID!.toString();
    super.onInit();
  }
}
