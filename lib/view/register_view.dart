import 'package:app_mobile2/controller/user_controller.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final ctrl = GetIt.I.get<UserController>();
  final Color primaryColor = Color(0xFF00796B); // Verde profissional
  final Color accentColor = Color(0xFFB2DFDB);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name = "";
  String email = "";
  String phoneNumber = "";
  String password = "";
  String confirmedPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
       *  AppBar
       */
      appBar: AppBar(
        title: Text("Cadastrar Conta", style: TextStyle(color: accentColor)),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      /*
       *  Body
       */
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 50, 30, 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 30.0),
              /*
              *  Name Input Field
              */
              TextFormField(
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  labelText: "Nome",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Informe seu Nome";
                  }
                  return null;
                },
                onChanged: (value) {
                  name = value;
                },
              ),
              SizedBox(height: 20.0),
              /*
              *  Email Input Field
              */
              TextFormField(
                style: TextStyle(fontSize: 20),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Informe seu Email";
                  } else if (!EmailValidator.validate(email)) {
                    return "Formato de Email inválido";
                  }
                  return null;
                },
                onChanged: (value) {
                  email = value;
                },
              ),
              SizedBox(height: 20.0),
              /*
              *  Phone Number Input Field
              */
              TextFormField(
                style: TextStyle(fontSize: 20),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: "Telefone",
                  counterText: '',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Informe seu Telefone";
                  } else if (phoneNumber.length != 10) {
                    return "Formato de número de telefone inválido";
                  }
                  return null;
                },
                onChanged: (value) {
                  phoneNumber = value;
                },
              ),
              SizedBox(height: 20.0),
              /*
              *  Password Input Field
              */
              TextFormField(
                obscureText: true,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  labelText: "Senha",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Defina sua Senha";
                  }
                  return null;
                },
                onChanged: (value) {
                  password = value;
                },
              ),
              SizedBox(height: 20.0),
              /*
              *  Confirm Password Input Field
              */
              TextFormField(
                obscureText: true,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  labelText: "Confirmar Senha",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Confirme sua Senha";
                  }
                  return null;
                },
                onChanged: (value) {
                  confirmedPassword = value;
                },
              ),
              SizedBox(height: 30.0),
              /*
              *  Register User Button
              */
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: accentColor,
                  minimumSize: Size(400, 50),
                  textStyle: TextStyle(fontSize: 16.0),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (password == confirmedPassword) {
                      ctrl.addUser(name, email, phoneNumber, password);
                      _formKey.currentState?.reset();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Usuário cadastrado com sucesso!"),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("Senha e confirmação de senha diferentes"),
                      ));
                    }
                  }
                },
                child: Text("Cadastrar Conta"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
