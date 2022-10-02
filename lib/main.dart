import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:remember/bloc_observer.dart';
import 'package:remember/layout/todo/todo_app.dart';
import 'package:remember/shared/cubit/cubit.dart';
import 'package:remember/shared/cubit/states.dart';
import 'package:remember/shared/local/shared_preference.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  await CachHelper.init();

  bool? isDark = CachHelper.getBoolean(key: 'isDark');

  isDark??=true;

  runApp(MyApp(isDark));
}

class MyApp extends StatelessWidget{
  final bool isDark;

  MyApp(this.isDark);

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context) => ProgramCubit()..changeThemeMode(
        fromShared: isDark
      )
      ,
      child: BlocConsumer<ProgramCubit , ProgramStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              primarySwatch: Colors.deepOrange,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                titleSpacing: 20.0,
                iconTheme: IconThemeData(
                    color: Colors.black
                ),
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
                actionsIconTheme: IconThemeData(
                  color: Colors.black,
                ),
                elevation: 0.0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  backgroundColor: Colors.white,
                  elevation: 20.0,
                  unselectedItemColor: Colors.grey,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.deepOrange
              ),
              // textTheme: TextTheme(
              //   bodyText1: TextStyle(
              //     fontSize: 18.0,
              //     fontWeight: FontWeight.w600,
              //     color: Colors.black,
              //   ),
              // ),
            ),
            darkTheme: ThemeData(
              scaffoldBackgroundColor: Colors.black,
              primarySwatch: Colors.amber,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.black,
                titleSpacing: 20.0,
                iconTheme: IconThemeData(
                    color: Colors.amber
                ),
                titleTextStyle: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
                actionsIconTheme: IconThemeData(
                  color: Colors.amber,
                ),
                elevation: 0.0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.black,
                  statusBarIconBrightness: Brightness.light,
                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  backgroundColor: Colors.black,
                  elevation: 20.0,
                  unselectedItemColor: Colors.grey,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.amber
              ),
              // textTheme: TextTheme(
              //   bodyText1: TextStyle(
              //     fontSize: 18.0,
              //     fontWeight: FontWeight.w600,
              //     color: Colors.amber,
              //   ),
              // ),
            ),
            themeMode: ProgramCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: TodoApp(),
          );
        },
      ),
    );
  }

}


