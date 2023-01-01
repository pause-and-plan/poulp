import 'package:flutter/material.dart';
import 'package:poulp/singletons/dimensions.dart';

class SwapAnimations {
  static const Duration successDuration = Duration(milliseconds: 200);
  static const Duration failDuration = Duration(milliseconds: 200);
}

class FallAnimations {
  static const Duration duration = Duration(milliseconds: 140);
  Offset get offset => Offset(0, (dimensions.tileHeight + dimensions.tileMargin).toDouble());
}

class ExplodeAnimations {
  static const Duration duration = Duration(milliseconds: 200);
  double scale = 0.1;
}

SwapAnimations swapAnimations = SwapAnimations();
FallAnimations fallAnimations = FallAnimations();
ExplodeAnimations explodeAnimations = ExplodeAnimations();
