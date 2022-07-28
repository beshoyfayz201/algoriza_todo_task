import 'package:algoriza_todo/cubit/search_cubit/search_cubit.dart';
import 'package:algoriza_todo/cubit/search_cubit/search_cubit_state.dart';
import 'package:algoriza_todo/cubit/task_cubit/task_cubit.dart';
import 'package:algoriza_todo/cubit/task_cubit/task_state.dart';
import 'package:algoriza_todo/models/task.dart';
import 'package:algoriza_todo/shared/size_config.dart';
import 'package:algoriza_todo/views/screens/add_task.dart';
import 'package:algoriza_todo/views/screens/schedule.dart';
import 'package:algoriza_todo/views/widgets/task_widget.dart';
import 'package:algoriza_todo/views/widgets/appbar.dart';
import 'package:algoriza_todo/views/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class BoardScreen extends StatelessWidget {
  @override
  List<String> tabs = ["all", "completed", "uncompleted", "favourite"];
  late List<Task> tasks;
  TextEditingController textEditingController = TextEditingController();
  List<Widget> buildAppbarAction(bool search, context) {
    return [
      BlocBuilder<SearchCubit, SearchCubitState>(
        builder: (context, state) {
          if (!SearchCubit.get(context).Searching) {
            return IconButton(
                onPressed: () {
                  SearchCubit.get(context).changeSearchState();
                },
                icon: Icon(
                  Icons.search,
                  color: Colors.grey.shade800,
                ));
          } else {
            return Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.1,
                  ),
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      onChanged: (String? searchingCharcters) {
                        TaskCubit.get(context).refreshLists();
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        SearchCubit.get(context).changeSearchState();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ))
                ],
              ),
            );
          }
        },
      ),
      IconButton(
          onPressed: () {
            Navigator.pushNamed(context, ScheduleScreen.id);
          },
          icon: Icon(Icons.notifications, color: Colors.grey.shade800)),
    ];
  }

  List<Task> filterList(List<Task> tasks) {
    //if (textEditingController.text.isEmpty) return tasks;
    return tasks
        .where((element) => element.title
            .toLowerCase()
            .startsWith(textEditingController.text.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: buildAppbar(
            context: context,
            txt: "Board",
            actions: buildAppbarAction(true, context)),
        body: Column(
          children: [
            Divider(color: Colors.grey.shade300, thickness: 2),
            TabBar(
                labelColor: Colors.black87,
                isScrollable: true,
                indicatorColor: Colors.grey.shade800,
                indicatorWeight: 3,
                tabs: List.generate(
                  4,
                  (index) => Tab(
                    text: tabs[index],
                  ),
                )),
            Divider(color: Colors.grey.shade300, thickness: 2),
            Expanded(
              child: BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  if (state is LoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    tasks = TaskCubit.get(context).tasks;
                    List<Task> searchedTasks = filterList(tasks);
                    return (searchedTasks.isEmpty)
                        ? const Center(
                            child: Text("there is no tasks"),
                          )
                        : TabBarView(children: [
                            ListView.builder(
                                itemCount: searchedTasks.length,
                                itemBuilder: ((context, index) =>
                                    TaskWidget(task: searchedTasks[index]))),
                            ListView.builder(
                                itemCount: filterList(
                                        TaskCubit.get(context).completedTasks)
                                    .length,
                                itemBuilder: ((context, index) => TaskWidget(
                                    task: filterList(TaskCubit.get(context)
                                        .completedTasks)[index]))),
                            ListView.builder(
                                itemCount: filterList(
                                        TaskCubit.get(context).unCompletedTasks)
                                    .length,
                                itemBuilder: ((context, index) => TaskWidget(
                                    task: filterList(TaskCubit.get(context)
                                        .unCompletedTasks)[index]))),
                            ListView.builder(
                                itemCount: filterList(
                                        TaskCubit.get(context).favouriteTasks)
                                    .length,
                                itemBuilder: ((context, index) => TaskWidget(
                                    task: filterList(TaskCubit.get(context)
                                        .favouriteTasks)[index]))),
                          ]);
                  }
                },
              ),
            ),
            WideButton(
                onpressed: () {
                  Navigator.of(context).pushNamed(AddTask.id);
                },
                text: "Add a Task")
          ],
        ),
      ),
    );
  }
}

String? checkValid(String? s) {
  if (s!.isEmpty) {
    return "please fill this form";
  } else {
    return null;
  }
}
