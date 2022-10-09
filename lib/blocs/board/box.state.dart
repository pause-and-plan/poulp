part of 'board.bloc.dart';

class BoxState extends Equatable {
  const BoxState(
    this.key,
    this.color,
    this.left,
    this.top,
    this.fallDuration,
    this.scale,
    this.scaleDuration,
    this.shouldCollapse,
    this.assetPath,
  );

  final Key key;
  final Color color;
  final double left;
  final double top;
  final Duration fallDuration;
  final double scale;
  final Duration scaleDuration;
  final bool shouldCollapse;
  final String assetPath;

  @override
  List<Object> get props => [
        key,
        color,
        left,
        top,
        fallDuration,
        scale,
        scaleDuration,
        shouldCollapse,
        assetPath,
      ];
}
