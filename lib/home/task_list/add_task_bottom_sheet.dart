import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:to_do/firebase_utils.dart';
import 'package:to_do/model/task.dart';
import 'package:to_do/my_theme.dart';
import 'package:provider/provider.dart';
import 'package:to_do/provider/app_config_provider.dart';
class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var selectedDate = DateTime.now();
  var formKey =GlobalKey<FormState>();
  String title = '' ;
  String description = '' ;
  late AppConfigProvider provider;
  @override
  Widget build(BuildContext context) {
     provider = Provider.of<AppConfigProvider>(context);
    return Container(
      color: provider.isDarkMode()?
          MyTheme.blackColor
          :
          MyTheme.whiteColor
      ,
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(AppLocalizations.of(context)!.add_new_task,style: Theme.of(context).textTheme.titleMedium,),
          Form(
            key: formKey,
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                onChanged: (text){
                  title = text ;
                },
                validator: (text){
                  if( text==null || text.isEmpty){
                    return AppLocalizations.of(context)!.please_enter_task ;
                  }
                  return null ;
                },
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.enter_your_task,
                  hintStyle: TextStyle(
                      color: provider.isDarkMode()?
                      MyTheme.whiteColor
                          :
                      MyTheme.blackColor
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: provider.isDarkMode()?
                      MyTheme.whiteColor
                          :
                      MyTheme.blackColor
                    )
                  )
                ),
                style: TextStyle(
                  color: provider.isDarkMode()?
                  MyTheme.whiteColor
                      :
                  MyTheme.blackColor
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                onChanged: (text){
                  description = text ;
                },
                  validator: (text){
                    if( text==null || text.isEmpty){
                      return AppLocalizations.of(context)!.please_enter_description ;
                    }
                    return null ;
                  },
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.enter_task_description,
                    hintStyle: TextStyle(
                        color: provider.isDarkMode()?
                        MyTheme.whiteColor
                            :
                        MyTheme.blackColor
                    ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: provider.isDarkMode()?
                      MyTheme.whiteColor
                          :
                      MyTheme.blackColor
                    )
                  )
                ),
                maxLines: 2,
                style: TextStyle(
                    color: provider.isDarkMode()?
                    MyTheme.whiteColor
                        :
                    MyTheme.blackColor
                ),
              ),
              SizedBox(height: 15,),
              Text(AppLocalizations.of(context)!.select_date,style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: provider.isDarkMode()?
                  MyTheme.whiteColor
                      :
                  MyTheme.blackColor
              ),),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  showCalender();
                },
                  child: Text('${selectedDate.day}- ${selectedDate.month}-${selectedDate.year}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: provider.isDarkMode()?
                        MyTheme.whiteColor
                        :
                          MyTheme.blackColor
                    ),)),
              SizedBox(height: 15,),
              ElevatedButton(onPressed: (){
                setState(() {
                  addTask();

                });
              }, child: Text(AppLocalizations.of(context)!.add,
              style: Theme.of(context).textTheme.titleLarge,
              ))
            ],
          ))
        ],
      ),
    );
  }
  void showCalender() async {
    var chosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365))
    );
    if (chosenDate != null) {
      selectedDate = chosenDate;
      setState(() {

      });
    }
  }

  void addTask() {
    if(formKey.currentState?.validate()==true){
      Task task = Task(title: title, description: description, dateTime: selectedDate);
      FirebaseUtils.addTaskToFireStore(task).timeout(         //الaddtask مش هترجع القيمه فى لحظتها عشان كده هى بترجع future void عندنا طريقتين لحل المشكله دى اما انى اعمل await وsyncالطريقه التانيه انى اعمل then فى حالة انى شغال اون لاين او استخدم timeout فى خالة انى شغال اوف لاين
        Duration(milliseconds: 500), //يعنى بعد نص ثانيه
        onTimeout: (){
          print('the task added');
          // print('task is done');
          // Fluttertoast.showToast(
          //   msg: "This is Center Short Toast",
          //   toastLength: Toast.LENGTH_LONG,
          //   gravity: ToastGravity.BOTTOM,
          //   timeInSecForIosWeb: 1,
          //   backgroundColor: Colors.red,
          //   textColor: Colors.black,
          //   fontSize: 24.0,
          // );
          //
          provider.getAllTasksFromFireStore();
          Navigator.pop(context);
        }
      );
    }
  }
}
