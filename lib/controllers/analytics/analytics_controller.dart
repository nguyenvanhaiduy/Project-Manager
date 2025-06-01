import 'dart:math' show min;

import 'package:cloud_firestore/cloud_firestore.dart'; // Vẫn có thể cần cho các type như Timestamp nếu dùng
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/project/project_controller.dart';
import 'package:project_manager/controllers/task/task_controller.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/task.dart';

enum ChartType { project, task }

enum TimeFilter { day, week, month, year }

class AnalyticsController extends GetxController {
  // KHÔNG cần _firestore nữa nếu lấy dữ liệu từ controller khác
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController authController = Get.find();
  final ProjectController projectController =
      Get.find(); // LẤY ProjectController
  final TaskController taskController = Get.find(); // LẤY TaskController

  // --- State chung ---
  final Rx<TimeFilter> timeFilter = TimeFilter.week.obs;
  final Rx<DateTime> currentReferenceDate = DateTime.now().obs;

  // --- State và dữ liệu cho Project Chart ---
  // _allUserProjects sẽ lấy từ projectController.projects hoặc projectController.filteredProjects
  final RxList<Map<String, dynamic>> projectChartData =
      <Map<String, dynamic>>[].obs;
  final Rx<Status?> projectStatusFilter = Rxn<Status>();

  // --- State và dữ liệu cho Task Chart ---
  // _allUserTasks sẽ lấy từ taskController.tasks (cần đảm bảo tasks này là của tất cả project user tham gia)
  final RxList<Map<String, dynamic>> taskChartData =
      <Map<String, dynamic>>[].obs;
  final Rx<Status?> taskStatusFilter = Rxn<Status>();

  String get currentUserId => authController.currentUser.value!.id;

  @override
  void onInit() {
    super.onInit();
    // Lắng nghe sự thay đổi của các filter và ngày tham chiếu
    ever(timeFilter, (_) => _processAllDataForCharts());
    ever(currentReferenceDate, (_) => _processAllDataForCharts());
    ever(projectStatusFilter,
        (_) => _processProjectDataForChart()); // Chỉ xử lý lại
    ever(taskStatusFilter, (_) => _processTaskDataForChart()); // Chỉ xử lý lại

    // Lắng nghe sự thay đổi từ ProjectController và TaskController
    // Sử dụng listener thay vì ever để tránh vòng lặp nếu các controller đó cũng có ever
    projectController.projects.listen((_) {
      print(
          "AnalyticsController: Project list updated, reprocessing project chart data.");
      _processProjectDataForChart();
    });
    // Quan trọng: taskController.tasks hiện tại có thể chỉ là task của currentProject.
    // Bạn cần một cách để lấy TẤT CẢ task của TẤT CẢ project mà user tham gia.
    // Nếu taskController không cung cấp điều này, bạn cần fetch riêng trong AnalyticsController
    // hoặc sửa taskController.
    // Giả sử tạm thời taskController.tasks có thể chứa đủ dữ liệu (CẦN XEM XÉT LẠI)
    taskController.tasks.listen((_) {
      print(
          "AnalyticsController: Task list updated, reprocessing task chart data.");
      _processTaskDataForChart();
    });

    // Xử lý dữ liệu lần đầu sau khi các controller khác có thể đã onInit
    // và có dữ liệu.
    // Đảm bảo AuthController đã có currentUser
    if (authController.currentUser.value != null) {
      _processAllDataForCharts();
    } else {
      // Đợi AuthController sẵn sàng
      once(authController.currentUser, (_) {
        if (authController.currentUser.value != null) {
          _processAllDataForCharts();
        } else {
          print(
              "AnalyticsController: currentUser is still null after auth ready. Cannot process data.");
        }
      });
    }
  }

  void _processAllDataForCharts() {
    print(
        "AnalyticsController: Processing all data for charts. RefDate: ${currentReferenceDate.value}, TimeFilter: ${timeFilter.value}");
    _processProjectDataForChart();
    _processTaskDataForChart();
  }

