import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/user_controller.dart';

class AcompanhamentoProcessosView extends StatefulWidget {
  const AcompanhamentoProcessosView({super.key});

  @override
  State<AcompanhamentoProcessosView> createState() =>
      _AcompanhamentoProcessosViewState();
}

class _AcompanhamentoProcessosViewState
    extends State<AcompanhamentoProcessosView> {
  final userCtrl = GetIt.I.get<UserController>();
  final Color primaryColor = Colors.blue.shade800; // Cor profissional

  @override
  void initState() {
    super.initState();
    userCtrl.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    // Obtém o usuário atualmente logado
    final currentUser = userCtrl.users[userCtrl.currentUserIndex];

    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Agendamentos", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
        child: Column(
          children: [
            const Text("Agendamentos Atuais:", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: currentUser.agendamentos.length,
                itemBuilder: (context, index) {
                  final agendamento = currentUser.agendamentos[index];
                  return Card(
                    child: ListTile(
                      title: Text(agendamento.service.name),
                      subtitle: Text(
                        "Data: ${agendamento.data ?? 'N/A'} - Hora: ${agendamento.hora ?? 'N/A'}",
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _confirmDeleteDialog(index),
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

  void _confirmDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Excluir este agendamento?"),
          actions: [
            TextButton(
              onPressed: () {
                userCtrl.removeAgendamento(index, userCtrl.currentUserIndex);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Agendamento removido com sucesso!")),
                );
                Navigator.pop(context);
              },
              child: const Text("Sim", style: TextStyle(fontSize: 18.0)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar", style: TextStyle(fontSize: 18.0)),
            ),
          ],
        );
      },
    );
  }
}
