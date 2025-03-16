import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/tag/tag_config_controller.dart';

class ItemTag extends StatelessWidget {
  ItemTag({super.key, required this.index});
  final int index;
  final TagConfigController tagConfigController = Get.find();

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: IntrinsicWidth(
        child: TextFormField(
            textAlign: TextAlign.center,
            controller: tagConfigController.tagEdittingController[index],
            autovalidateMode: AutovalidateMode.always,
            cursorHeight: 15,
            maxLength: 20,
            onTap: () {
              tagConfigController.isValids[index].value =
                  formKey.currentState!.validate();
            },
            onChanged: (value) {
              tagConfigController.isValids[index].value =
                  formKey.currentState!.validate();
            },
            validator: (value) {
              if (value != null && value.isEmpty) {
                return "Tag can't be empty";
              }

              if (value!.length > 20) {
                return 'Tên tag không được quá 20 ký tự';
              }

              bool isDuplicate = tagConfigController.tagEdittingController
                      .where((controller) =>
                          controller.text.trim() == value.trim() &&
                          tagConfigController
                              .tagConfirmed[tagConfigController
                                  .tagEdittingController
                                  .indexOf(controller)]
                              .value)
                      .length >
                  1;
              if (isDuplicate) return "Duplicate tag";
              return null;
            },
            decoration: InputDecoration(
              isCollapsed:
                  true, // bỏ toàn bộ kich thước mặc định của textformfielf
              constraints: const BoxConstraints(minWidth: 40),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 4, // Giảm chiều cao (mặc định là 16)
                horizontal: 12,
              ),
              counterText: "",
              border: ShaderMaskBorder(),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
            )),
      ),
    );
  }
}

class ShaderMaskBorder extends InputBorder {
  @override
  InputBorder copyWith({BorderSide? borderSide}) {
    return ShaderMaskBorder();
  }

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(2);

  @override
  bool get isOutline => true;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(40)));
  }

  @override
  void paint(Canvas canvas, Rect rect,
      {double? gapStart,
      double? gapExtent,
      double? gapPercentage = 0.0,
      TextDirection? textDirection}) {
    final Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.blue, Colors.purple], // Gradient màu viền
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final RRect outer = RRect.fromRectAndRadius(rect, Radius.circular(40));
    canvas.drawRRect(outer, paint);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    // TODO: implement getInnerPath
    throw UnimplementedError();
  }

  @override
  ShapeBorder scale(double t) {
    // TODO: implement scale
    throw UnimplementedError();
  }
}
