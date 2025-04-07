import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../controller/lawyer_controller.dart';

class ConsultaAdvogadosView extends StatefulWidget {
  const ConsultaAdvogadosView({super.key});

  @override
  State<ConsultaAdvogadosView> createState() => _ConsultaAdvogadosViewState();
}

class _ConsultaAdvogadosViewState extends State<ConsultaAdvogadosView> {
  final ctrl = GetIt.I.get<LawyerController>();
  final Color primaryColor = const Color(0xFF00796B);

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta de Advogados",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
        child: Column(
          children: [
            const Text("Advogados Disponíveis:",
                style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: ctrl.lawyers.length,
                itemBuilder: (context, index) {
                  final lawyer = ctrl.lawyers[index];
                  return SizedBox(
                    width: double.infinity,
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(lawyer.name),
                        subtitle: Text(lawyer.area),
                        onTap: () {
                          ctrl.currentLawyerIndex = index;
                          Navigator.pushNamed(context, 'lawyerDetails');
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
