import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/lawyer_controller.dart';

class DetalhesAdvogadoView extends StatelessWidget {
  const DetalhesAdvogadoView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = GetIt.I.get<LawyerController>();
    final lawyer = ctrl.lawyers[ctrl.currentLawyerIndex];
    final Color primaryColor = const Color(0xFF00796B);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Advogado",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nome: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(lawyer.name, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10.0),
            const Text("Área de Atuação: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(lawyer.area, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10.0),
            const Text("Descrição: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(lawyer.description, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10.0),
            const Text("Email: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(lawyer.email, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10.0),
            const Text("Telefone: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(lawyer.phone, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
