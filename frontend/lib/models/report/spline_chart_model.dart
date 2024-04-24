class SplineChartData {
  /// Holds the datapoint values like x, y, etc.,
  SplineChartData({
    this.x,
    this.y,
    this.secondY,
  });

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final double? y;

  /// Holds y value of the datapoint(for 2nd series)
  final double? secondY;

  factory SplineChartData.fromJson(Map<String, dynamic> json) {
    return SplineChartData(
      x: json['x'],
      y: json['y'],
      secondY: json['second_y'],
    );
  }
}
