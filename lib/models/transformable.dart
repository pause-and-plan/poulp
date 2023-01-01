// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';

// class Translation extends Equatable {
//   const Translation.initial()
//       : offset = Offset.zero,
//         duration = Duration.zero,
//         revert = false;

//   const Translation(this.offset, this.duration, {this.revert = false});

//   final Offset offset;
//   final Duration duration;
//   final bool revert;

//   Translation operator +(Translation translation) {
//     return Translation(offset + translation.offset, duration + translation.duration, revert: revert);
//   }

//   @override
//   List<Object> get props => [offset, duration];
// }

// class Scale extends Equatable {
//   const Scale.initial()
//       : value = 1,
//         duration = Duration.zero;

//   const Scale(this.value, this.duration);

//   final double value;
//   final Duration duration;

//   @override
//   List<Object> get props => [value, duration];
// }

// class Transformable extends Equatable {
//   static Transformable initial() {
//     return Transformable(Rect.zero, DateTime.now());
//   }

//   static Transformable fromRect(Rect box) {
//     return Transformable(box, DateTime.now());
//   }

//   const Transformable(
//     this.box,
//     this.createdAt, {
//     this.translation = const Translation.initial(),
//     this.scaling = const Scale.initial(),
//   });

//   Transformable flatten() => Transformable(translatedBox, DateTime.now());
//   Transformable translate(Translation translation) => Transformable(box, DateTime.now(), translation: translation);
//   Transformable scale(Scale scaling) => Transformable(box, DateTime.now(), scaling: scaling);

//   final Rect box;

//   // transformations
//   final Translation translation;
//   final Scale scaling;
//   final DateTime createdAt;

//   // getters
//   Rect get translatedBox => box.shift(translation.offset);
//   double get left => box.shift(translation.offset).left;
//   double get top => box.shift(translation.offset).top;

//   Offset get leftCollision => translatedBox.center.translate(-box.width, 0);
//   Offset get topCollision => translatedBox.center.translate(0, -box.height);
//   Offset get rightCollision => translatedBox.center.translate(box.width, 0);
//   Offset get bottomCollision => translatedBox.center.translate(0, box.height);

//   bool contains(Offset offset) => translatedBox.contains(offset);
//   bool isAbove(Offset offset) {
//     if (offset.dy < translatedBox.top) {
//       return false;
//     }
//     if (offset.dx < translatedBox.left || translatedBox.right < offset.dx) {
//       return false;
//     }
//     return true;
//   }

//   Offset sideCollisionFromDelta(Offset delta) {
//     if (delta.dx.abs() > delta.dy.abs()) {
//       return delta.dx.isNegative ? leftCollision : rightCollision;
//     } else {
//       return delta.dy.isNegative ? topCollision : bottomCollision;
//     }
//   }

//   @override
//   List<Object> get props => [box, translation, scaling];
// }
