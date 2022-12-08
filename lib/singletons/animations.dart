import 'package:flutter/material.dart';
import 'package:poulp/singletons/dimensions.dart';

class SwapAnimations {
  Duration successDuration = const Duration(milliseconds: 200);
  Duration failDuration = const Duration(milliseconds: 100);
  Duration get failTotalDuration => failDuration * 2;
}

class FallAnimations {
  Duration duration = const Duration(milliseconds: 300);
  Offset get offset => Offset(0, (dimensions.tileHeight + dimensions.tileMargin).toDouble());
}

SwapAnimations swapAnimations = SwapAnimations();
FallAnimations fallAnimations = FallAnimations();
