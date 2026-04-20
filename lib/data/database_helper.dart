import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/order.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'laundry.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerName TEXT NOT NULL,
        phoneNumber TEXT NOT NULL,
        serviceType TEXT NOT NULL,
        numberOfItems INTEGER NOT NULL,
        pricePerItem REAL NOT NULL,
        totalPrice REAL NOT NULL,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertOrder(LaundryOrder order) async {
    final db = await database;
    final id = await db.insert('orders', order.toMap());
    return id;
  }

  Future<List<LaundryOrder>> getAllOrders() async {
    final db = await database;
    final result = await db.query('orders', orderBy: 'createdAt DESC');
    return result.map((map) => LaundryOrder.fromMap(map)).toList();
  }

  Future<int> updateOrderStatus(int id, String status) async {
    final db = await database;
    return await db.update(
      'orders',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteOrder(int id) async {
    final db = await database;
    return await db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }
}