import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:remember/layout/todo/cubit/cubit.dart';

import '../../layout/todo/cubit/cubit.dart';
import '../cubit/cubit.dart';

Widget defaultFormFeild({
  required String label,
  required IconData prefix,
  required TextInputType type,
  required TextEditingController controller,
  void Function()? onTap,
  required String? Function(String?)? validate,
  required BuildContext context,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      validator: validate,
      style: TextStyle(
        color: ProgramCubit.get(context).isDark? Colors.white : Colors.black,
      ),
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: ProgramCubit.get(context).isDark? Colors.amber : Colors.grey,
        ),
        prefixIcon: Icon(
          prefix,
          color: ProgramCubit.get(context).isDark? Colors.amber : Colors.grey,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ProgramCubit.get(context).isDark? Colors.amber : Colors.grey,
          ),
        ),
      ),
    );

Widget buildTaskItem(list, context) => Dismissible(
      key: Key(list['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: ProgramCubit.get(context).isDark ? Colors.amber : Colors.deepOrange,
              radius: 40.0,
              child: Text(
                '${list['time']}',
                style: TextStyle(
                  color: ProgramCubit.get(context).isDark ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${list['title']}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: ProgramCubit.get(context).isDark ? Colors.amber : Colors.black,
                    ),
                    // maxLines: 3,
                    // overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${list['date']}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 25.0,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'done', id: list['id']);
              },
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(status: 'archived', id: list['id']);
              },
              icon: Icon(
                Icons.archive,
                color: ProgramCubit.get(context).isDark ? Colors.amber : Colors.grey,
              ),
            ),
          ],
        ),
      ),
  onDismissed: (direction) {
    AppCubit.get(context).deleteDatabase(id: list['id']);
  },
    );

Widget dividerBuilder(context) => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      child: Container(
        height: 1.0,
        color: ProgramCubit.get(context).isDark ?Colors.grey : Colors.grey[300],
      ),
    );

Widget tasksBuilder({
  required List<Map> list,
}) =>
    ConditionalBuilder(
      condition: list.length > 0,
      builder: (context) => ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) => buildTaskItem(list[index], context),
        separatorBuilder: (context, index) => dividerBuilder(context),
        itemCount: list.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              color: Colors.grey[300],
              size: 50.0,
            ),
            Text(
              'No Tasks yet ,please add some Tasks',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
