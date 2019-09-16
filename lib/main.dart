import 'dart:convert';

import 'package:attendance_teacher/classes/teacher.dart';
import 'package:attendance_teacher/screens/adminDashboard.dart';
import 'package:attendance_teacher/screens/dashboard.dart';
import 'package:attendance_teacher/screens/login.dart';
import 'package:attendance_teacher/screens/mailteachers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

  SharedPreferences.getInstance().then((prefs) {
    final String jsonObject = prefs.getString('storedObject');
    final String jsonId = prefs.getString('storedId');
    if(jsonObject != null && jsonObject.isNotEmpty) {
      Teacher student = Teacher.fromMapObject(json.decode(jsonObject));
      student.documentId = jsonId;
      return runApp(MyApp(true, student));
    }
    else
      return runApp(MyApp(false, Teacher.blank()));
  });

}

class MyApp extends StatelessWidget {

  bool check;
  Teacher teacher;
  MyApp(this.check, this.teacher);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Teacher Attendance Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light
      ),
      home: check? (teacher.verify==404? AdminDashboard(): Dashboard(teacher)): Login()
    );
  }
}
