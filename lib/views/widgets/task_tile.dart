import 'package:algoriza_todo/models/task.dart';
import 'package:algoriza_todo/shared/colors.dart';
import 'package:algoriza_todo/shared/size_config.dart';
import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenWidth * 0.9
          : SizeConfig.screenWidth,
      margin: EdgeInsets.all(getProportionateScreenHeight(20)),
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(15),
        horizontal: getProportionateScreenHeight(
            SizeConfig.orientation == Orientation.landscape ? 40 : 20),
      ),
      decoration: BoxDecoration(
        color: getcol(task.color),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${task.startTime} ${task.endTime} ",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    task.title,
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Icon(
            (task.isCompleted == 0)
                ? Icons.circle_outlined
                : Icons.check_circle_rounded,
            color: Colors.grey.shade300,
            size: getProportionateScreenHeight(25),
          ),
        ],
      ),
    );
  }

  getcol(int? color) {
    return appColors[color!];
  }
}