  // ----- LOGIC CHO PROJECT CHART -----
  void _processProjectDataForChart() {
    // Lấy danh sách project từ ProjectController
    // projects.value của ProjectController là Stream<List<Project>>,
    // còn projects là RxList<Project> đã được bindStream.
    // Nên dùng projectController.projects (là RxList)
    final List<Project> allUserProjects = List<Project>.from(
        projectController.projects); // Tạo bản sao để tránh thay đổi list gốc
    print(
        "AnalyticsController: Processing ${allUserProjects.length} projects. ProjectStatusFilter: ${projectStatusFilter.value}");

    final Map<dynamic, int> tempData = {};
    final refDate = currentReferenceDate.value;

    List<Project> filteredByStatus = allUserProjects;
    if (projectStatusFilter.value != null) {
      filteredByStatus = allUserProjects
          .where((p) => p.status == projectStatusFilter.value)
          .toList();
    }
    print(
        "AnalyticsController: Projects after status filter: ${filteredByStatus.length}");

    for (var project in filteredByStatus) {
      // print("Checking project: ${project.title} with startDate: ${project.startDate}");
      if (!_isDateInRange(project.startDate, refDate, timeFilter.value)) {
        // print("Project ${project.title} IS NOT IN RANGE");
        continue;
      }
      // print("Project ${project.title} IS IN RANGE");

      dynamic key;
      switch (timeFilter.value) {
        case TimeFilter.day:
          key = project.status.name;
          break;
        case TimeFilter.week:
          key = project.startDate.weekday; // 1-7
          break;
        case TimeFilter.month:
          key = project.startDate.day; // 1-31
          break;
        case TimeFilter.year:
          key = project.startDate.month; // 1-12
          break;
      }
      tempData[key] = (tempData[key] ?? 0) + 1;
    }

    print("AnalyticsController: Project tempData: $tempData");

    projectChartData.value = tempData.entries.map((e) {
      dynamic key = e.key;
      int xValue;
      // Chuyển key thành int nếu nó là String (ví dụ status.name)
      if (key is String && timeFilter.value == TimeFilter.day) {
        xValue = Status.values.indexWhere((s) => s.name == key);
        if (xValue == -1) xValue = key.hashCode % 100; // Fallback an toàn
      } else if (key is int) {
        xValue = key;
      } else {
        xValue = 0; // Mặc định
      }
      return {'x': xValue, 'y': e.value};
    }).toList();

    projectChartData.sort((a, b) => (a['x'] as int).compareTo(b['x'] as int));
    print(
        "AnalyticsController: Processed projectChartData: ${projectChartData.value}");
    if (projectChartData.isEmpty && tempData.isNotEmpty) {
      print(
          "WARNING: projectChartData is empty but tempData was not. Check xValue mapping.");
    }
  }

  // ----- LOGIC CHO TASK CHART -----
  void _processTaskDataForChart() {
    // QUAN TRỌNG: taskController.tasks hiện tại có thể chỉ là task của currentProject trong TaskController.
    // Để thống kê TẤT CẢ task, bạn cần một nguồn dữ liệu chứa tất cả task của user.
    // Cách 1: Sửa TaskController để có một RxList<Task> allUserTasks.
    // Cách 2: AnalyticsController tự fetch TẤT CẢ task (như code cũ của AnalyticsController).
    // Cách 3 (Tạm thời để test, KHÔNG KHUYẾN KHÍCH cho production nếu taskController.tasks bị giới hạn):
    final List<Task> allUserTasksToProcess;

    // GIẢ ĐỊNH: taskController.tasks CHỨA TẤT CẢ TASK CẦN THỐNG KÊ.
    // NẾU KHÔNG ĐÚNG, BẠN CẦN THAY ĐỔI LOGIC NÀY ĐỂ FETCH TẤT CẢ TASK.
    // Ví dụ: Nếu taskController.tasks chỉ là task của project đang xem, thì thống kê task sẽ sai.
    // Bạn có thể cần một hàm trong TaskController để trả về tất cả task của người dùng,
    // hoặc AnalyticsController tự fetch.

    // Để an toàn, nếu TaskController không có cách lấy tất cả task, hãy fetch riêng ở đây.
    // Tạm thời, tôi sẽ giữ logic fetch riêng cho task nếu _allUserProjects có dữ liệu.
    // Điều này có nghĩa là hàm fetch riêng cho task sẽ được ưu tiên.
    // Hoặc, nếu bạn muốn dùng taskController.tasks, hãy đảm bảo nó đúng.
    if (projectController.projects.isEmpty) {
      print(
          "AnalyticsController: No projects found, cannot process tasks effectively.");
      taskChartData.clear();
      return;
    }
    // Nếu bạn đã có danh sách allUserTasks trong AnalyticsController (ví dụ: _allUserTasks)
    // thì dùng nó. Nếu không, bạn cần fetch.
    // Dưới đây là ví dụ fetch lại, CẦN TỐI ƯU HÓA NẾU CÓ THỂ LẤY TỪ TASKCONTROLLER
    _fetchAndProcessAllTasks(); // Hàm này sẽ fetch và gọi _processThisTaskList
  }

