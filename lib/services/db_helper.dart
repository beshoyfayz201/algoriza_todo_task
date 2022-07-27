import 'package:algoriza_todo/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  String? path;
  static Database? database;
  initDb() async {
    path = await getDatabasesPath();

    database = await openDatabase(path! + "algoriza2.db", version: 1,
        onCreate: (db, version) {
      try {
        db.execute(
            "CREATE TABLE TASKS (id INTEGER PRIMARY KEY AUTOINCREMENT , title TEXT , startTime TEXT  , date TEXT , endTime TEXT, remind INTEGER , repeat INTEGER , isFavourite INTEGER , isCompleted INTEGER , color INTEGER )");
      } catch (e) {
        print(e.toString());
      }
    }, onOpen: (db) {
      database = db;
    });
  }

  insertTask(Task task) async {
    try {
      await database!.insert("TASKS", task.toMap());
    } catch (e) {
      print("insert error");
    }
  }

  deleteTask(Task task) async {
    try {
      await database!.delete("TASKS", where: "id=?", whereArgs: [task.id]);
    } catch (e) {
      print("delete error");
    }
  }

  changeCompleteState(int value, int id) async {
    await database!
        .rawQuery("UPDATE TASKS SET isCompleted = ? where id = ?", [value, id]);
  }

  changeFavouraiteState(int value, int id) async {
    await database!
        .rawQuery("UPDATE TASKS SET isCompleted = ? where id = ?", [value, id]);
  }

  Future<List<Task>> getAll() async {
    List<Map<String, dynamic>> res = await database!.query("TASKS");
    List<Task> myTasks = res.map((e) => Task.fromMap(e)).toList();
    print("test 1 : ");
    print(myTasks.length);

    return myTasks;
  }
}
