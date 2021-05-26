import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/component/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var form_key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return BlocProvider(
      create: (context) => AppCubit()..createDB(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          if (state is AppInsertDB) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) => Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: AppCubit.get(context)
                .titles[AppCubit.get(context).currentIndex],
          ),
          body: ConditionalBuilder(
            condition: state is! AppGetLoadingDB,
            builder: (context) => AppCubit.get(context)
                .screens[AppCubit.get(context).currentIndex],
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 15,
            currentIndex: AppCubit.get(context).currentIndex,
            onTap: (index) {
              AppCubit.get(context).changeIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: "Tasks",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.done),
                label: "Done",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.archive),
                label: "Archived",
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(AppCubit.get(context).buttomIcon),
            onPressed: () {
              if (AppCubit.get(context).isButtomShown) {
                if (form_key.currentState.validate()) {
                  AppCubit.get(context).insertDB(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text);
                }
                ;
              } else {
                AppCubit.get(context).buttomIcon = Icons.add;
                scaffoldKey.currentState
                    .showBottomSheet((context) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Form(
                            key: form_key,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                textForm(
                                  isPass: false,
                                  text: "Task Title",
                                  controller: titleController,
                                  icon: Icons.edit,
                                  validate: (value) {
                                    if (value.isEmpty) {
                                      return 'Title can not be empty';
                                    }
                                    ;
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                textForm(
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value.format(context);
                                    });
                                  },
                                  isPass: false,
                                  text: "Task Time",
                                  controller: timeController,
                                  icon: Icons.watch_later_outlined,
                                  validate: (value) {
                                    if (value.isEmpty) {
                                      return 'Time can not be empty';
                                    }
                                    ;
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                textForm(
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2022-01-15'))
                                        .then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value);
                                    });
                                  },
                                  isPass: false,
                                  text: "Task Date",
                                  controller: dateController,
                                  icon: Icons.watch_later_outlined,
                                  validate: (value) {
                                    if (value.isEmpty) {
                                      return 'Date can not be empty';
                                    }
                                    ;
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ))
                    .closed
                    .then((value) {
                  AppCubit.get(context)
                      .changeButtom(isShow: false, icon: Icons.edit);
                });
                AppCubit.get(context)
                    .changeButtom(isShow: true, icon: Icons.add);
              }
            },
          ),
        ),
      ),
    );
  }
}