  Future<void> _fetchAndProcessAllTasks() async {
    print(
        "AnalyticsController: Fetching all tasks for user $currentUserId based on their projects.");
    if (projectController.projects.isEmpty) {
      print(
          "AnalyticsController: No projects from ProjectController, task data will be empty.");
      _processThisTaskList([]); // Xử lý với danh sách rỗng
      return;
    }
    try {
      List<String> projectIds =
          projectController.projects.map((p) => p.id).toList();
      if (projectIds.isEmpty) {
        _processThisTaskList([]);
        return;
      }

      List<Task> tasksFromDb = [];
      for (int i = 0; i < projectIds.length; i += 10) {
        List<String> sublist = projectIds.sublist(
            i, i + 10 > projectIds.length ? projectIds.length : i + 10);
        if (sublist.isNotEmpty) {
          final querySnapshot = await FirebaseFirestore
              .instance // Dùng FirebaseFirestore trực tiếp
              .collection('tasks')
              .where('projectOwner', whereIn: sublist)
              .get();
          tasksFromDb.addAll(querySnapshot.docs.map(
              (doc) => Task.fromMap(data: doc.data() as Map<String, dynamic>)));
        }
      }
      print(
          "AnalyticsController: Fetched ${tasksFromDb.length} tasks in total.");
      _processThisTaskList(tasksFromDb);
    } catch (e) {
      print("Error fetching all tasks for analytics: $e");
      _processThisTaskList([]);
    }
  }

  void _processThisTaskList(List<Task> tasksToProcess) {
    final Map<dynamic, int> tempData = {};
    final refDate = currentReferenceDate.value;

    List<Task> filteredByStatus = tasksToProcess;
    if (taskStatusFilter.value != null) {
      filteredByStatus = tasksToProcess
          .where((t) => t.status == taskStatusFilter.value)
          .toList();
    }
    print(
        "AnalyticsController: Tasks to process after status filter: ${filteredByStatus.length}");

    for (var task in filteredByStatus) {
      // print("Checking task: ${task.title} with startDate: ${task.startDate}");
      if (!_isDateInRange(task.startDate, refDate, timeFilter.value)) {
        // print("Task ${task.title} IS NOT IN RANGE");
        continue;
      }
      // print("Task ${task.title} IS IN RANGE");

      dynamic key;
      switch (timeFilter.value) {
        case TimeFilter.day:
          key = task.status.name;
          break;
        case TimeFilter.week:
          key = task.startDate.weekday;
          break;
        case TimeFilter.month:
          key = task.startDate.day;
          break;
        case TimeFilter.year:
          key = task.startDate.month;
          break;
      }
      tempData[key] = (tempData[key] ?? 0) + 1;
    }
    print("AnalyticsController: Task tempData: $tempData");

    taskChartData.value = tempData.entries.map((e) {
      dynamic key = e.key;
      int xValue;
      if (key is String && timeFilter.value == TimeFilter.day) {
        xValue = Status.values.indexWhere((s) => s.name == key);
        if (xValue == -1) xValue = key.hashCode % 100;
      } else if (key is int) {
        xValue = key;
      } else {
        xValue = 0;
      }
      return {'x': xValue, 'y': e.value};
    }).toList();
    taskChartData.sort((a, b) => (a['x'] as int).compareTo(b['x'] as int));
    print(
        "AnalyticsController: Processed taskChartData: ${taskChartData.value}");
  }

  // ----- Helper Functions -----
  bool _isDateInRange(DateTime dateToCheck, DateTime ref, TimeFilter filter) {
    // ... (giữ nguyên hàm này)
    switch (filter) {
      case TimeFilter.day:
        return dateToCheck.year == ref.year &&
            dateToCheck.month == ref.month &&
            dateToCheck.day == ref.day;
      case TimeFilter.week:
        DateTime startOfWeek = ref.subtract(Duration(days: ref.weekday - 1));
        DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
        return !dateToCheck.isBefore(DateTime(
                startOfWeek.year, startOfWeek.month, startOfWeek.day)) &&
            !dateToCheck.isAfter(DateTime(
                endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59));
      case TimeFilter.month:
        return dateToCheck.year == ref.year && dateToCheck.month == ref.month;
      case TimeFilter.year:
        return dateToCheck.year == ref.year;
    }
  }

