const String tableTransactions = 'transactions';

class TransactionFields {
  static const String id = '_id';
  static const String category = 'category';
  static const String description = 'description';
  static const String amount = 'amount';
  static const String time = 'time';
  static const String income = 'income';
}

class Transactions {
  final int? id;
  final String category;
  final String description;
  final int amount;
  final DateTime createdTime;
  final bool income;

  Transactions({
    this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.createdTime,
    required this.income,
  });

  Transactions copy({
    int? id,
  }) =>
      Transactions(
        id: id ?? this.id,
        category: category,
        description: description,
        amount: amount,
        createdTime: createdTime,
        income: income,
      );

  static Transactions fromJson(Map<String, Object?> json) => Transactions(
        id: json[TransactionFields.id] as int?,
        category: json[TransactionFields.category] as String,
        description: json[TransactionFields.description] as String,
        amount: json[TransactionFields.amount] as int,
        createdTime: DateTime.parse(json[TransactionFields.time] as String),
        income: json[TransactionFields.income] == 1,
      );

  Map<String, Object?> toJson() => {
        TransactionFields.id: id,
        TransactionFields.category: category,
        TransactionFields.description: description,
        TransactionFields.amount: amount,
        TransactionFields.time: createdTime.toIso8601String(),
        TransactionFields.income: income ? 1 : 0,
      };
}
