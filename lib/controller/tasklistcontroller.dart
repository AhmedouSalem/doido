import '../core/bindings/tasklistbinding.dart';
import '../core/constant/variableconst.dart';
import '../core/functions/functions_used.dart';
import './locale.dart';
import '../view/screen/read.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskListController extends GetxController
    with GetTickerProviderStateMixin {
  late DateTime dateNow;

  DateFormat formatter = DateFormat("yyyy-MM-dd");

  MyLocaleController myLocaleController = MyLocaleController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late int displayedDate;
  late int numberOfDays;
  int? dataLength;
  late TabController tabBarController;
  int? indexWaited;
  List<Map<String, Object?>>? snapshotData;

  Future<List<Map<String, Object?>>?> fetchData(
      String dayMonth, DateTime date) async {
    DateTime convertDate = DateTime(date.year, date.month, int.parse(dayMonth));
    final String formatted = formatter.format(convertDate);
    List<Map<String, Object?>> response = await db.readData(
        "SELECT * FROM Tache WHERE DateEcheance = '$formatted' ORDER BY ID DESC");
    dataLength = response.length;
    update();
    return response;
  }

  Future<int> deleteData(int idTache) async {
    int response = await db.deleteData("DELETE FROM Tache WHERE ID = $idTache");
    return response;
  }

  getData(numDay) async {
    snapshotData = numDay.toString().length < 2
        ? await fetchData("0$numDay", dateNow)
        : await fetchData("$numDay", dateNow);
    update();
  }

  Future decrementMonth() async {
    dateNow = dateNow.subtract(const Duration(days: 30));
    displayedDate = dateNow.day;
    await fetchData(displayedDate.toString(), dateNow);
    print(dateNow);
    numberOfDays = DateTime(dateNow.year, dateNow.month + 1, 0).day;
    tabBarController = TabController(
        length: numberOfDays,
        initialIndex: indexWaited != null ? indexWaited! - 1 : dateNow.day - 1,
        vsync: this);
    update();
  }

  Future incrementMonth() async {
    dateNow = dateNow.add(const Duration(days: 30));
    displayedDate = dateNow.day;
    await fetchData(displayedDate.toString(), dateNow);
    numberOfDays = DateTime(dateNow.year, dateNow.month + 1, 0).day;
    tabBarController = TabController(
        length: numberOfDays,
        initialIndex: indexWaited != null ? indexWaited! - 1 : dateNow.day - 1,
        vsync: this);
    update();
  }

  completedTache(int id_statut, item) async {
    int response = await db
        .updateData("UPDATE Tache SET Statut_ID = $id_statut WHERE ID = $item");
    if (response != 0) {
      List<Map<String, Object?>> selectRows =
          await db.readData("SELECT DateEcheance FROM Tache WHERE ID = $item");
      int WaitedIndex = extractMonth(selectRows[0]["DateEcheance"].toString());
      print(WaitedIndex);
      await Get.offAll(
        binding: TaskListBindings(),
        () => Read(
          indexWaited: WaitedIndex,
        ),
      );
    }
    print(response);
    return response;
  }

  int getCurrentTabIndex(BuildContext context) {
    return tabBarController.index;
  }

  @override
  void onInit() {
    dateNow = DateTime.now();
    numberOfDays = DateTime(dateNow.year, dateNow.month + 1, 0).day;
    tabBarController = TabController(
        length: numberOfDays,
        initialIndex: indexWaited != null ? indexWaited! - 1 : dateNow.day - 1,
        vsync: this);
    super.onInit();
  }
}
