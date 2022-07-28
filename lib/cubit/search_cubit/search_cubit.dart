import 'package:algoriza_todo/cubit/search_cubit/search_cubit_state.dart';
import 'package:algoriza_todo/cubit/task_cubit/task_state.dart';
import 'package:algoriza_todo/models/task.dart';
import 'package:algoriza_todo/services/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchCubitState> {
    static SearchCubit get(BuildContext ctx) => BlocProvider.of(ctx);

  bool Searching = false;

  SearchCubit() : super(NotSearching());
  changeSearchState() {
    Searching = !Searching;
    emit(Searching ? IsSearching() : NotSearching());
  }
}
