part of 'board.bloc.dart';

enum BoardStatus {
  initial,
  ready,
}

class BoardState extends Equatable {
  const BoardState(
    this.status,
    this.boxes,
  );

  factory BoardState.initial() => const BoardState(BoardStatus.initial, []);
  factory BoardState.ready(List<Box> boxes) {
    return BoardState(BoardStatus.ready, toBoxStateList(boxes));
  }

  final BoardStatus status;
  final List<BoxState> boxes;

  static List<BoxState> toBoxStateList(List<Box> boxes) {
    return boxes
        .map((e) => BoxState(
              e.key,
              e.color,
              e.left,
              e.top,
              e.fallDuration,
              e.scale,
              e.scaleDuration,
              e.shouldCollapse,
              e.assetPath,
            ))
        .toList();
  }

  @override
  List<Object> get props => [status, boxes];
}
