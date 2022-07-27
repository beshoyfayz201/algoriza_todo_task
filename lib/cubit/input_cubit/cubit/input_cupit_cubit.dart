import 'package:algoriza_todo/models/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'input_cupit_state.dart';

class InputCubit extends Cubit<InputCupitState> {
  Task task = Task(
      title: "",
      date: DateFormat.yMd().format(DateTime.now()),
      startTime: DateFormat("hh:mm").format(DateTime.now()),
      endTime: DateFormat("hh:mm")
          .format(DateTime.now().add(const Duration(minutes: 15))),
      remind: 0,
      repeat: 0,
      isFavourite: 0,
      isCompleted: 0,
      color: 0);

  setDate(String date) {
    task.date = date;
    emit(InputChanged());
  }

  setStartTime(String startTime) {
    task.startTime = startTime;
    emit(InputChanged());
  }

  setEndTime(String endTime) {
    task.endTime = endTime;
    emit(InputChanged());
  }

  setRemind(int remind) {
    task.remind = remind;
    emit(InputChanged());
  }

  setRepeat(int repeat) {
    task.repeat = repeat;
    emit(InputChanged());
  }

  setColor(int color) {
    task.color = color;
    emit(InputChanged());
  }

  InputCubit() : super(InputCupitInitial());
  static InputCubit get(BuildContext ctx) => BlocProvider.of(ctx);
}
