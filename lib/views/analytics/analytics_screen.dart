import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/controllers/analytics/analytics_controller.dart';
import 'package:project_manager/models/project.dart'; // Để dùng enum Status
// Import AnalyticsController

class AnalyticsScreen extends StatelessWidget {
  AnalyticsScreen({super.key}) {
    // Đảm bảo controller được khởi tạo
    // Nếu bạn dùng Get.put ở một nơi khác (ví dụ trong binding), không cần dòng này
    Get.put(AnalyticsController());
  }

  final AnalyticsController controller = Get.put(AnalyticsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thống kê tổng quan'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildGlobalFilters(),
            const SizedBox(height: 16),
            Expanded(
              child: OrientationBuilder(
                builder: (context, orientation) {
                  if (orientation == Orientation.portrait ||
                      MediaQuery.of(context).size.width < 600) {
                    // Điều kiện cho layout dọc
                    return Column(
                      children: [
                        Expanded(
                          child: _buildChartSection(
                            title: "Thống kê Dự án".tr,
                            chartType: ChartType.project,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: _buildChartSection(
                            title: "Thống kê Công việc".tr,
                            chartType: ChartType.task,
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Layout ngang
                    return Row(
                      children: [
                        Expanded(
                          child: _buildChartSection(
                            title: "Thống kê Dự án".tr,
                            chartType: ChartType.project,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildChartSection(
                            title: "Thống kê Công việc".tr,
                            chartType: ChartType.task,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlobalFilters() {
    return Obx(() => Column(
          children: [
            // Date Navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => controller.navigateDate(false),
                ),
                Text(
                  _formatReferenceDate(controller.currentReferenceDate.value,
                      controller.timeFilter.value),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => controller.navigateDate(true),
                ),
              ],
            ),
            // Time Filter
            PopupMenuButton<TimeFilter>(
              onSelected: (TimeFilter result) =>
                  controller.changeTimeFilter(result),
              itemBuilder: (BuildContext context) => TimeFilter.values
                  .map((filter) => PopupMenuItem<TimeFilter>(
                        value: filter,
                        child: Text(_getTimeFilterName(filter)),
                      ))
                  .toList(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_getTimeFilterName(controller.timeFilter.value)),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildChartSection(
      {required String title, required ChartType chartType}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                // Filter theo Status cho từng biểu đồ
                PopupMenuButton<Status?>(
                  tooltip: "Lọc theo trạng thái".tr,
                  onSelected: (Status? result) {
                    if (chartType == ChartType.project) {
                      controller.changeProjectStatusFilter(result);
                    } else {
                      controller.changeTaskStatusFilter(result);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    List<PopupMenuItem<Status?>> items = [
                      PopupMenuItem<Status?>(
                        value: null, // Giá trị cho "Tất cả"
                        child: Text("Tất cả trạng thái".tr),
                      )
                    ];
                    items.addAll(
                        Status.values.map((status) => PopupMenuItem<Status?>(
                              value: status,
                              child: Text(
                                  status.name.tr), // Hoặc tên hiển thị đẹp hơn
                            )));
                    return items;
                  },
                  child: Container(
                    // Button hiển thị
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Obx(() {
                      final currentStatus = chartType == ChartType.project
                          ? controller.projectStatusFilter.value
                          : controller.taskStatusFilter.value;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(currentStatus?.name.tr ?? "Tất cả".tr,
                              style: TextStyle(fontSize: 12)),
                          Icon(Icons.arrow_drop_down, size: 18),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final chartData = chartType == ChartType.project
                    ? controller.projectChartData
                    : controller.taskChartData;
                print("Project Data: ${controller.projectChartData}");
                print("Task Data: ${controller.taskChartData}");
                if (chartData.isEmpty) {
                  return Center(child: Text("Không có dữ liệu thống kê.".tr));
                }

                List<BarChartGroupData> barGroups = chartData.map((data) {
                  return BarChartGroupData(
                    x: (data['x'] is int || data['x'] is double)
                        ? (data['x'] as num).toInt()
                        : 0, // Đảm bảo x là int
                    barRods: [
                      BarChartRodData(
                          toY: (data['y'] as num).toDouble(),
                          color: _getColorForChart(
                              chartType, data['x']), // Màu sắc tùy chỉnh
                          width: 16,
                          borderRadius: BorderRadius.circular(4)),
                    ],
                  );
                }).toList();

                return BarChart(
                  BarChartData(
                    barGroups: barGroups,
                    alignment: BarChartAlignment.spaceAround,
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            // `value` ở đây là `x` từ `BarChartGroupData`
                            // Nó đã được controller xử lý thành key (int, string,...)
                            // Chúng ta cần chuyển nó thành label dựa trên TimeFilter hiện tại
                            return SideTitleWidget(
                              // axisSide: meta.axisSide,
                              meta: meta,
                              space: 4,
                              child: Text(
                                  controller.getXAxisLabel(value.toInt(),
                                      controller.timeFilter.value),
                                  style: const TextStyle(fontSize: 10)),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          // getTitlesWidget: default thuế, // Có thể tùy chỉnh nếu muốn
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return const FlLine(
                              color: Colors.grey, strokeWidth: 0.3);
                        }),
                    barTouchData: BarTouchData(
                      enabled: true, // Cho phép tương tác
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) =>
                            Colors.blueGrey.withOpacity(0.8),
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final String titleText = controller.getXAxisLabel(
                              group.x, controller.timeFilter.value);
                          return BarTooltipItem(
                            '$titleText\n',
                            const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                text: rod.toY.toStringAsFixed(0),
                                style: const TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  String _formatReferenceDate(DateTime date, TimeFilter filter) {
    switch (filter) {
      case TimeFilter.day:
        return DateFormat.yMd().format(date); // "7/10/2023"
      case TimeFilter.week:
        DateTime startOfWeek = date.subtract(Duration(days: date.weekday - 1));
        DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
        return "${DateFormat.d().format(startOfWeek)} - ${DateFormat.yMd().format(endOfWeek)}"; // "7 - 13/7/2023"
      case TimeFilter.month:
        return DateFormat.yMMMM().format(date); // "Tháng Bảy 2023"
      case TimeFilter.year:
        return DateFormat.y().format(date); // "2023"
    }
  }

  String _getTimeFilterName(TimeFilter filter) {
    switch (filter) {
      case TimeFilter.day:
        return "Theo Ngày".tr;
      case TimeFilter.week:
        return "Theo Tuần".tr;
      case TimeFilter.month:
        return "Theo Tháng".tr;
      case TimeFilter.year:
        return "Theo Năm".tr;
    }
  }

  Color _getColorForChart(ChartType type, dynamic xValue) {
    // Tùy chỉnh màu sắc dựa trên loại biểu đồ và giá trị x (ví dụ: status)
    if (type == ChartType.project && xValue is String) {
      // Giả sử xValue là status.name
      if (xValue == Status.completed.name) return Colors.green;
      if (xValue == Status.inProgress.name) return Colors.orange;
      if (xValue == Status.notStarted.name) return Colors.grey;
    }
    // Màu mặc định hoặc màu cho biểu đồ task
    // Lấy một màu từ một danh sách màu dựa trên hash của xValue để có màu khác nhau
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.amber
    ];
    return colors[(xValue.hashCode % colors.length).abs()];
  }
}
