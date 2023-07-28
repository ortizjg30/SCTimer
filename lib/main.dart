import 'package:flutter/material.dart';
import 'package:sctimer/class/db_helper.dart';
import 'package:sctimer/class/session_statics.dart';
import 'package:sctimer/screen/chronometer_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Check if currentPreferences Exists
    if (prefs.getBool('loggedIn') == null) {
      prefs.setBool('loggedIn', false);
    }
    if (prefs.getString('user') == null) {
      prefs.setString('user', "");
    }
    if (prefs.getString('pass') == null) {
      prefs.setString('pass', "");
    }
    if (prefs.getString('wcaId') == null) {
      prefs.setString('wcaId', "");
    }
    if (prefs.getString('country') == null) {
      prefs.setString('country', "");
    }
    if (prefs.getString('state') == null) {
      prefs.setString('state', "");
    }
    if (prefs.getString('email') == null) {
      prefs.setString('email', "");
    }
    if (prefs.getInt('id') == null) {
      prefs.setInt('id', 0);
    }
    DBHelper dbHelper = DBHelper();
    SessionStatics.loggedIn = prefs.getBool('loggedIn') ?? false;
    SessionStatics.user = prefs.getString('user') ?? "";
    SessionStatics.pass = prefs.getString('pass') ?? "";
    SessionStatics.wcaId = prefs.getString('wcaId') ?? "";
    SessionStatics.country = prefs.getString('country') ?? "";
    SessionStatics.state = prefs.getString('state') ?? "";
    SessionStatics.email = prefs.getString('email') ?? "";
    SessionStatics.id = prefs.getInt('id') ?? 0;
    SessionStatics.db = await dbHelper.db;
    print(SessionStatics.user);
    if (SessionStatics.id == 0) {
      getDataFromStorage();
    }
    //localUser6825598
  }

  void getDataFromStorage() async {
    if (SessionStatics.loggedIn) {
      //Get data from API
    } else {
      List<Map<String, dynamic>>? result =
          await SessionStatics.db?.query('USUARIO');
      if (result != null) {
        var aux = result.first;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        SessionStatics.id = aux["ID"];
        prefs.setInt('id', SessionStatics.id);
        SessionStatics.user = aux["USER"];
        prefs.setString('user', SessionStatics.user);
        SessionStatics.pass = aux["PASS"];
        prefs.setString('pass', SessionStatics.pass);
        SessionStatics.country = aux["COUNTRY"];
        prefs.setString('country', SessionStatics.country);
        SessionStatics.state = aux["STATE"];
        prefs.setString('state', SessionStatics.state);
        SessionStatics.wcaId = aux["WCAID"];
        prefs.setString('wcaId', SessionStatics.wcaId);
        SessionStatics.email = aux["EMAIL"];
        prefs.setString('email', SessionStatics.email);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    loadPreferences();
    return MaterialApp(
      title: 'Speedcubing Chronometer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const ChronometerScreen(),
    );
  }
}
