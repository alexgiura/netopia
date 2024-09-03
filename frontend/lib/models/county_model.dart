class County {
  final String name;
  final String code;

  County({
    required this.name,
    required this.code,
  });

  factory County.fromJson(Map<String, dynamic> json) {
    return County(
      name: json['nume'],
      code: json['auto'],
    );
  }
}
