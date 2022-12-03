import 'package:flutter/material.dart';

class Transformable {
  Transformable(this.size, this.position, this.scale, this.duration, this.translate);
  Transformable.fromSize(this.size);

  clone() => Transformable(size, position, scale, duration, translate);

  // current state
  Size size;
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

  Offset topCollision() {
    return Offset(left + (size.width * 0.5), top - (size.height * 0.5));
  }

  Offset bottomCollision() {
    return Offset(left + (size.width * 0.5), top + (size.height * 1.5));
  }

  Offset leftCollision() {
    return Offset(left - (size.width * 0.5), top + (size.height * 0.5));
  }

  Offset rightCollision() {
    return Offset(left + (size.width * 1.5), top + (size.height * 0.5));
  }
}
