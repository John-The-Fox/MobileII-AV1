import 'package:app_mobile2/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/service_controller.dart';

class DetalhesServicoView extends StatelessWidget {
  const DetalhesServicoView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = GetIt.I.get<ServiceController>();
    final userCtrl = GetIt.I.get<UserController>();
    final service = ctrl.currentService; // Use currentService directly
    final Color primaryColor = const Color(0xFF00796B);

    if (service == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Detalhes do Serviço",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        body: const Center(
          child: Text("Serviço não encontrado."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Serviço",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Serviço: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(service.name, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10.0),
            const Text("Categoria: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(service.category, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10.0),
            const Text("Descrição: ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(service.description, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Ação para agendar/solicitar o serviço
                  // Navega para a tela de agendamento para que o usuário possa selecionar profissional, data, hora e documentos
                  Navigator.pushNamed(context, 'agendamento',
                      arguments: service);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text("Agendar / Solicitar Serviço"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
