import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:book_keeper/model/transactions.dart';

class TransactionsDatabase {
  static final TransactionsDatabase instance = TransactionsDatabase._init();
  static Database? _database;
  TransactionsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('transactions.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';

    await db.execute('''
CREATE TABLE $tableTransactions (
  ${TransactionFields.id} $idType,
  ${TransactionFields.category} $textType,
  ${TransactionFields.description} $textType,
  ${TransactionFields.amount} $integerType,
  ${TransactionFields.time} $textType,
  ${TransactionFields.income} $boolType
  )    
''');
  }

  Future<Transactions> create(Transactions transaction) async {
    final db = await instance.database;

    final id = await db.insert(tableTransactions, transaction.toJson());
    return transaction.copy(id: id);
  }

  Future<List<Transactions>> readAllTransactions() async {
    final db = await instance.database;

    const orderBy = '${TransactionFields.time} DESC';

    final result = await db.query(tableTransactions, orderBy: orderBy);

    return result.map((json) => Transactions.fromJson(json)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableTransactions,
      where: '${TransactionFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
