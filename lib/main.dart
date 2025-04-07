import 'package:app_mobile2/controller/chat_controller.dart';
import 'package:app_mobile2/controller/service_controller.dart';
import 'package:app_mobile2/controller/user_controller.dart';
import 'package:app_mobile2/view/about_view.dart';
//import 'package:app_mobile2/view/agendamento_view.dart';
import 'package:app_mobile2/view/chat_view.dart';
import 'package:app_mobile2/view/consulta_servicos_view.dart';
import 'package:app_mobile2/view/detalhes_servico_view.dart';
import 'package:app_mobile2/view/home_view.dart';
import 'package:app_mobile2/view/acompanhamento_processos_view.dart';
import 'package:app_mobile2/view/login_view.dart';
import 'package:app_mobile2/view/recover_password_view.dart';
import 'package:app_mobile2/view/register_view.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'controller/lawyer_controller.dart';
import 'view/consulta_advogados_view.dart';
import 'view/detalhes_advogado_view.dart';

final g = GetIt.instance;

void main() {
  g.registerSingleton<UserController>(UserController());
  g.registerSingleton<ServiceController>(ServiceController());
  g.registerSingleton<LawyerController>(LawyerController());
  g..registerSingleton<ChatController>(ChatController());

  runApp(
    DevicePreview(enabled: true, builder: (context) => const MainApp()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Rotas de Navegação
      initialRoute: 'login',
      routes: {
        'login': (context) => const LoginView(),
        'about': (context) => const AboutView(),
        'recover': (context) => const RecoverPasswordView(),
        'register': (context) => const RegisterView(),
        'home': (context) => const HomeView(),
        'consultaServicos': (context) => const ConsultaServicosView(),
        'acompanhamentoProcessos': (context) =>
            const AcompanhamentoProcessosView(),
        'buscaAdv': (context) => const ConsultaAdvogadosView(),
        'serviceDetails': (context) => const DetalhesServicoView(),
        'lawyerDetails': (context) => const DetalhesAdvogadoView(),
        'chat': (context) => const ChatView(),
      },
    );
  }
}
