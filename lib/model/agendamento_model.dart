import 'package:app_mobile2/model/service_model.dart';

class Agendamento {
  final Service service;
  final String? data; // Pode ser null
  final String? hora; // Pode ser null

  Agendamento({
    required this.service,
    this.data,
    this.hora,
  });
}
