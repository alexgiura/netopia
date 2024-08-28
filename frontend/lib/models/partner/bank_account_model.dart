class BankAccount {
  String? bank;
  String? iban;

  BankAccount({
    this.bank,
    this.iban,
  });

  BankAccount.empty()
      : bank = null,
        iban = null;

  BankAccount copyWith({
    String? bank,
    String? iban,
  }) {
    return BankAccount(
      bank: bank ?? this.bank,
      iban: iban ?? this.iban,
    );
  }

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      bank: json['bank'],
      iban: json['iban'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'bank': bank,
      'iban': iban,
    };
  }
}
