import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/modules/archive_tasks/archive_tasks_screen.dart';
import 'package:todoapp/modules/done_tasks/done_tasks_screen.dart';
import 'package:todoapp/modules/new_tasks/new_tasks_screen.dart';
import 'package:todoapp/shared/cubit.dart/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitalState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentindex = 0;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchiveTasksScreen(),
  ];

  List<String> titles = [
    'Tasks',
    'Done tasks',
    'Archive',
  ];

  void changeIndex(int index) {
    currentindex = index;
    emit(AppChangeBottomNavBarState());
  }

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void createdatabase() {
    // id integer
    // title string
    // date string
    // time String
    // status string

    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async {
        print('database created');

        await database
            .execute(
                'CREATE TABLE Test(id INTEGER PRIMARY KEY, title TEXT, data TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('tabel created');
        }).catchError((error) {
          print('error when table created ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database!.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO Test(title, data, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print('$value insert successfully');
        emit(AppInsertDataBaseState());

        getDataFromDatabase(database);
      }).catchError((error) {
        print('error when insert new ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    emit(AppGetDataBaseloadingState());
    database.rawQuery('SELECT * FROM Test').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archiveTasks.add(element);
      });
      emit(AppGetDataBaseState());
    });
  }

// ------Update some record------
  void UpdateData({
    required String status,
    required int id,
  }) async {
    database?.rawUpdate('UPDATE Test SET status = ? WHERE name = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDataBaseState());
    });
  }

  void deleteData({
    required int id,
  }) async {
    database?.rawUpdate('DELETE FROM Test WHERE id = ?' ,[id]).then((value) {

      getDataFromDatabase(database);

      emit(AppDeleteDataBaseState());
    });
  }

  void UpdateDatabase({
    required String status,
    required int id,
  }) {
    database!.rawUpdate('UPDATE Test SET status = ?  WHERE id = ?',
        ['$status', '$id']).then((value) {
      getDataFromDatabase(database);
      emit(update_State());
      print(value.toString());
    }).catchError((error) {
      print(error.toString());
    });
  }

  bool isBottomSheetDown = false;
  IconData fabIcon = Icons.edit;

  void ChangeIconBottom({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetDown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
