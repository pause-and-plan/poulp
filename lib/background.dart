import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Align(
        alignment: Alignment.topLeft,
        child: CustomPaint(painter: BackgroundPaths(), child: SizedBox(width: size.width, height: size.height)));
  }
}

class BackgroundPaths extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    // Path number 1

    paint.color = const Color(0xff5CD7D4);
    path = Path();
    path.lineTo(0, 0);
    path.cubicTo(0, 0, size.width, 0, size.width, 0);
    path.cubicTo(size.width, 0, size.width, size.height, size.width, size.height);
    path.cubicTo(size.width, size.height, 0, size.height, 0, size.height);
    path.cubicTo(0, size.height, 0, 0, 0, 0);
    path.cubicTo(0, 0, 0, 0, 0, 0);
    canvas.drawPath(path, paint);

    // Path number 2

    paint.color = const Color(0xff52B4CE);
    path = Path();
    path.lineTo(0, size.height * 0.1);
    path.cubicTo(0, size.height * 0.1, size.width * 0.05, size.height * 0.13, size.width * 0.22, size.height * 0.1);
    path.cubicTo(size.width * 0.39, size.height * 0.07, size.width * 0.38, size.height * 0.08, size.width * 0.49,
        size.height * 0.1);
    path.cubicTo(size.width * 0.59, size.height * 0.11, size.width * 0.61, size.height * 0.12, size.width * 0.74,
        size.height * 0.1);
    path.cubicTo(size.width * 0.88, size.height * 0.08, size.width, size.height * 0.1, size.width, size.height * 0.1);
    path.cubicTo(size.width, size.height * 0.1, size.width, size.height, size.width, size.height);
    path.cubicTo(size.width, size.height, 0, size.height, 0, size.height);
    path.cubicTo(0, size.height, 0, size.height * 0.1, 0, size.height * 0.1);
    path.cubicTo(0, size.height * 0.1, 0, size.height * 0.1, 0, size.height * 0.1);
    canvas.drawPath(path, paint);

    // Path number 3

    paint.color = const Color(0xff33588D);
    path = Path();
    path.lineTo(0, size.height * 0.26);
    path.cubicTo(0, size.height * 0.26, size.width * 0.12, size.height / 4, size.width * 0.12, size.height / 4);
    path.cubicTo(
        size.width * 0.12, size.height / 4, size.width / 4, size.height * 0.23, size.width * 0.38, size.height / 4);
    path.cubicTo(size.width * 0.52, size.height * 0.26, size.width * 0.51, size.height * 0.27, size.width * 0.66,
        size.height / 4);
    path.cubicTo(
        size.width * 0.66, size.height / 4, size.width * 0.75, size.height * 0.23, size.width * 0.85, size.height / 4);
    path.cubicTo(size.width * 0.95, size.height * 0.27, size.width, size.height / 4, size.width, size.height / 4);
    path.cubicTo(size.width, size.height / 4, size.width, size.height, size.width, size.height);
    path.cubicTo(size.width, size.height, 0, size.height, 0, size.height);
    path.cubicTo(0, size.height, 0, size.height * 0.26, 0, size.height * 0.26);
    path.cubicTo(0, size.height * 0.26, 0, size.height * 0.26, 0, size.height * 0.26);
    canvas.drawPath(path, paint);

    // Path number 4

    paint.color = const Color(0xff1C2550);
    path = Path();
    path.lineTo(0, size.height * 0.87);
    path.cubicTo(0, size.height * 0.87, size.width * 0.15, size.height * 0.89, size.width / 4, size.height * 0.87);
    path.cubicTo(size.width * 0.35, size.height * 0.85, size.width * 0.37, size.height * 0.85, size.width / 2,
        size.height * 0.87);
    path.cubicTo(size.width * 0.63, size.height * 0.89, size.width * 0.64, size.height * 0.89, size.width * 0.75,
        size.height * 0.87);
    path.cubicTo(size.width * 0.86, size.height * 0.85, size.width, size.height * 0.87, size.width, size.height * 0.87);
    path.cubicTo(size.width, size.height * 0.87, size.width, size.height, size.width, size.height);
    path.cubicTo(size.width, size.height, 0, size.height, 0, size.height);
    path.cubicTo(0, size.height, 0, size.height * 0.87, 0, size.height * 0.87);
    path.cubicTo(0, size.height * 0.87, 0, size.height * 0.87, 0, size.height * 0.87);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
