import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/shared/cubit.dart/cubit.dart';
import '../cubit.dart/states.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String)? onSubmit,
  bool isPassword = false,
  Function(String)? onChange,
  Function()? onTap,
  required Function,
  validate,
  required String label,
  required IconData preifix,
  Function()? suffixPressed,
  IconData? suffix,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    obscureText: isPassword,
    onFieldSubmitted: onSubmit,
    onChanged: onChange,
    onTap: onTap,
    validator: validate,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        preifix,
      ),
      suffixIcon: suffix != null
          ? IconButton(
              onPressed: suffixPressed,
              icon: Icon(
                suffix,
              ),
            )
          : null,
      border: OutlineInputBorder(),
    ),
  );
}

Widget buildTasksItem(Map model, context) => BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        AppCubit cubit = AppCubit.get(context);
        return Dismissible(
          key: Key(model['id'].toString()),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40.0,
                  child: Text(
                    '${model['time']}',
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
                        '${model['title']}',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${model['data']}',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                IconButton(
                  onPressed: () {
                    cubit.UpdateDatabase(id: model['id'], status: "done");
                  },
                  icon: Icon(
                    Icons.check_box,
                    color: Colors.green,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    cubit.UpdateDatabase(id: model['id'], status: "archive");
                  },
                  icon: Icon(
                    Icons.watch_later_outlined,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          onDismissed: (direction){
            AppCubit.get(context).deleteData(id: model['id'],);
          },
        );
      },
    );

Widget tasksBuilder ({
  required List<Map> tasks,
  required String text,
}) {
return Center(
child: Text(
'$text empty',
style: TextStyle(
color: Colors.black38,
fontWeight: FontWeight.bold,
fontSize: 20,
),
),
);
}