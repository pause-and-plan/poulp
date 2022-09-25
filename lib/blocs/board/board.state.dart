part of 'board.bloc.dart';

enum BoardStatus {
  initial,
  ready,
  animate_crush,
  animate_gravity,
}

class BoardState extends Equatable {
  const BoardState(
    this.status,
    this.boxes,
  );

  factory BoardState.initial() => const BoardState(BoardStatus.initial, []);
  factory BoardState.ready(List<Box> boxes) {
    List<BoxState> list =
        boxes.map((e) => BoxState(e.key, e.color, e.left, e.top, e.fallDuration, e.scale, e.scaleDuration)).toList();
    return BoardState(BoardStatus.ready, list);
  }

  final BoardStatus status;
  final List<BoxState> boxes;

  @override
  List<Object> get props => [status, boxes];
}
