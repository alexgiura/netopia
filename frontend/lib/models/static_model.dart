class StaticData {
  String name;

  StaticData({
    required this.name,
  });

  StaticData.empty() : name = '';
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StaticData &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
