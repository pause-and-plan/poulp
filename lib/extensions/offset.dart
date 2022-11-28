import 'package:flutter/material.dart';

extension Direction on Offset {
  Offset applyDirection(Offset direction) {
    return Offset(
      dx * direction.dx.abs(),
      dy * direction.dy.abs(),
    );
  }
}

extension Range on Offset {
  Offset sanitize(Offset min, Offset max) {
    double minX = min.dx < max.dx ? min.dx : max.dx;
    double maxX = max.dx > min.dx ? max.dx : min.dx;
    double minY = min.dy < max.dy ? min.dy : max.dy;
    double maxY = max.dy > min.dy ? max.dy : min.dy;
    double sanitizeX = dx;
    double sanitizeY = dy;

    if (dx < minX) {
      sanitizeX = minX;
    } else if (dx > maxX) {
      sanitizeX = maxX;
    }

    if (dy < minY) {
      sanitizeY = minY;
    } else if (dy > maxY) {
      sanitizeY = maxY;
    }

    return Offset(sanitizeX, sanitizeY);
  }
}
