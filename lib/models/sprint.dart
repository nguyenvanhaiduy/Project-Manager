import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

//  nếu như issue mà tích done rồi mà các child issua chưa được thực hiện hay chauw xong thì vẫn tính là chưa haongf thành và c
// được coi là không hợp lệ nếu như cố gắng ấn hoàn thành thì sẽ có thông báo thà rằng không hoàn thành issue đó đi để nó tạo ra một sprint mới hoặc chuyển xuống dưới backlog

class Sprint {
  final String id;
  final String title;
  final List<String> idIssues;
  final DateTime startDate;
  final DateTime endDate;
  final Status status;
  final String projectId;

  Sprint({
    String? id,
    required this.title,
    required this.idIssues,
    required this.startDate,
    required this.endDate,
    required this.status,
    String? idAssign,
    required this.projectId,
  }) : id = id ?? const Uuid().v4();
  factory Sprint.fromMap(Map<String, dynamic> data) {
    return Sprint(
      id: data['id'],
      title: data['title'],
      idIssues: List<String>.from(data['idIssues'] ?? []),
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      status: Status.values.firstWhereOrNull((s) => s.name == data['status']) ??
          Status.startSprint,
      projectId: data['projectId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'idIssues': idIssues,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'projectId': projectId,
    };
  }
}

enum Status {
  startSprint,
  completeSprint,
}
