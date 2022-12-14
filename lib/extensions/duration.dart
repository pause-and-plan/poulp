extension DurationHelper on Duration {
  operator *(int multiplier) {
    return Duration(milliseconds: inMilliseconds * multiplier);
  }
}
