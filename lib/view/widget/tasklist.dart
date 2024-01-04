import 'package:awesome_dialog/awesome_dialog.dart';
import '../../controller/tasklistcontroller.dart';
import '../../model/modeltaskmanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class TaskList extends StatelessWidget {
  TaskList({super.key, required this.numDay});
  final int numDay;

  final TaskListController taskListController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskListController>(
      builder: (taskListController) =>
          FutureBuilder<List<Map<String, Object?>>?>(
        future: numDay.toString().length < 2
            ? taskListController.fetchData(
                "0$numDay", taskListController.dateNow)
            : taskListController.fetchData(
                "$numDay", taskListController.dateNow),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, Object?>>?> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "noTask".tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "CrimsonText",
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return GetBuilder<TaskListController>(
              builder: (taskListController) => Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "${"noteStart".tr} ${taskListController.dataLength} ${"noteEnd".tr} ",
                        style: const TextStyle(
                          fontFamily: "CrimsonText",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0),
                      itemCount: taskListController.dataLength,
                      itemBuilder: (context, index) {
                        ModelTaskManager user =
                            ModelTaskManager.fromJson(snapshot.data![index]);
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: user.statutID == 2
                              ? Slidable(
                                  enabled: true,
                                  // Spécifiez une clé si le Slidable est révocable.
                                  key: const ValueKey(0),

                                  // Le volet d'action de démarrage est celui situé à gauche ou en haut.
                                  startActionPane: ActionPane(
                                    // Un mouvement est un widget utilisé pour contrôler la façon dont le volet s'anime.
                                    motion: const ScrollMotion(),

                                    // Un volet peut ignorer le Slidable.
                                    dismissible: DismissiblePane(
                                      onDismissed: () async {
                                        await taskListController.deleteData(
                                            int.parse("${user.iD}"));
                                        numDay.toString().length < 2
                                            ? await taskListController
                                                .fetchData("0$numDay",
                                                    taskListController.dateNow)
                                            : await taskListController
                                                .fetchData("$numDay",
                                                    taskListController.dateNow);
                                      },
                                    ),

                                    // Toutes les actions sont définies dans le paramètre children.
                                    children: [
                                      // Une SlidableAction peut avoir une icône et/ou une étiquette.
                                      SlidableAction(
                                        onPressed: (context) async {
                                          await taskListController.deleteData(
                                              int.parse("${user.iD}"));
                                          numDay.toString().length < 2
                                              ? await taskListController
                                                  .fetchData(
                                                      "0$numDay",
                                                      taskListController
                                                          .dateNow)
                                              : await taskListController
                                                  .fetchData(
                                                      "$numDay",
                                                      taskListController
                                                          .dateNow);
                                        },
                                        backgroundColor:
                                            const Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete'.tr,
                                      ),
                                    ],
                                  ),

                                  // Le volet d'action de fin est celui à droite ou en bas.
                                  endActionPane: user.statutID == 2
                                      ? ActionPane(
                                          motion: const ScrollMotion(),
                                          children: [
                                            SlidableAction(
                                              // Une action peut être plus grande que les autres.
                                              flex: 1,
                                              onPressed: (context) async {
                                                await Get.toNamed("/editTask",
                                                    arguments:
                                                        snapshot.data![index]);
                                              },
                                              backgroundColor:
                                                  const Color(0xFF0392CF),
                                              foregroundColor: Colors.white,
                                              icon: Icons.edit,
                                              label: 'Edit'.tr,
                                            ),
                                            SlidableAction(
                                              onPressed: (context) async {
                                                await taskListController
                                                    .completedTache(1, user.iD);
                                              },
                                              backgroundColor:
                                                  const Color(0xFF7BC043),
                                              foregroundColor: Colors.white,
                                              icon: Icons.done,
                                              label: 'Done'.tr,
                                            ),
                                          ],
                                        )
                                      : ActionPane(
                                          motion: const ScrollMotion(),
                                          children: [
                                            SlidableAction(
                                              // Une action peut être plus grande que les autres.
                                              flex: 1,
                                              onPressed: (context) async {
                                                print(snapshot.data![index]);
                                                await Get.toNamed("/editTask",
                                                    arguments:
                                                        snapshot.data![index]);
                                              },
                                              backgroundColor:
                                                  const Color(0xFF0392CF),
                                              foregroundColor: Colors.white,
                                              icon: Icons.edit,
                                              label: 'Edit'.tr,
                                            ),
                                          ],
                                        ),

                                  // L'enfant du Slidable est ce que l'utilisateur voit lorsque le
                                  // le composant n'est pas déplacé.
                                  child: Card(
                                    color: index.isEven
                                        ? Colors.white
                                        : Colors.indigoAccent.shade700,
                                    shape: Border(
                                      left: BorderSide(
                                          color: index.isEven
                                              ? Colors.indigoAccent.shade700
                                              : Colors.white,
                                          width: 10.0),
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        child: Icon(
                                          Icons.note_alt,
                                          color: index.isEven
                                              ? Colors.indigoAccent.shade700
                                              : Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        "${user.title}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: index.isEven
                                                ? Colors.black
                                                : Colors.white),
                                      ),
                                      subtitle: user.statutID == 2
                                          ? Text(
                                              "${user.timeStart} ${"to".tr} ${user.timeEnd}",
                                              style: index.isEven
                                                  ? Theme.of(context)
                                                      .textTheme
                                                      .labelSmall
                                                  : const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11.0),
                                            )
                                          : Row(
                                              children: [
                                                Text(
                                                  "${user.timeStart} ${"to".tr} ${user.timeEnd}",
                                                  style: index.isEven
                                                      ? Theme.of(context)
                                                          .textTheme
                                                          .labelSmall
                                                      : const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11.0),
                                                ),
                                                Icon(
                                                  Icons.done,
                                                  color: Colors
                                                      .greenAccent.shade700,
                                                )
                                              ],
                                            ),
                                      trailing: IconButton(
                                        onPressed: () async {
                                          AwesomeDialog(
                                            context: context,
                                            animType: AnimType.rightSlide,
                                            dialogType: DialogType.info,
                                            title: user.title,
                                            body: Column(
                                              children: [
                                                Text(
                                                  "form : ${user.timeStart} to ${user.timeEnd}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelSmall,
                                                ),
                                                Text("${user.description}"),
                                              ],
                                            ),
                                          ).show();
                                        },
                                        icon: Icon(
                                          Icons.arrow_circle_right,
                                          color: index.isEven
                                              ? Colors.indigoAccent.shade700
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Card(
                                  color: index.isEven
                                      ? Colors.white
                                      : Colors.indigoAccent.shade700,
                                  shape: Border(
                                    left: BorderSide(
                                        color: index.isEven
                                            ? Colors.indigoAccent.shade700
                                            : Colors.white,
                                        width: 10.0),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      child: Icon(
                                        Icons.note_alt,
                                        color: index.isEven
                                            ? Colors.indigoAccent.shade700
                                            : Colors.white,
                                      ),
                                    ),
                                    title: Text(
                                      "${user.title}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: index.isEven
                                              ? Colors.black
                                              : Colors.white),
                                    ),
                                    subtitle: user.statutID == 2
                                        ? Text(
                                            "${user.timeStart} ${"to".tr} ${user.timeEnd}",
                                            style: index.isEven
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                : const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11.0),
                                          )
                                        : Row(
                                            children: [
                                              Text(
                                                "${user.timeStart} ${"to".tr} ${user.timeEnd}",
                                                style: index.isEven
                                                    ? Theme.of(context)
                                                        .textTheme
                                                        .labelSmall
                                                    : const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11.0),
                                              ),
                                              Icon(
                                                Icons.done,
                                                color:
                                                    Colors.greenAccent.shade700,
                                              )
                                            ],
                                          ),
                                    trailing: IconButton(
                                      onPressed: () async {
                                        AwesomeDialog(
                                          context: context,
                                          animType: AnimType.rightSlide,
                                          dialogType: DialogType.info,
                                          title: user.title,
                                          body: Column(
                                            children: [
                                              Text(
                                                "form : ${user.timeStart} to ${user.timeEnd}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall,
                                              ),
                                              Text("${user.description}"),
                                            ],
                                          ),
                                        ).show();
                                      },
                                      icon: Icon(
                                        Icons.arrow_circle_right,
                                        color: index.isEven
                                            ? Colors.indigoAccent.shade700
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
