part of 'board.bloc.dart';

enum BoardStatus {
  initial,
  ready,
}

class BoardState extends Equatable {
  const BoardState(this.status, this.boxes, this.score, this.movesLeft);

  factory BoardState.initial(int moveLeft) => BoardState(BoardStatus.initial, const [], 0, moveLeft);
  factory BoardState.ready(List<Box> boxes, int score, int moveLeft) {
    return BoardState(BoardStatus.ready, toBoxStateList(boxes), score, moveLeft);
  }

  final BoardStatus status;
  final List<BoxState> boxes;
  final int score;
  final int movesLeft;

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
