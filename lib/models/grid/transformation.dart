import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:poulp/singletons/animations.dart';

enum Transformations { swapSuccess, swapFailure, fall, explode }

class Transformation extends Equatable {
  const Transformation.swapSuccess(this.translation)
      : type = Transformations.swapSuccess,
        duration = SwapAnimations.successDuration;
  const Transformation.swapFailure(this.translation)
      : type = Transformations.swapFailure,
        duration = SwapAnimations.failDuration;
  const Transformation.fall(this.translation)
      : type = Transformations.fall,
        duration = FallAnimations.duration;
  const Transformation.explode()
      : type = Transformations.explode,
        duration = ExplodeAnimations.duration,
        translation = null;

  final Transformations type;
  final Duration duration;
  final Point<int>? translation;

  @override
  List<Object?> get props => [type, duration, translation];
}

extension TransformationsHelpers on Map<Key, Transformation> {}
