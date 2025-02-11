import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:project_manager/models/project.dart';
import 'package:uuid/uuid.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final Status status;
  final Priority priority;
  final String assignTo; // Lưu ID của User
  final Complexity complexity;

  Task(
      {String? id,
      required this.title,
      required this.description,
      required this.startDate,
      required this.endDate,
      required this.status,
      required this.priority,
      required this.assignTo,
      required this.complexity})
      : id = id ?? const Uuid().v4();

  factory Task.fromMap({required Map<String, dynamic> data}) {
    return Task(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      status: Status.values.firstWhereOrNull((s) => s.name == data['status']) ??
          Status.notStarted,
      priority: data['priority'],
      assignTo: data['assignTo'],
      complexity: Complexity.values
              .firstWhereOrNull((c) => c.name == data['complexity']) ??
          Complexity.easy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'status': status.name,
      'assignTo': assignTo,
      'complexity': complexity.name,
    };
  }
}

enum Complexity {
  easy,
  medium,
  hard,
  veryHard,
}
