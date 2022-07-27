import 'package:algoriza_todo/cubit/task_cubit/task_cubit.dart';
import 'package:algoriza_todo/cubit/task_cubit/task_state.dart';
import 'package:algoriza_todo/models/task.dart';
import 'package:algoriza_todo/shared/size_config.dart';
import 'package:algoriza_todo/views/screens/add_task.dart';
import 'package:algoriza_todo/views/widgets/appbar.dart';
import 'package:algoriza_todo/views/widgets/task_tile.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ScheduleScreen extends StatelessWidget {
  static const id = "ScheduleScreen";
  List<Task>? mytasks;
  DateTime selectedDate = DateTime.now();
  refresh(BuildContext context) async {
    mytasks = await TaskCubit.get(context).getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(txt: "Schedule", context: context),
      body: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is LoadingState)
            return Center(
              child: const CircularProgressIndicator(),
            );
          else {
            mytasks = TaskCubit.get(context).tasks;
            return Column(
              children: [
                const Divider(thickness: 2),
                //Timeline
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DatePicker(
                    DateTime.now(),
                    deactivatedColor: Colors.black,
                    selectionColor: Colors.teal.shade400,
                    height: (SizeConfig.orientation == Orientation.portrait)
                        ? SizeConfig.screenHeight * 0.15
                        : SizeConfig.screenWidth * 0.12,
                    width: SizeConfig.screenWidth * 0.15,
                    initialSelectedDate: DateTime.now(),
                    selectedTextColor: Colors.white,
                    dateTextStyle: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 20),
                    dayTextStyle: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 15),
                    monthTextStyle: const TextStyle(color: Colors.white),
                    onDateChange: (d) {
                      refresh(context);
                      selectedDate = d;
                      print(selectedDate);
                    },
                  ),
                ),
                const Divider(thickness: 2),
                //tasks body
                (mytasks!.isNotEmpty)
                    ? Container(
                        child: Expanded(
                          child: Container(
                            child: ListView.builder(
                              scrollDirection:
                                  SizeConfig.orientation == Orientation.portrait
                                      ? Axis.vertical
                                      : Axis.horizontal,
                              itemCount: mytasks!.length,
                              itemBuilder: (context, i) {
                                print(mytasks![i].repeat);

                                if ((DateFormat.yMd().format(selectedDate) ==
                                        mytasks![i].date) ||
                                    mytasks![i].repeat == 1 ||
                                    (mytasks![i].repeat == 2 &&
                                        selectedDate.weekday ==
                                            DateFormat.yMd()
                                                .parse(mytasks![i].date)
                                                .weekday) ||
                                    (mytasks![i].repeat == 3 &&
                                        selectedDate.day ==
                                            DateFormat.yMd()
                                                .parse(mytasks![i].date)
                                                .day)) {
                                  return AnimationConfiguration.staggeredList(
                                    position: i,
                                    duration: const Duration(seconds: 0),
                                    child: SlideAnimation(
                                      horizontalOffset: 300,
                                      duration:
                                          const Duration(milliseconds: 1000),
                                      child: FlipAnimation(
                                        duration:
                                            const Duration(milliseconds: 1000),
                                        child: GestureDetector(
                                          onTap: () {
                                            showBottomSheet(
                                                context, mytasks![i]);
                                          },
                                          child: TaskTile(task: mytasks![i]),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                        ),
                      )
                    //embty staty
                    : Column(
                        children: [
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.05,
                          ),
                          Image.asset(
                            "assets/images/embty.png",
                            fit: BoxFit.scaleDown,
                            height: SizeConfig.screenHeight * 0.3,
                          ),
                          Text(
                            "You got no tasks",
                            style: TextStyle(fontFamily: "K", fontSize: 30),
                          ),
                        ],
                      ),
              ],
            );
          }
        },
      ),
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => SingleChildScrollView(
              child: Column(
                children: [
                  Divider(
                    color: Colors.grey,
                    thickness: 4,
                    indent: SizeConfig.screenWidth * 0.3,
                    endIndent: SizeConfig.screenWidth * 0.3,
                  ),
                  if (task.isCompleted == 0)
                    buildSheetBotton(
                        onTap: () async {
                          await TaskCubit.get(context).changecompleteState(
                              id: task.id!,
                              value: (task.isCompleted == 0) ? 1 : 0);
                          // await NotifyHelper()
                          //     .flutterLocalNotificationsPlugin
                          //     .cancel(task.id!);

                          Navigator.of(context).pop();
                        },
                        color: Colors.green,
                        txt: "complete"),
                  buildSheetBotton(
                      onTap: () async {
                        print("delete");
                        await TaskCubit.get(context).deleteTask(task);
                        // await NotifyHelper()
                        //     .flutterLocalNotificationsPlugin
                        //     .cancel(task.id!);

                        Navigator.of(context).pop();
                      },
                      color: Colors.red.shade600,
                      txt: "delete"),
                  buildSheetBotton(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      color: Colors.teal.shade300,
                      txt: "cancel")
                ],
              ),
            ));
  }

  buildSheetBotton(
      {required Function onTap, required Color color, required String txt}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 2),
        width: SizeConfig.screenWidth * 0.8,
        height: SizeConfig.orientation == Orientation.portrait
            ? SizeConfig.screenHeight * 0.05
            : SizeConfig.screenHeight * 0.1,
        child: Center(
          child: Text(
            txt,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
