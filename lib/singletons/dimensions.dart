import 'dart:math';
import 'dart:ui';

class Dimensions {
  int rows = 9;
  int cols = 9;
  int tileMargin = 2;
  int tileWidth = 40;
  int tileHeight = 44;
  double gridPadding = 2;
  double tilePositionX(int x) => x * tileTranslationX;
  double tilePositionY(int y) => y * tileTranslationY;
  Rect tileContainer(Point<int> coordinate) => Rect.fromLTWH(
        tilePositionX(coordinate.x),
        tilePositionY(coordinate.y),
        tileWidth.toDouble(),
        tileHeight.toDouble(),
      );
  Size get tileSize => Size(tileWidth.toDouble(), tileHeight.toDouble());
  double get tileTranslationX => (tileWidth + tileMargin).toDouble();
  double get tileTranslationY => (tileHeight + tileMargin).toDouble();
  double get gridWidth => ((tileWidth * cols) + (tileMargin * (cols - 1)) + gridPadding * 2).toDouble();
  double get gridHeight => ((tileHeight * rows) + (tileMargin * (rows - 1)) + gridPadding * 2).toDouble();
  Rect get gridRect => Rect.fromLTWH(0, 0, gridWidth, gridHeight);
}

Dimensions dimensions = Dimensions();
