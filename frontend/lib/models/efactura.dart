class EFactura {
  String? status;
  String? errorMessage;

  EFactura({
    this.status,
    this.errorMessage,
  });

  EFactura.empty()
      : status = null,
        errorMessage = null;

  factory EFactura.fromJson(Map<String, dynamic> json) {
    return EFactura(
      status: json['status'],
      errorMessage: json['error_message'],
    );
  }
}
