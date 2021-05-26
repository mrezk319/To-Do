import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_tasks/archived_task_screen.dart';
import 'package:todo/modules/done_tasks/done_task_screen.dart';
import 'package:todo/modules/new_tasks/new_task_screen.dart';
import 'package:todo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  List<Widget> titles = [
    Text("New Tasks"),
    Text("Done Tasks"),
    Text("Archived Tasks"),
  ];
  int currentIndex = 0;

  void changeIndex(index) {
    currentIndex = index;
    emit(AppChangeButtonNavar());
  }

  ///
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  Database dataBase;

  void getDB(dataBase) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetLoadingDB());
    dataBase.rawQuery("SELECT * FROM Tasks").then((value) {
      emit(AppGetDB());
      print(newTasks);
      value.forEach((element) {
        if(element['status'] == 'New') newTasks.add(element);
        else if(element['status'] == 'done') doneTasks.add(element);
        else if(element['status'] == 'archived') archivedTasks.add(element);
      });
    });
  }

  void createDB() {
    openDatabase('toDo.db', version: 1, onCreate: (dataBase, version) {
      dataBase
          .execute(
              'CREATE table Tasks (id INTEGER PRIMARY KEY, title TEXT,date TEXT,time TEXT,status TEXT)')
          .then((value) {
        print('Created');
      }).catchError((onError) {
        print('$onError');
      });
    }, onOpen: (dataBase) {
      getDB(dataBase);
    }).then((value) {
      dataBase = value;
      emit(AppCreateDB());
    });
  }

  void updateData({@required String status, @required int id}) {
    dataBase.rawUpdate('UPDATE Tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDB(dataBase);
      emit(AppUpdateDB());
    });
  }
  void deleteData({@required int id}) {
    dataBase.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      getDB(dataBase);
      emit(AppDeleteDB());
    });
  }

  insertDB({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await dataBase.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO Tasks (title ,date ,time ,status ) VALUES("$title","$date","$time","New")')
          .then((value) {
        print('$value inserted succefully');
        emit(AppInsertDB());
        getDB(dataBase);
      }).catchError((onError) {
        print("Error : ${onError.toString()}");
      });
      return null;
    });
  }

  bool isButtomShown = false;
  IconData buttomIcon = Icons.edit;

  void changeButtom({@required bool isShow, @required IconData icon}) {
    isButtomShown = isShow;
    buttomIcon = icon;
    emit(ChangeButtomStyleSheet());
  }
}
