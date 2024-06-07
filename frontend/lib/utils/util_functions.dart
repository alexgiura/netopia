String formatNumber(double value) {
  if ((value * 1000) % 10 != 0) {
    return value.toStringAsFixed(3);
  } else {
    return value.toStringAsFixed(2);
  }
}
