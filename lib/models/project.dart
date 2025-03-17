import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class Project {
  final String id;
  final String title;
  final String description;
  final Status status;
  final Priority priority;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> taskIds; // Lưu ID của Task
  final List<String> userIds; // Lưu ID của User
  final List<String> attachments;
  final String owner; // Lưu ID của người tạo Project
  final String idTag;

  Project(
      {String? id,
      required this.title,
      required this.description,
      required this.status,
      required this.priority,
      required this.startDate,
      required this.endDate,
      required this.taskIds,
      required this.userIds,
      required this.attachments,
      required this.owner,
      String? idTag})
      : id = id ?? const Uuid().v4(),
        idTag = idTag ?? '';

  factory Project.fromMap({required Map<String, dynamic> data}) {
    return Project(
        id: data['id'],
        title: data['title'],
        description: data['description'],
        status:
            Status.values.firstWhereOrNull((s) => s.name == data['status']) ??
                Status.notStarted,
        priority: Priority.values
                .firstWhereOrNull((p) => p.name == data['priority']) ??
            Priority.low,
        startDate: (data['startDate'] as Timestamp).toDate(),
        endDate: (data['endDate'] as Timestamp).toDate(),
        taskIds: List<String>.from(data['tasks'] ?? []),
        userIds: List<String>.from(data['users'] ?? []),
        attachments: List<String>.from(data['attachments'] ?? []),
        owner: data['owner'],
        idTag: data['idTag']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'priority': priority.name,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'tasks': taskIds,
      'users': userIds,
      'attachments': attachments,
      'owner': owner,
      'idTag': idTag,
    };
  }

  // @override
  // int compareTo(Project other) {
  //   print("$status  ${other.status}");
  //   return status.index.compareTo(other.status.index);
  // }
}

enum Status {
  notStarted,
  inProgress,
  completed,
  lateCompleted,
  cancelled,
}

enum Priority {
  low,
  medium,
  high,
}
