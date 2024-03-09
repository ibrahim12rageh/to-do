import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do/model/my_user.dart';
import 'package:to_do/model/task.dart';

class FirebaseUtils{
  static CollectionReference<Task> getTasksCollection(){ //وظيقتها انها تجيب ال collection عشان استحدمه فى add ,remove,update وغيرها بقا بدل من التكرار
    return FirebaseFirestore.instance.collection(Task.collectionName).
    withConverter<Task>(    /*with converter determine what the kind of thing that should be stored in firebase by template*/
        fromFirestore: ((snapshot,options) => Task.fromFireStore(snapshot.data()!)), /*json==>object*/  /*اى داتا بتبقا راجعه بتكون متحمله فى ال snapshot*/
        toFirestore:  (task,_) => task.toFireStore()     /*object ==> json*/
    );

  }


  static Future<void> addTaskToFireStore(Task task){
    var taskCollection = getTasksCollection();  //collection // var = CollectionReference<Task>
    DocumentReference<Task> taskDocRef = taskCollection.doc();
    task.id = taskDocRef.id; //taskDocRef.id => auto id in documentation
    return taskDocRef.set(task);

  }

  static Future<void> deleteTaskFromFireStore(Task task){
    return getTasksCollection().doc(task.id).delete();
  }

  static CollectionReference<MyUser> getUsersCollection(){
    return FirebaseFirestore.instance.collection(MyUser.collectionName).
    withConverter<MyUser>(
        fromFirestore: ((snapshot,options) => MyUser.fromFireStore(snapshot.data()!)),
        toFirestore: (user,_) => user.toFireStore())
    ;
  }

  static Future<void> addUserToFireStore(MyUser myUser){
    return getUsersCollection().doc(myUser.id).set(myUser);
  }
}