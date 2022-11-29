import 'package:flutter/material.dart';

class Transformable {
  Transformable(this.size);

  // current state
  Size size = Size.zero;
  Offset position = Offset.zero;

  // transformations
  double scale = 1;
  Duration duration = Duration.zero;
  Offset translate = Offset.zero;

  // getters
  double get left => position.dx + translate.dx;
  double get top => position.dy + translate.dy;

  bool isColliding(Offset event) {
    if (event.dx < left) return false;
    if (event.dx > left + size.width) return false;
    if (event.dy < top) return false;
    if (event.dy > top + size.height) return false;
    return true;
  }

  void transform({Offset? translate, Duration? duration, double? scale}) {
    if (translate != null) this.translate += translate;
    if (duration != null) this.duration += duration;
    if (scale != null) this.scale += scale;
  }

  void flatten() {
    position += translate;
    duration = Duration.zero;
  }
}
