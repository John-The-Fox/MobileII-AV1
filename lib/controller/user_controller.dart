import 'package:app_mobile2/model/agendamento_model.dart';
import 'package:app_mobile2/model/service_model.dart';
import 'package:app_mobile2/model/user_model.dart';
import 'package:flutter/material.dart';

class UserController extends ChangeNotifier {
  final List<User> _users = [
    User(
        name: "Admin",
        email: "admin@email.com",
        phoneNumber: "1111111111",
        password: "admin"),
  ];
  int currentUserIndex = 0;

  List<User> get users => _users;

  void addUser(String name, String email, String phoneNumber, String password) {
    _users.add(User(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        password: password));
    notifyListeners();
  }

  bool login(String givenEmail, String givenPassword) {
    bool found = false;
    for (int i = 0; i < _users.length; i++) {
      if ((_users[i].email == givenEmail) &&
          (_users[i].password == givenPassword)) {
        found = true;
        currentUserIndex = i;
      }
    }

    return found;
  }

  void addAgendamento(Service service, int userId, String? data, String? hora) {
    _users[userId]
        .agendamentos
        .add(Agendamento(service: service, data: data, hora: hora));
    notifyListeners();
  }

  void removeAgendamento(index, int userId) {
    _users[userId].agendamentos.removeAt(index);
    notifyListeners();
  }
}
