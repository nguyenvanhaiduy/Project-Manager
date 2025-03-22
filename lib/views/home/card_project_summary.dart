import 'package:flutter/material.dart';

class CardProjectSummary extends StatelessWidget {
  const CardProjectSummary(
      {super.key,
      required this.color,
      required this.status,
      required this.amount});
  final MaterialColor color;
  final String status;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 200,
        height: 120,
        decoration: BoxDecoration(color: color),
        child: Stack(
          children: [
            Positioned.fill(
                child: CustomPaint(
              painter: WavePainter(color: color),
            )),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$amount',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              top: 12,
              right: 12,
              child: Icon(
                Icons.more_horiz,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final MaterialColor color;

  WavePainter({super.repaint, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color[400]!
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, size.height * 0.8); // Hạ sóng xuống thấp hơn
    path.quadraticBezierTo(size.width * 0.15, size.height * 0.8,
        size.width * 0.3, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.45, size.height * 0.6,
        size.width * 0.6, size.height * 0.75);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.9, size.width, size.height * 0.7);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
