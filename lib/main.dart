import 'package:algoriza_todo/cubit/input_cubit/cubit/input_cupit_cubit.dart';
import 'package:algoriza_todo/cubit/task_cubit/task_cubit.dart';

import 'package:algoriza_todo/services/db_helper.dart';
import 'package:algoriza_todo/services/notification_services.dart';
import 'package:algoriza_todo/views/screens/add_task.dart';
import 'package:algoriza_todo/views/screens/home_screen.dart';
import 'package:algoriza_todo/views/screens/schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper().initDb();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     NotifyHelper().initNotification(context);
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TaskCubit(DBHelper())..initDb(),
          ),
          BlocProvider(
            create: (context) => InputCubit(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BoardScreen(),
          routes: {
            AddTask.id: (context) => AddTask(),
            ScheduleScreen.id: (context) => ScheduleScreen()
          },
        ));
  }
}
