part of 'board.bloc.dart';

abstract class BoardEvent {}

class BoardReady extends BoardEvent {}

class InsertNewBoxes extends BoardEvent {}

class RemoveBoxes extends BoardEvent {}

class BoxSwapStart extends BoardEvent {
  BoxSwapStart(this.position);

  final Offset position;
}

class BoxSwapUpdate extends BoardEvent {
  BoxSwapUpdate(this.position, this.delta);

  final Offset position;
  final Offset delta;
}

class BoxSwapEnd extends BoardEvent {}

class BoardReset extends BoardEvent {}