  void changeTimeFilter(TimeFilter newFilter) {
    if (timeFilter.value != newFilter) {
      print("AnalyticsController: TimeFilter changed to $newFilter");
      timeFilter.value = newFilter;
      // _processAllDataForCharts(); // ever sẽ tự gọi _fetchAllData, rồi _processAllDataForCharts
    }
  }

  void navigateDate(bool forward) {
    DateTime oldDate = currentReferenceDate.value;
    DateTime newDate = currentReferenceDate.value;
    int amount = forward ? 1 : -1;
    switch (timeFilter.value) {
      case TimeFilter.day:
        newDate = newDate.add(Duration(days: amount));
        break;
      case TimeFilter.week:
        newDate = newDate.add(Duration(days: 7 * amount));
        break;
      case TimeFilter.month:
        // Cẩn thận khi cộng/trừ tháng để tránh lỗi ngày không hợp lệ (ví dụ 31/1 qua 28/2)
        newDate = DateTime(newDate.year, newDate.month + amount, newDate.day);
        // Kiểm tra và điều chỉnh nếu ngày không hợp lệ
        if (newDate.month !=
            ((oldDate.month + amount) % 12 == 0
                ? 12
                : (oldDate.month + amount) % 12)) {
          // Chú ý xử lý tháng 12 qua tháng 1
          newDate = DateTime(newDate.year, newDate.month,
              0); // Lấy ngày cuối của tháng trước đó
        }
        break;
      case TimeFilter.year:
        newDate = DateTime(newDate.year + amount, newDate.month, newDate.day);
        if (newDate.month != oldDate.month) {
          // Nếu nhảy qua tháng khác (ví dụ 29/2 năm nhuận qua năm không nhuận)
          newDate = DateTime(newDate.year, newDate.month, 0);
        }
        break;
    }
    print("AnalyticsController: Navigated date from $oldDate to $newDate");
    currentReferenceDate.value = newDate;
    // _processAllDataForCharts(); // ever sẽ tự gọi
  }

  void changeProjectStatusFilter(Status? status) {
    if (projectStatusFilter.value != status) {
      print("AnalyticsController: Project status filter changed to $status");
      projectStatusFilter.value = status;
      // _processProjectDataForChart(); // ever sẽ tự gọi
    }
  }

  void changeTaskStatusFilter(Status? status) {
    if (taskStatusFilter.value != status) {
      print("AnalyticsController: Task status filter changed to $status");
      taskStatusFilter.value = status;
      // _processTaskDataForChart(); // ever sẽ tự gọi
    }
  }

  String getXAxisLabel(int xIntValue, TimeFilter currentFilter) {
    // ... (giữ nguyên hàm này, nhưng đảm bảo nó khớp với cách key được map thành int xValue)
    switch (currentFilter) {
      case TimeFilter.day:
        // Nếu xIntValue là index của Status
        if (xIntValue >= 0 && xIntValue < Status.values.length) {
          // Cần kiểm tra xem key có thực sự là status name không
          // Vì xValue có thể là hashcode nếu key ban đầu là string không map được
          // Cách tốt nhất là đảm bảo key luôn được map sang index của Status
          return Status.values[xIntValue].name.substring(
              0, min(Status.values[xIntValue].name.length, 3)); // Tên viết tắt
        }
        return xIntValue.toString(); // Fallback
      case TimeFilter.week: // 1 (Thứ 2) -> 7 (CN)
        const days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
        // xIntValue giờ là weekday (1-7)
        if (xIntValue >= 1 && xIntValue <= days.length) {
          return days[xIntValue - 1];
        }
        return xIntValue.toString(); // Fallback
      case TimeFilter.month: // Ngày trong tháng (1-31)
        return xIntValue.toString();
      case TimeFilter.year: // Tháng trong năm (1-12)
        return 'T${xIntValue.toString()}';
      default:
        return xIntValue.toString();
    }
  }
}
