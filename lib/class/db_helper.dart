import 'dart:math';

import 'package:sctimer/class/session_statics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  String generateRandomNumber() {
    // Generate a random 7-digit number
    int randomNumber = Random().nextInt(10000000);

    // Format the number to be 7 digits long with leading zeros
    String formattedNumber = randomNumber.toString().padLeft(7, '0');

    return formattedNumber;
  }

  static final DBHelper _instance = DBHelper.internal();

  factory DBHelper() => _instance;

  DBHelper.internal();

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'local_speed_timer.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int newVersion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Create your tables here
    await db.execute(
        'CREATE TABLE USUARIO (ID INTEGER PRIMARY KEY AUTOINCREMENT, USER TEXT, PASS TEXT, COUNTRY TEXT, STATE TEXT, WCAID TEXT, EMAIL TEXT)');
    await db.execute(
        'CREATE TABLE TIEMPOS (ID INTEGER PRIMARY KEY AUTOINCREMENT, ID_USER INT, FECHA TEXT, PUZZLE TEXT, SCRAMBLE TEXT, TIME INT, DNF INT, PLUSTWO INT, RECONSTRUCTION TEX, COMMENT TEXT)');
    // Insert user for local data (If the user creates a online user this will become updated later)
    var localUser = 'localUser${generateRandomNumber()}';
    await db.insert('USUARIO', {
      'USER': localUser,
      'PASS': '',
      'COUNTRY': '',
      'STATE': '',
      'WCAID': '',
      'EMAIL': ''
    }).then((value) {
      SessionStatics.user = localUser;
      if (prefs.getString('user') == null) {
        prefs.setString('user', localUser);
      }
      SessionStatics.id = value;
      if (prefs.getInt('id') == null) {
        prefs.setInt('id', value);
      }
    });
  }

  // Add your database operations here (e.g., insert, query, update, delete)
}
