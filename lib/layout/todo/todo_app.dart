import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:remember/shared/component/component.dart';
import 'package:remember/layout/todo/cubit/cubit.dart';
import 'package:remember/layout/todo/cubit/states.dart';
import 'package:remember/shared/cubit/cubit.dart';

class TodoApp extends StatelessWidget {

  var scafoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit , AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);

          return Scaffold(
            key: scafoldKey,
            appBar: AppBar(
              title: Text(
                  'To Do',
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    ProgramCubit.get(context).changeThemeMode();
                  },
                  icon: Icon(Icons.brightness_4_outlined),
                ),
              ],
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) =>  cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
                ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (value) {
                cubit.changeBottomNavBar(value);
              },
              items: cubit.bottomItem,
              type: BottomNavigationBarType.fixed,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if(cubit.isBottomShow){
                  if(formKey.currentState!.validate()){
                    cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                      Navigator.pop(context);
                  }
                }else {
                  scafoldKey.currentState!.showBottomSheet((context) =>
                      Container(
                        padding: EdgeInsets.all(20.0),
                        color: ProgramCubit.get(context).isDark ? Colors.black : Colors.grey[100],
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormFeild(
                                context: context,
                                label: 'Task title',
                                prefix: Icons.title,
                                type: TextInputType.text,
                                controller: titleController,
                                validate: (value) {
                                  if(value!.isEmpty){
                                    return 'Task title must not be empty';
                                  }
                                  return null;
                                },

                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              defaultFormFeild(
                                context: context,
                                label: 'Task time',
                                prefix: Icons.watch_later_outlined,
                                type: TextInputType.datetime,
                                controller: timeController,
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    timeController.text =
                                        value!.format(context);
                                  });
                                },
                                validate: (value) {
                                  if(value!.isEmpty){
                                    return 'Task time must not be empty';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 10.0,),
                              defaultFormFeild(
                                context: context,
                                label: 'Task Date',
                                prefix: Icons.date_range_outlined,
                                type: TextInputType.datetime,
                                controller: dateController,
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2022-11-30'),
                                  ).then((value) {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value!);
                                    print(dateController.text);
                                  });
                                },
                                validate: (value) {
                                  if(value!.isEmpty){
                                    return 'Task date must not be empty';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      )).closed.then((value) {
                        cubit.changeBottomSheetShow(
                          isShow: false,
                          icon: Icons.edit,
                        );
                   });
                  cubit.changeBottomSheetShow(
                    isShow: true,
                    icon: Icons.add,
                  );
                }
                  },
              child: Icon(cubit.fabIcon),
            ),
          );
        },
      ),
    );
  }
}
