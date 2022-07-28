import 'package:algoriza_todo/cubit/task_cubit/task_state.dart';
import 'package:algoriza_todo/models/task.dart';
import 'package:algoriza_todo/services/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskCubit extends Cubit<TaskState> {
  DBHelper databaseHelper;
  List<Task> tasks = [];
  List<Task> favouriteTasks = [];
  List<Task> completedTasks = [];
  List<Task> unCompletedTasks = [];
  TaskCubit(this.databaseHelper) : super(LoadingState());
  static TaskCubit get(BuildContext ctx) => BlocProvider.of(ctx);
  initDb() async {
    emit(LoadingState());
    databaseHelper.initDb();
    List<Task> tasks = await databaseHelper.getAll();
    this.tasks = tasks;
    this.tasks.forEach((element) {
      if (element.isCompleted == 1) {
        completedTasks.add(element);
      }
      if (element.isFavourite == 1) {
        favouriteTasks.add(element);
      }
      if (element.isCompleted == 0) {
        unCompletedTasks.add(element);
      }
    });
    emit(InitDBState(tasks));
  }

  getAll() async {
    tasks = await databaseHelper.getAll();
    completedTasks = [];
    favouriteTasks = [];
    unCompletedTasks = [];
    refreshLists();
    emit(GetAllTaskState());
  }

  insertTask(Task task) {
    emit(LoadingState());

    databaseHelper.insertTask(task);
    refreshLists();
    emit(InsertTaskState());
  }

  deleteTask(Task task) {
    emit(LoadingState());

    databaseHelper.deleteTask(task);
    refreshLists();

    emit(DeleteTaskState());
  }

  changecompleteState({required int id, required int value}) async {
    await databaseHelper.changeCompleteState(value, id);

    refreshLists();
    emit(ChangeCompletedState());
  }

  changeFavouriteState({required int id, required int value}) async {
    await databaseHelper.changeFavouraiteState(value, id);

    refreshLists();

    emit(ChangeCompletedState());
  }

  refreshLists() async {
    tasks = await databaseHelper.getAll();
    completedTasks = [];
    favouriteTasks = [];
    unCompletedTasks = [];
    if (tasks.isNotEmpty) {
      tasks.forEach((element) {
        if (element.isCompleted == 1) {
          completedTasks.add(element);
        }
        if (element.isFavourite == 1) {
          favouriteTasks.add(element);
        }
        if (element.isCompleted == 0) {
          unCompletedTasks.add(element);
        }
      });
    }
  }
}
