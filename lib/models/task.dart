import 'dart:convert';

class Task {
   int? id;
   String title;
   String date;
   String startTime;
   String endTime;
   int remind;
   int repeat;
  int isFavourite;
  int isCompleted;
  int color;
  Task({
     this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.remind,
    required this.repeat,
    required this.isFavourite,
    required this.isCompleted,
    required this.color,
  });


  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(id != null){
      result.addAll({'id': id});
    }
    result.addAll({'title': title});
    result.addAll({'date': date});
    result.addAll({'startTime': startTime});
    result.addAll({'endTime': endTime});
    result.addAll({'remind': remind});
    result.addAll({'repeat': repeat});
    result.addAll({'isFavourite': isFavourite});
    result.addAll({'isCompleted': isCompleted});
    result.addAll({'color': color});
  
    return result;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id']?.toInt(),
      title: map['title'] ?? '',
      date: map['date'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      remind: map['remind']?.toInt() ?? 0,
      repeat: map['repeat']?.toInt() ?? 0,
      isFavourite: map['isFavourite']?.toInt() ?? 0,
      isCompleted: map['isCompleted']?.toInt() ?? 0,
      color: map['color']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));
}

