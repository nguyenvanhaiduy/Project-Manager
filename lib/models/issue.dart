import 'package:get/get_utils/get_utils.dart';
import 'package:project_manager/models/project.dart';
import 'package:uuid/uuid.dart';

class Issue {
  final String id;
  final String title;
  final List<String> taskIds;
  final Status status;
  final String sprintId;
  final String assignId;

  Issue({
    String? id,
    required this.title,
    required this.taskIds,
    required this.status,
    required this.sprintId,
    String? assignId,
  })  : id = id ?? const Uuid().v4(),
        assignId = assignId ?? 'Unassigned';

  factory Issue.fromMap(Map<String, dynamic> data) {
    return Issue(
      id: data['id'],
      title: data['title'],
      taskIds: List<String>.from(data['taskIds'] ?? []),
      status: Status.values.firstWhereOrNull((s) => s.name == data['status']) ??
          Status.notStarted,
      sprintId: data['sprintId'],
      assignId: data['assignId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'taskIds': taskIds,
      'status': status,
      'sprintId': sprintId,
      'assignId': assignId,
    };
  }
}
