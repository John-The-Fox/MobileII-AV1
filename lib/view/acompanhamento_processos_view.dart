import 'package:app_mobile2/controller/user_controller.dart';
import 'package:app_mobile2/model/agendamento_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class AcompanhamentoProcessosView extends StatefulWidget {
  const AcompanhamentoProcessosView({super.key});

  @override
  State<AcompanhamentoProcessosView> createState() =>
      _AcompanhamentoProcessosViewState();
}

class _AcompanhamentoProcessosViewState
    extends State<AcompanhamentoProcessosView> {
  final userCtrl = GetIt.I.get<UserController>();
  late Future<List<Appointment>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _appointmentsFuture = userCtrl.fetchUserAppointments();
  }

  Future<void> _refreshAppointments() async {
    setState(() {
      _appointmentsFuture = userCtrl.fetchUserAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Acompanhamento de Processos"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Appointment>>(
        future: _appointmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child:
                    Text('Erro ao carregar agendamentos: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum agendamento encontrado.'));
          } else {
            final appointments = snapshot.data!;
            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Serviço: ${appointment.serviceName}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Profissional: ${appointment.professionalName}'),
                        Text('Data: ${appointment.appointmentDate}'),
                        Text('Hora: ${appointment.appointmentTime}'),
                        Text('Status: ${appointment.status}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () async {
                                final DateTime? pickedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 365 * 5)),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365 * 5)),
                                );
                                if (pickedDate != null) {
                                  final TimeOfDay? pickedTime =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (pickedTime != null) {
                                    final String newDate =
                                        DateFormat('dd/MM/yyyy')
                                            .format(pickedDate);
                                    final String newTime =
                                        pickedTime.format(context);
                                    bool success = await userCtrl
                                        .updateAppointmentDateTime(
                                            appointment.id, newDate, newTime);
                                    if (!mounted) return;
                                    if (success) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Agendamento atualizado com sucesso!')),
                                      );
                                      _refreshAppointments();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Erro ao atualizar agendamento.')),
                                      );
                                    }
                                  }
                                }
                              },
                              child: const Text('Editar'),
                            ),
                            TextButton(
                              onPressed: () async {
                                bool confirm = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title:
                                            const Text('Cancelar Agendamento'),
                                        content: const Text(
                                            'Tem certeza que deseja cancelar este agendamento?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text('Não'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: const Text('Sim'),
                                          ),
                                        ],
                                      ),
                                    ) ??
                                    false;

                                if (!mounted) return;
                                if (confirm) {
                                  bool success = await userCtrl
                                      .cancelAppointment(appointment.id);
                                  if (!mounted) return;
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Agendamento cancelado com sucesso!')),
                                    );
                                    _refreshAppointments();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Erro ao cancelar agendamento.')),
                                    );
                                  }
                                }
                              },
                              child: const Text('Cancelar',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
