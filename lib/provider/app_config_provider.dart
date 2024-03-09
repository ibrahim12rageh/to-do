import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../firebase_utils.dart';
import '../model/task.dart';

class AppConfigProvider extends ChangeNotifier{
  String appLanguage = 'en' ;
  ThemeMode appTheme = ThemeMode.light;
  List<Task> taskList =[];
  DateTime selectedDate = DateTime.now();

  void getAllTasksFromFireStore()async{
    QuerySnapshot<Task> querySnapshot =await FirebaseUtils.getTasksCollection().get();// get بترجعلى كل حاجه جوا collection
    //List<QueryDocumentSnapshot<Task>> => List<Task>
    taskList =querySnapshot.docs.map((doc) {
      return doc.data();
    }
    ).toList();
    //filter (select date)
    taskList = taskList.where((task) {
      if(
      selectedDate.day == task.dateTime!.day &&
      selectedDate.month == task.dateTime!.month&&
      selectedDate.year == task.dateTime!.year
      ){
        return true;
      }
      return false;
    }).toList();
    //sorting

    taskList.sort(( task1,  task2){
      return task1.dateTime!.compareTo(task2.dateTime!);
    });
    notifyListeners();
  }
  void changeSelectedDate(DateTime newSelectedDate){
    selectedDate = newSelectedDate ;
    getAllTasksFromFireStore();
  }


  void changeLanguage(String newLanguge){
    if(appLanguage == newLanguge){
      return ;
    }
    appLanguage = newLanguge;
    notifyListeners();
  }

  void changeTheme(ThemeMode newMode){
    if(appTheme == newMode){
      return ;
    }
    appTheme = newMode ;
    notifyListeners();
  }

  bool isDarkMode(){
    return appTheme == ThemeMode.dark ;
  }
}