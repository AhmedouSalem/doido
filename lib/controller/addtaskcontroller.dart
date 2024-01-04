// ignore_for_file: avoid_print

import 'package:doido/core/bindings/tasklistbinding.dart';
import '../core/functions/functions_used.dart';
import '../view/screen/read.dart';
import '../model/database/doidodb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskController extends GetxController {
  TextEditingController timeInputStart = TextEditingController();
  TextEditingController timeInputEnd = TextEditingController();

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  TextEditingController dateText = TextEditingController();
  TextEditingController nomStatut = TextEditingController();

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  DoidoDb db = DoidoDb();
  sendData(formStateData, titleTache, timeStart, timeEnd, descriptionTache,
      dateEcheance) async {
    if (formStateData.currentState!.validate()) {
      int response = await db.insertData("""
      INSERT INTO Tache
      (
        Title,
        time_start,
        time_end,
        Description,
        DateEcheance,
        Statut_ID
      )
      VALUES
      (
        '$titleTache',
        '$timeStart',
        '$timeEnd',
        '$descriptionTache',
        '$dateEcheance',
        2
      )
       """);
      if (response != 0) {
        List<Map<String, Object?>> selectRows = await db
            .readData("SELECT DateEcheance FROM Tache WHERE ID = $response");
        int waitedIndex =
            extractMonth(selectRows[0]["DateEcheance"].toString());
        await Get.offAll(
          binding: TaskListBindings(),
          () => Read(
            indexWaited: waitedIndex,
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
}
