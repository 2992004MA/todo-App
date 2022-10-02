import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/component/component.dart';
import '../../layout/todo/cubit/cubit.dart';
import '../../layout/todo/cubit/states.dart';

class ArchivedTasks extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).archivedTasks;

        return tasksBuilder(list: tasks);
      },
    );
  }
}