import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do/firebase_utils.dart';
import 'package:to_do/model/task.dart';
import 'package:to_do/my_theme.dart';
import 'package:provider/provider.dart';
import 'package:to_do/provider/app_config_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskListItem extends StatefulWidget {
  @override
  State<TaskListItem> createState() => _TaskListItemState();
  Task task ;
  TaskListItem({required this.task});
}

class _TaskListItemState extends State<TaskListItem> {

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Container(
      margin: EdgeInsets.all(12),
      child: Slidable(
      // The start action pane is the one at the left or the top side.
      startActionPane: ActionPane(
        extentRatio: 0.25,
      // A motion is a widget used to control how the pane animates.
      motion: const ScrollMotion(),

      // All actions are defined in the children parameter.
      children:  [
      // A SlidableAction can have an icon and/or a label.
      SlidableAction(
        borderRadius: BorderRadius.circular(12),
      onPressed: (context){
          FirebaseUtils.deleteTaskFromFireStore(widget.task).
          timeout(Duration(milliseconds: 500),onTimeout: (){
            print('task deleted successfully');
            provider.getAllTasksFromFireStore();
          });
      },
      backgroundColor: MyTheme.redColor,
      foregroundColor: MyTheme.whiteColor,
      icon: Icons.delete,
      label: 'Delete',
      ),
      ],
      ),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: provider.isDarkMode()?
            MyTheme.blackColor
                :
            MyTheme.whiteColor
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Container(
              height: MediaQuery.of(context).size.height*0.10,
              width: 4,
              color: colors,
            ),
            SizedBox(width: 10,),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Text(widget.task.title ?? '',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colors
              ),),
              Text(widget.task.description ?? ''
                  ,style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: provider.isDarkMode()?
                  MyTheme.whiteColor
                      :
                  MyTheme.blackColor
              )),
            ],)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors
              ),
                  onPressed: (){
                count++;
                onClickCheck();
                    setState(() {

                    });
                  },
                  child: changeIconeTotext()
                  // Icon(Icons.check,color: MyTheme.whiteColor,size: 20,)
            ),

          ],),
        ),
      ),
    );
  }
  int count = 0;
  Color colors = Colors.blue;
  Color onClickCheck(){
    if(count%2==0){
      colors = MyTheme.primaryColor;
  }else{
  colors = Color(0xff61E757);
  }
    return colors ;
  }
  Widget changeIconeTotext(){
    if(count%2==0){
      return Icon(Icons.check,color: MyTheme.whiteColor,size: 20,);
    }
    return Text(AppLocalizations.of(context)!.done,style:Theme.of(context).textTheme.titleLarge,);
  }
}

