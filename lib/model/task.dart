class Task{
  static const String collectionName ='tasks';

  String? id ;
  String? title ;
  String? description ;
  DateTime? dateTime ;
  bool? isDone ;


  Task({
  this.id ='',
  required this.title,
  required this.description,
  required this.dateTime,
   this.isDone=false,
});

  /// json => object
  Task.fromFireStore(Map<String,dynamic> data)://named constructor
        this(
    id: data['id'] as String?,
    title: data['title'] as String?,
    description: data['description'] as String?,
    dateTime: DateTime.fromMillisecondsSinceEpoch(data['dateTime']),
      isDone: data['isDone'] as bool?
  );
  /// object => json

  Map<String,dynamic> toFireStore(){
    return {
      'id' : id ,
      'title' : title ,
      'description' : description ,
      'dateTime' : dateTime?.millisecondsSinceEpoch ,//milliSecondSinceEpoch convert datetime to int to make operation om it
      'isDone' : isDone
    };
  }
}