import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/service_model.dart';

class ServiceController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Service> _services = [];
  int _currentServiceIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;

  List<Service> get services => _services;
  int get currentServiceIndex => _currentServiceIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  get currentService => null;

  // Método para definir o serviço atual
  void setCurrentServiceIndex(int index) {
    _currentServiceIndex = index;
    notifyListeners();
  }

  // Método para buscar todos os serviços
  Future<List<Service>> fetchServices() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      QuerySnapshot querySnapshot =
          await _firestore.collection('services').get();

      _services =
          querySnapshot.docs.map((doc) => Service.fromFirestore(doc)).toList();

      _isLoading = false;
      notifyListeners();
      return _services;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erro ao buscar serviços: $e';
      notifyListeners();
      print('Erro ao buscar serviços: $e');
      return [];
    }
  }

  // Método para buscar serviços por categoria
  Future<List<Service>> fetchServicesByCategory(String category) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      QuerySnapshot querySnapshot = await _firestore
          .collection('services')
          .where('category', isEqualTo: category)
          .get();

      List<Service> categoryServices =
          querySnapshot.docs.map((doc) => Service.fromFirestore(doc)).toList();

      _isLoading = false;
      notifyListeners();
      return categoryServices;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erro ao buscar serviços por categoria: $e';
      notifyListeners();
      print('Erro ao buscar serviços por categoria: $e');
      return [];
    }
  }

  // Método para buscar um serviço específico por ID
  Future<Service?> fetchServiceById(String serviceId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      DocumentSnapshot doc =
          await _firestore.collection('services').doc(serviceId).get();

      if (doc.exists) {
        Service service = Service.fromFirestore(doc);
        _isLoading = false;
        notifyListeners();
        return service;
      } else {
        _isLoading = false;
        _errorMessage = 'Serviço não encontrado';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erro ao buscar serviço: $e';
      notifyListeners();
      print('Erro ao buscar serviço: $e');
      return null;
    }
  }
}
