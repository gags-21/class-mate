import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_upload/modals/student_modal.dart';

class StudentInfoProvider extends ChangeNotifier {
  // students
  List<StudentsList> _studentsList = [];

  List<StudentsList> get students => _studentsList;

  void setStudents(String students) {
    final studentListJson = json.decode(students);
    List studentsList = studentListJson["Students"];
    List<StudentsList> list = studentsList.map((stud) {
      return StudentsList(
          id: stud["id"],
          name:
              "${stud["first_name"]} ${stud["middle_name"]} ${stud["last_name"]}");
    }).toList();
    _studentsList = list;
    notifyListeners();
  }
}
