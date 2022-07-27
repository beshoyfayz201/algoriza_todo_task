import 'package:algoriza_todo/cubit/input_cubit/cubit/input_cupit_cubit.dart';
import 'package:algoriza_todo/cubit/task_cubit/task_cubit.dart';
import 'package:algoriza_todo/models/task.dart';
import 'package:algoriza_todo/services/notification_services.dart';
import 'package:algoriza_todo/shared/colors.dart';
import 'package:algoriza_todo/views/widgets/appbar.dart';
import 'package:algoriza_todo/views/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../widgets/input_field.dart';

// ignore: must_be_immutable
class AddTask extends StatelessWidget {
  static const id = "AddTask";

  TextEditingController title = TextEditingController();

  List<int?> reminders = [5, 10, 15];
//repeats
  List<String> reapatsVal = ["none", "daily", "weekly", "mounthly"];
  List<String> remindVal = [
    "day before",
    "hour before",
    "30 min before",
    "10 min before"
  ];

  //colors
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: buildAppbar(context: ctx, txt: "Add Task"),
      body: SingleChildScrollView(
        child: BlocConsumer<InputCubit, InputCupitState>(
          listener: (context, state) {
            print(state);
          },
          builder: (context, state) {
            return Form(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputField(
                      title: "Title",
                      hint: "Design team meeting",
                      controller: title,
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    InputField(
                      title: "Deadline",
                      hint: InputCubit.get(context).task.date.toString(),
                      widget: IconButton(
                          onPressed: () {
                            getDate(context);
                          },
                          icon:
                              const Icon(Icons.date_range, color: Colors.grey)),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InputField(
                            title: "start",
                            hint: InputCubit.get(context).task.startTime,
                            widget: IconButton(
                                onPressed: () {
                                  getTime(begin: true, context: context);
                                },
                                icon: const Icon(
                                  Icons.access_alarm,
                                  color: Colors.grey,
                                )),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: InputField(
                            title: "End",
                            hint: InputCubit.get(ctx).task.endTime,
                            widget: IconButton(
                                onPressed: () {
                                  getTime(begin: false, context: context);
                                },
                                icon: const Icon(
                                  Icons.alarm,
                                  color: Colors.grey,
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InputField(
                      title: " Remind",
                      hint: remindVal[InputCubit.get(ctx).task.remind],
                      widget: DropdownButton<int>(
                        selectedItemBuilder: (context) =>
                            List.generate(4, ((index) => Container())),
                        underline: Container(),
                        icon: const Icon(Icons.keyboard_arrow_down_sharp),
                        value: InputCubit.get(ctx).task.repeat,
                        hint: const Text(""),
                        items: reapatsVal
                            .map((e) => DropdownMenuItem(
                                  child: Text(
                                    e,
                                  ),
                                  value: reapatsVal.indexOf(e),
                                ))
                            .toList(),
                        onChanged: (int? d) {
                          InputCubit.get(ctx).setRepeat(d!);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    //repeats
                    InputField(
                      title: " Repeate",
                      hint: reapatsVal[InputCubit.get(ctx).task.repeat],
                      widget: DropdownButton<int>(
                        selectedItemBuilder: (context) =>
                            List.generate(4, ((index) => Container())),
                        underline: Container(),
                        icon: const Icon(Icons.keyboard_arrow_down_sharp),
                        value: InputCubit.get(ctx).task.repeat,
                        hint: const Text(""),
                        items: reapatsVal
                            .map((e) => DropdownMenuItem(
                                  child: Text(
                                    e,
                                  ),
                                  value: reapatsVal.indexOf(e),
                                ))
                            .toList(),
                        onChanged: (int? d) {
                          InputCubit.get(ctx).setRepeat(d!);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("Color"),
                      const Spacer(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: appColors
                              .map((color) => GestureDetector(
                                    onTap: () {
                                      InputCubit.get(ctx)
                                          .setColor(appColors.indexOf(color));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(2),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: BoxDecoration(
                                          border: (InputCubit.get(ctx)
                                                      .task
                                                      .color ==
                                                  appColors.indexOf(color))
                                              ? Border.all(
                                                  width: 2.5,
                                                  color: Colors.green.shade200)
                                              : null,
                                          shape: BoxShape.circle,
                                          color: color),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ]),
                    WideButton(
                        onpressed: () async {
                          Task t = InputCubit.get(ctx).task;
                          InputCubit.get(ctx).task.title = title.text;
                          if (title.text.isNotEmpty) {
                            await TaskCubit.get(ctx).insertTask(t);
                            await TaskCubit.get(ctx).getAll();

                            //schedule task
                            int hour = int.parse(t.endTime.split(":")[0]);
                            int min = int.parse(t.endTime.split(":")[1]);
                            print("-----------");

                            print(min);
                            print("-----------");

                            NotifyHelper().schedulNotification(
                                hour,
                                min,
                                t,
                                t.remind, //---------------change it
                                DateFormat.yMd().parse(t.date));

                            Navigator.pushReplacementNamed(context, "/");
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor:
                                    Colors.blue.shade900.withOpacity(0.5),
                                content: const Text(
                                  "ops !! you forget to fill all forms",
                                  style: TextStyle(
                                      fontFamily: "k",
                                      fontSize: 30,
                                      color: Colors.white),
                                )));
                          }
                        },
                        text: "create a Task")
                    //       ElevatedButton(
                    //           style: ElevatedButton.styleFrom(
                    //               minimumSize: Size(SizeConfig.screenWidth * 0.15,
                    //                   SizeConfig.screenHeight * 0.08)),
                    //           onPressed: () async {
                    //             if (title.text.isNotEmpty &&
                    //                 task.text.isNotEmpty) {
                    //               String s = selectedrepeats.toString();
                    //               Task mytask = Task(
                    //                   repeat: s,
                    //                   title: title.text,
                    //                   color: selectedColor,
                    //                   date: pickeddate,
                    //                   endTime: end,
                    //                   startTime: start,
                    //                   isCompleted: 0,
                    //                   note: task.text,
                    //                   remind: int.parse(selectedReminder));
                    //               await taskController.insertTask(task: mytask);
                    //               print(end);
                    //               int hour = int.parse(end.split(":")[0]);
                    //               int min = int.parse(end.split(":")[1]);
                    //               print("-----------");

                    //               print(min);
                    //               print("-----------");

                    //               NotifyHelper().schedulNotification(
                    //                   hour,
                    //                   min,
                    //                   taskController.myTasks.last,
                    //                   int.parse(selectedReminder),
                    //                   DateFormat.yMd().parse(pickeddate));
                    //               Navigator.of(context).pop();
                    //             } else {
                    //               ScaffoldMessenger.of(context).showSnackBar(
                    //                   SnackBar(
                    //                       backgroundColor: Colors.blue.shade900
                    //                           .withOpacity(0.5),
                    //                       content: Text(
                    //                         "ops !! you forget to fill all forms honey ",
                    //                         style: TextStyle(
                    //                             fontFamily: "def",
                    //                             fontSize: 30,
                    //                             color: Colors.white),
                    //                       )));
                    //             }
                    //           },
                    //           child: Text("Add TODO"))
                    //     ],
                    //   )
                    //
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  getDate(BuildContext context) async {
    DateTime? d = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 364)));

    if (d != null) InputCubit.get(context).setDate(DateFormat.yMd().format(d));
  }

  getTime({required bool begin, required BuildContext context}) async {
    TimeOfDay? d = await showTimePicker(
      context: context,
      initialTime: begin
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(const Duration(minutes: 15))),
    );

    if (d != null) {
      if (begin) {
        InputCubit.get(context).setStartTime(d.format(context));
      } else {
        InputCubit.get(context).setEndTime(d.format(context));
      }
    } else {
      print("error");
    }
  }
}
