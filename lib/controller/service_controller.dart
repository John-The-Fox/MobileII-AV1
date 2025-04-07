import 'package:flutter/material.dart';
import '../model/service_model.dart';

class ServiceController extends ChangeNotifier {
  final List<Service> _services = [
    Service(
      name: 'Consulta Médica',
      description: 'Agende uma consulta com um médico especializado.',
      category: 'Saúde',
    ),
    Service(
      name: 'Emissão de Passaporte',
      description: 'Solicite a emissão de um novo passaporte.',
      category: 'Documentação',
    ),
    // Adicione mais serviços conforme necessário
  ];

  int currentServiceIndex = 0;

  List<Service> get services => _services;
}
