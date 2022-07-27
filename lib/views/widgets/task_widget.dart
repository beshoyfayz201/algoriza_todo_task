import 'package:algoriza_todo/cubit/task_cubit/task_cubit.dart';
import 'package:algoriza_todo/models/task.dart';
import 'package:algoriza_todo/shared/colors.dart';
import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  final Function onpressed;
  final Task task;
  const TaskWidget({Key? key, required this.onpressed, required this.task})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          fillColor: MaterialStateProperty.all(appColors[task.color]),
          value: task.isCompleted == 1,
          onChanged: (bool? switched) {
            int integerVal = switched! ? 1 : 0;
            TaskCubit.get(context)
                .changecompleteState(id: task.id!, value: integerVal);
          },
        ),
        Text(task.title)
      ],
    );
  }
}
