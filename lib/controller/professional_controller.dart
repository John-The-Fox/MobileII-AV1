import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/professional_model.dart';

class ProfessionalController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Professional> _professionals = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Professional> get professionals => _professionals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  set currentProfessional(Professional currentProfessional) {}

  Future<List<Professional>> fetchProfessionals() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      QuerySnapshot querySnapshot =
          await _firestore.collection('professionals').get();

      _professionals = querySnapshot.docs
          .map((doc) => Professional.fromFirestore(doc))
          .toList();

      _isLoading = false;
      notifyListeners();
      return _professionals;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erro ao buscar profissionais: $e';
      notifyListeners();
      print('Erro ao buscar profissionais: $e');
      return [];
    }
  }
}
