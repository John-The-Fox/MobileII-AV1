import 'dart:io';
import 'package:app_mobile2/controller/professional_controller.dart';
import 'package:app_mobile2/controller/user_controller.dart';
import 'package:app_mobile2/model/agendamento_model.dart';
import 'package:app_mobile2/model/service_model.dart';
import 'package:app_mobile2/model/professional_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AgendamentoView extends StatefulWidget {
  const AgendamentoView({super.key});

  @override
  State<AgendamentoView> createState() => _AgendamentoViewState();
}

class _AgendamentoViewState extends State<AgendamentoView> {
  final userCtrl = GetIt.I.get<UserController>();
  final professionalCtrl = GetIt.I.get<ProfessionalController>();
  final Color primaryColor = const Color(0xFF00796B); // Verde profissional
  final Color accentColor = const Color(0xFFB2DFDB);

  Service? _selectedService;
  Professional? _selectedProfessional;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  File? _document1;
  File? _document2;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Tenta obter o serviço passado como argumento
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final service = ModalRoute.of(context)?.settings.arguments as Service?;
      if (service != null) {
        setState(() {
          _selectedService = service;
        });
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (!mounted) return; // Adicionado mounted check
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (!mounted) return; // Adicionado mounted check
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _pickDocument(int docNumber) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        if (docNumber == 1) {
          _document1 = File(image.path);
        } else {
          _document2 = File(image.path);
        }
      });
    }
  }

  Future<void> _submitAppointment() async {
    if (_selectedService == null ||
        _selectedProfessional == null ||
        _selectedDate == null ||
        _selectedTime == null) {
      if (!mounted) return; // Adicionado mounted check
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, preencha todos os campos obrigatórios.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      String? doc1Url;
      String? doc2Url;

      if (_document1 != null) {
        doc1Url = await userCtrl.uploadDocument(_document1!, 'document1');
      }
      if (_document2 != null) {
        doc2Url = await userCtrl.uploadDocument(_document2!, 'document2');
      }

      final String formattedDate =
          DateFormat('dd/MM/yyyy').format(_selectedDate!);
      final String formattedTime = _selectedTime!.format(context);

      // Criar o agendamento no Firestore
      await FirebaseFirestore.instance.collection('appointments').add({
        'user_uid': userCtrl.currentUser!.uid,
        'service_id': _selectedService!.id,
        'professional_id': _selectedProfessional!.id,
        'appointment_date': formattedDate,
        'appointment_time': formattedTime,
        'status': 'pendente',
        'document_1_url': doc1Url,
        'document_2_url': doc2Url,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      });

      if (!mounted) return; // Adicionado mounted check
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agendamento realizado com sucesso!')),
      );
      if (!mounted) return; // Adicionado mounted check
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao agendar serviço: $e';
      });
      if (!mounted) return; // Adicionado mounted check
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao agendar serviço: $_errorMessage')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agendar Serviço", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),

                  Text(
                    "Serviço Selecionado:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _selectedService == null
                      ? const Text("Nenhum serviço selecionado")
                      : Text(
                          _selectedService!.name,
                          style: const TextStyle(fontSize: 16),
                        ),
                  const SizedBox(height: 16),

                  // Seleção de Profissional
                  Text(
                    "Escolha um Profissional:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<List<Professional>>(
                    future: professionalCtrl.fetchProfessionals(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text(
                            'Erro ao carregar profissionais: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('Nenhum profissional encontrado.');
                      } else {
                        return DropdownButtonFormField<Professional>(
                          decoration: const InputDecoration(
                            labelText: 'Profissional',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedProfessional,
                          items: snapshot.data!.map((professional) {
                            return DropdownMenuItem<Professional>(
                              value: professional,
                              child: Text(professional.name),
                            );
                          }).toList(),
                          onChanged: (Professional? newValue) {
                            setState(() {
                              _selectedProfessional = newValue;
                            });
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Seleção de Data
                  Text(
                    "Escolha a Data:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    title: Text(
                      _selectedDate == null
                          ? 'Selecionar Data'
                          : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(color: Colors.grey)),
                  ),
                  const SizedBox(height: 16),

                  // Seleção de Hora
                  Text(
                    "Escolha a Hora:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    title: Text(
                      _selectedTime == null
                          ? 'Selecionar Hora'
                          : _selectedTime!.format(context),
                    ),
                    trailing: const Icon(Icons.access_time),
                    onTap: () => _selectTime(context),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(color: Colors.grey)),
                  ),
                  const SizedBox(height: 16),

                  // Upload de Documentos
                  Text(
                    "Anexar Documentos (Opcional):",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _pickDocument(1),
                          icon: const Icon(Icons.upload_file),
                          label: Text(_document1 == null
                              ? 'Documento 1'
                              : 'Doc 1 Selecionado'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _pickDocument(2),
                          icon: const Icon(Icons.upload_file),
                          label: Text(_document2 == null
                              ? 'Documento 2'
                              : 'Doc 2 Selecionado'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Botão de Agendar
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitAppointment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text("Agendar Serviço"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}


