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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: buildAppbar(context: context, txt: "Board", actions: [
          IconButton(
              onPressed: () {
                print("Search");
              },
              icon: Icon(
                Icons.search,
                color: Colors.grey.shade800,
              )),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, ScheduleScreen.id);
              },
              icon: Icon(Icons.notifications, color: Colors.grey.shade800))
        ]),
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
                    return (tasks.isEmpty)
                        ? const Center(
                            child: Text("you have no tasks yet"),
                          )
                        : TabBarView(children: [
                            ListView.builder(
                                itemCount: tasks.length,
                                itemBuilder: ((context, index) => TaskWidget(
                                    onpressed: () {}, task: tasks[index]))),
                            ListView.builder(
                                itemCount: TaskCubit.get(context)
                                    .completedTasks
                                    .length,
                                itemBuilder: ((context, index) => TaskWidget(
                                    onpressed: () {},
                                    task: TaskCubit.get(context)
                                        .completedTasks[index]))),
                            ListView.builder(
                                itemCount: TaskCubit.get(context)
                                    .unCompletedTasks
                                    .length,
                                itemBuilder: ((context, index) => TaskWidget(
                                    onpressed: () {},
                                    task: TaskCubit.get(context)
                                        .unCompletedTasks[index]))),
                            ListView.builder(
                                itemCount: TaskCubit.get(context)
                                    .favouriteTasks
                                    .length,
                                itemBuilder: ((context, index) => TaskWidget(
                                    onpressed: () {},
                                    task: TaskCubit.get(context)
                                        .favouriteTasks[index]))),
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
