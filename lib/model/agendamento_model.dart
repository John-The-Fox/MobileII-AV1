import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_mobile2/model/service_model.dart';
import 'package:app_mobile2/model/professional_model.dart';

class Appointment {
  final String id;
  final String userId;
  final Service service;
  final Professional professional;
  final String date;
  final String time;
  final String status;
  final String? document1Url;
  final String? document2Url;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Appointment({
    required this.id,
    required this.userId,
    required this.service,
    required this.professional,
    required this.date,
    required this.time,
    required this.status,
    this.document1Url,
    this.document2Url,
    required this.createdAt,
    required this.updatedAt,
  });

  // Getters para facilitar o acesso nas Views
  String get serviceName => service.name;
  String get professionalName => professional.name;
  String get appointmentDate => date;
  String get appointmentTime => time;

  // Método para converter um documento do Firestore em um objeto Appointment
  static Future<Appointment> fromFirestore(
      DocumentSnapshot doc, FirebaseFirestore firestore) async {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Buscar o serviço
    DocumentSnapshot serviceDoc =
        await firestore.collection('services').doc(data['service_id']).get();
    Service service = Service(
      id: serviceDoc.id,
      name: serviceDoc['name'],
      description: serviceDoc['description'],
      price: serviceDoc['price'].toDouble(),
      category: serviceDoc['category'],
    );

    // Buscar o profissional
    DocumentSnapshot professionalDoc = await firestore
        .collection('professionals')
        .doc(data['professional_id'])
        .get();
    Professional professional = Professional.fromFirestore(professionalDoc);

    return Appointment(
      id: doc.id,
      userId: data['user_uid'],
      service: service,
      professional: professional,
      date: data['appointment_date'],
      time: data['appointment_time'],
      status: data['status'],
      document1Url: data['document_1_url'],
      document2Url: data['document_2_url'],
      createdAt: data['created_at'] ?? Timestamp.now(),
      updatedAt: data['updated_at'] ?? Timestamp.now(),
    );
  }

  // Método para converter um objeto Appointment em um mapa para o Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'user_uid': userId,
      'service_id': service.id,
      'professional_id': professional.id,
      'appointment_date': date,
      'appointment_time': time,
      'status': status,
      'document_1_url': document1Url,
      'document_2_url': document2Url,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
