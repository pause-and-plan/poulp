import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Translation extends Equatable {
  const Translation.initial()
      : offset = Offset.zero,
        duration = Duration.zero,
        revert = false;

  const Translation(this.offset, this.duration, {this.revert = false});

  final Offset offset;
  final Duration duration;
  final bool revert;

  @override
  List<Object> get props => [offset, duration];
}

class Scale extends Equatable {
  const Scale.initial()
      : value = 1,
        duration = Duration.zero;

  const Scale(this.value, this.duration);

  final double value;
  final Duration duration;

  @override
  List<Object> get props => [value, duration];
}

class Transformable extends Equatable {
  static Transformable initial() {
    return Transformable(Rect.zero, DateTime.now());
  }

  static Transformable fromRect(Rect box) {
    return Transformable(box, DateTime.now());
  }

  const Transformable(
    this.box,
    this.createdAt, {
    this.translation = const Translation.initial(),
    this.scaling = const Scale.initial(),
  });

  Transformable flatten() => Transformable(box.shift(translation.offset), DateTime.now());
  Transformable translate(Translation translation) => Transformable(box, DateTime.now(), translation: translation);
  Transformable scale(Scale scaling) => Transformable(box, DateTime.now(), scaling: scaling);

  final Rect box;

  // transformations
  final Translation translation;
  final Scale scaling;
  final DateTime createdAt;

  // getters
  Rect get translationStart => box;
  Rect get translationEnd => box.shift(translation.offset);
  double get left => box.shift(translation.offset).left;
  double get top => box.shift(translation.offset).top;

  Offset get leftCollision => box.center.translate(-box.width, 0);
  Offset get topCollision => box.center.translate(0, -box.height);
  Offset get rightCollision => box.center.translate(box.width, 0);
  Offset get bottomCollision => box.center.translate(0, box.height);

  Offset sideCollisionFromDelta(Offset delta) {
    if (delta.dx.abs() > delta.dy.abs()) {
      return delta.dx.isNegative ? leftCollision : rightCollision;
    } else {
      return delta.dy.isNegative ? topCollision : bottomCollision;
    }
  }

  @override
  List<Object> get props => [box, translation, scaling];
}
