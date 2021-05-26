import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

Widget textForm({
  Function onTap,
  TextEditingController controller,
  String text,
  IconData icon,
  bool isPass = false,
  Function validate,
  IconData suffix,
  Function show,
}) =>
    TextFormField(
      onTap: onTap,
      obscureText: isPass,
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
        suffixIcon: suffix == null
            ? null
            : IconButton(
                icon: Icon(suffix),
                onPressed: show,
              ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: validate,
    );

Widget getTaskBuilder({@required Map model, context}) => Dismissible(
  key: Key(model['id'].toString()),
  child:Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
          children: [
            CircleAvatar(
              child: Text(
                "${model['time']}",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              backgroundColor: Colors.lightBlueAccent,

              radius: 50,

            ),

            SizedBox(

              width: 18,

            ),

            Expanded(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                mainAxisSize: MainAxisSize.min,

                children: [

                  Text(

                    "${model['title']}",

                    style: TextStyle(fontSize: 22),

                  ),

                  Text(

                    "${model['date']}",

                    style: TextStyle(color: Colors.grey[500]),

                  )

                ],

              ),

            ),

            IconButton(

              icon: Icon(Icons.archive, color: Colors.blueGrey),

              onPressed: () {

                AppCubit.get(context).updateData(status: 'archived', id: model['id']);

              },

            ),

            IconButton(

              icon: Icon(

                Icons.check_box,

                color: Colors.green,

              ),

              onPressed: () {

                AppCubit.get(context).updateData(status: 'done', id: model['id']);

              },

            ),

          ],

        ),
  ),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id: model['id']);
  },
);
Widget screenBuilder({@required tasks}) => ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context) => ListView.separated(
      itemBuilder: (context, index) => getTaskBuilder(model: tasks[index],context: context),
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 5),
        child: Container(
          width: double.infinity,
          color: Colors.lightBlue,
          height: 1,
        ),
      ),
      itemCount: tasks.length),
  fallback:(context)=> Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu,color: Colors.grey,size: 40,),
        Text("No Tasks Here",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
      ],
    ),
  ),
);