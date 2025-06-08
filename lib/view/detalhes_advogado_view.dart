import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/professional_controller.dart';
import '../model/professional_model.dart';

class DetalhesAdvogadoView extends StatefulWidget {
  const DetalhesAdvogadoView({super.key, required Professional professional});

  @override
  State<DetalhesAdvogadoView> createState() => _DetalhesAdvogadoViewState();
}

class _DetalhesAdvogadoViewState extends State<DetalhesAdvogadoView> {
  final ctrl = GetIt.I.get<ProfessionalController>();
  final Color primaryColor = const Color(0xFF00796B);

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() => setState(() {}));
    ctrl.fetchProfessionals(); // Fetch professionals when the view initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta de Profissionais",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
        child: Column(
          children: [
            const Text("Profissionais Disponíveis:",
                style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20.0),
            Expanded(
              child: ctrl.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ctrl.professionals.isEmpty
                      ? const Center(
                          child: Text("Nenhum profissional encontrado."))
                      : ListView.builder(
                          itemCount: ctrl.professionals.length,
                          itemBuilder: (context, index) {
                            final professional = ctrl.professionals[index];
                            return SizedBox(
                              width: double.infinity,
                              child: Card(
                                child: ListTile(
                                  leading: const Icon(Icons.person),
                                  title: Text(professional.name),
                                  subtitle: Text(professional.specialty),
                                  onTap: () {
                                    // Passar o objeto Professional diretamente para a próxima tela
                                    Navigator.pushNamed(
                                        context, 'lawyerDetails',
                                        arguments: professional);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
