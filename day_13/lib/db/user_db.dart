import 'package:day_13/models/userModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserDB {
  static final UserDB db = UserDB();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await openDb();
    return _database!;
  }

  Future openDb() async {
    // 獲取我們的應用程序目錄的位置。這是我們應用程序文件的存儲位置，並且僅存儲我們的應用程序文件。
    // 當應用被刪除時，此目錄中的文件也會被刪除。
    return await openDatabase(join(await getDatabasesPath(), "my.db"),
        version: 1,
        onOpen: (db) async {}, onCreate: (Database db, int version) async {
      // Create the user table
      await db.execute(
          "CREATE TABLE user(id INTEGER PRIMARY KEY autoincrement,firstName TEXT,lastName TEXT,time Text)");
    });
  }

  Future insertUserData(UserModel model) async {
    final db = await database;
    return db.insert('user', model.toMap());
  }

  Future updateUser(UserModel model) async {
    final db = await database;
    return db
        .update('user', model.toMap(), where: "id = ?", whereArgs: [model.id]);
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return db.delete('user', where: "id = ?", whereArgs: [id]);
  }

  Future<List<UserModel>> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user');
    List<UserModel> list = maps.isNotEmpty
        ? maps.map((note) => UserModel.fromMap(note)).toList()
        : [];

    return list;
  }

  Future close() async => db.close();
}
