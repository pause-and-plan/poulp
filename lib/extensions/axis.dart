import 'package:flutter/material.dart';

extension AxisHelper on Axis {
  bool get isVertical => this == Axis.vertical;
  bool get isHorizontal => this == Axis.horizontal;
}
