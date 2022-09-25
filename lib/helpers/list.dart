import 'package:flutter/foundation.dart';

extension ListSafe<E> on List<E> {
  E? safeElementAt(int? index) {
    if (index == null || index < 0 || length <= index) {
      return null;
    }
    return elementAt(index);
  }
}

extension ListSwapper<E> on List<E> {
  void moveEnd(int index) {
    if (index < 0 || length < index) {
      if (kDebugMode) print('bad index $index for length $length');
      return;
    }

    E temp = elementAt(index);
    removeAt(index);
    add(temp);
  }

  void swap(int indexA, int indexB) {
    if (indexA < 0 || length < indexA || indexB < 0 || length < indexB) {
      if (kDebugMode) print('bad indexs A $indexA B $indexB');
      return;
    }

    E itemA = this[indexA];
    E itemB = this[indexB];
    removeAt(indexA);
    insert(indexA, itemB);
    removeAt(indexB);
    insert(indexB, itemA);
  }
}

extension ListMapper<E> on List<E> {
  // Iterable<T> mapI<T>(T Function(E e, int index) toElement) {
  //   return asMap().entries.map((entry) => toElement(entry.value, entry.key));
  // }

  List<T> mapI<T>(T Function(E e, int index) toElement) {
    List<T> list = [];
    for (int index = 0; index < length; index++) {
      list.add(toElement(elementAt(index), index));
    }
    return list;
  }
}
