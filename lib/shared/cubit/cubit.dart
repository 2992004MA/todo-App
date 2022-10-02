import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remember/shared/cubit/states.dart';
import 'package:remember/shared/local/shared_preference.dart';

class ProgramCubit extends Cubit<ProgramStates>{
  ProgramCubit() : super(ProgramInitialState());

  static ProgramCubit get(context) => BlocProvider.of(context);

  bool isDark = false;

  void changeThemeMode({bool? fromShared}){
    if(fromShared != null)
      isDark = fromShared;
    else
      isDark = !isDark;
    CachHelper.putBoolean(key: 'isDark', value: isDark);
    emit(ProgramChangeThemeModeState());
  }
}