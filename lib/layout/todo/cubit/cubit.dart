import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remember/modules/archived_tasks/archived_task.dart';
import 'package:remember/modules/done_tasks/done_task.dart';
import 'package:remember/modules/new_tasks/new_task.dart';
import 'package:sqflite/sqflite.dart';

import '../../../layout/todo/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  List<BottomNavigationBarItem> bottomItem = [
    BottomNavigationBarItem(
      icon: Icon(Icons.menu_rounded),
      label: 'Tasks',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.check_circle_outline),
      label: 'Done',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.archive_outlined),
      label: 'Archived',
    ),
  ];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(AppChangeButtomNavBarState());
  }

  bool isBottomShow = false;
  IconData? fabIcon;
  void changeBottomSheetShow({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomShow = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetShowState());
  }

  Database? database;
  // List<Map> tasks =[];
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];
  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('Database created');
        database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT ,time TEXT ,date TEXT ,status TEXT)')
            .then((value) {
          print('table created');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    }).catchError((error) {
      print('error : ${error.toString()}');
    });
  }

  void insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) {
    database!.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, time, date , status) VALUES("$title", "$time", "$date" , "new" )')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertToDatabaseState());

        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error while insert : ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      // tasks = value;
      // print(tasks);
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(AppGetDataFromDatabaseState());
    });
  }

  void updateDatabase({
    required String status,
    required int id,
  }) {
    database!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState()) ;
    });
  }

  void deleteDatabase({
  required int id,
})async{
    database!
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
          getDataFromDatabase(database);
          emit(AppDeleteDataFromDatabase());
    });
  }

  bool isDark = false;
  void changeThemeMode(){
    isDark = !isDark;
    emit(AppChangeThemeModeState());
  }
}
