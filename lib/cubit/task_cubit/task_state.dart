import 'package:algoriza_todo/models/task.dart';

abstract class TaskState {}

class InitDBState extends TaskState {
  final List<Task> tasks;
  InitDBState(this.tasks);
}

class GetAllTaskState extends TaskState {}

class InsertTaskState extends TaskState {}

class DeleteTaskState extends TaskState {}

class ChangeCompletedState extends TaskState {}

class ChangeIsFavState extends TaskState {}

class LoadingState extends TaskState {}

class ErrorState extends TaskState {}
