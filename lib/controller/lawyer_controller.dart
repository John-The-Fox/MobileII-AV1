import 'package:flutter/material.dart';
import '../model/lawyer_model.dart';

class LawyerController extends ChangeNotifier {
  final List<Lawyer> _lawyers = [
    Lawyer(
      name: 'Dra. Mariana Silva',
      area: 'Direito Trabalhista',
      description:
          'Especialista em causas trabalhistas e defesa do trabalhador.',
      email: 'mariana.silva@advogados.com',
      phone: '(11) 91234-5678',
    ),
    Lawyer(
      name: 'Dr. João Pereira',
      area: 'Direito Civil',
      description: 'Atuação em contratos, indenizações e disputas civis.',
      email: 'joao.pereira@advocacia.com',
      phone: '(21) 99876-5432',
    ),
    // Adicione mais advogados conforme necessário
  ];

  int currentLawyerIndex = 0;

  List<Lawyer> get lawyers => _lawyers;
}
