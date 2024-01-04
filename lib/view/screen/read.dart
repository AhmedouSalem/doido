import 'package:doido/view/widget/customslider.dart';

import '../widget/headertask.dart';
import '../../controller/tasklistcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Read extends GetView<TaskListController> {
  const Read({super.key, this.indexWaited});
  final int? indexWaited;

  @override
  Widget build(BuildContext context) {
    controller.indexWaited = indexWaited;
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: const Color.fromARGB(255, 139, 157, 255),
      drawer: const Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                child: Text("AB"),
              ),
              accountName: Text("Ahmedou Salem"),
              accountEmail: Text("ahmedou8salem@gmail.com"),
            ),
          ],
        ),
      ),
      body: const SafeArea(
        maintainBottomViewPadding: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: HeaderTask(),
            ),
            Expanded(
              flex: 2,
              child: CustomSlider(),
            ),
          ],
        ),
      ),
    );
  }
}
