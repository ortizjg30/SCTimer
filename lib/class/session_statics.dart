import 'package:sqflite/sqflite.dart';

class SessionStatics {
  static bool loggedIn = false;
  static String wcaId = "";
  static String user = "";
  static String pass = "";
  static String country = "";
  static String state = "";
  static String email = "";
  static int id = 0;
  static Database? db;
}
