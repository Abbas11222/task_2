import 'dart:async';
import 'package:sqflite/sqflite.dart';
import "package:path/path.dart" ;
import 'model.dart';


class Dbhelper{
  static final Dbhelper instance=Dbhelper.internal();
  Dbhelper.internal();
  factory Dbhelper()=>instance;

  final String table="task2table";
  final String qoute="qoute";
  final String id="id";
  final String author="author";

  static Database? _db;


  Future<Database>get database async{
    if(_db!=null){
      return _db!;
    }
    _db=await initDB();
    return _db!;

  }
  initDB() async{
    final pp= await getDatabasesPath();
    final path= join(pp,'task1');
    var mydb=openDatabase(path,version: 1,onCreate: _oncreate);
    return mydb;
  }
  FutureOr<void> _oncreate(Database db, int version) async{
    await db.execute("CREATE TABLE $table( $id INTEGER PRIMARY KEY AUTOINCREMENT,$qoute TEXT,$author Text)");
  }

  Future<int> savetask(User user) async {
    var client = await database;
    int res = await client.insert(table, user.toMap());
    return res;
  }

  Future<List> getAlltasks() async {
    var client = await database;
    var result = await client.rawQuery("SELECT * FROM $table");
    return result.toList();
  }
  Future<User?> getquesID(int id) async {
    var client = await database;
    var result = await client.rawQuery("SELECT * FROM $table WHERE $id=$id");
    if (result.isEmpty) return null;
    return User.fromMap(result.first);
  }
  Future<int> updatetask(User user) async {
    var client = await database;
    return await client.update(table, user.toMap(), where: "$id=?", whereArgs: [user.id]);
  }

  Future<int> deletebyid(int id) async {
    var client = await database;
    var result = await client.delete(table, where: "$id=?", whereArgs: [id]);
    return result;
  }



}