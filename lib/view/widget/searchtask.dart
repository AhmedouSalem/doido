import 'package:doido/model/modeltaskmanager.dart';
import 'package:flutter/material.dart';

class SearchTask extends SearchDelegate {
  SearchTask({required this.taskList});
  final List taskList;
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.close)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text("text");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List filterTask = taskList
        .where((element) => element["Title"].startsWith(query))
        .toList();
    return ListView.separated(
      itemCount: query == "" ? taskList.length : filterTask.length,
      itemBuilder: (context, index) {
        ModelTaskManager model = query == ""
            ? ModelTaskManager.fromJson(taskList[index])
            : ModelTaskManager.fromJson(filterTask[index]);
        return ListTile(
          title: Text(
            "${model.title}",
          ),
          onTap: () {
            query = model.title!;
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 0.0);
      },
    );
  }
}
