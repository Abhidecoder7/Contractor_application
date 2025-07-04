import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../models/contractor.dart';
import '../services/api_service.dart';

class ContractorProvider with ChangeNotifier {
  List<Contractor> _contractors = [];
  bool _isLoading = false;
  Contractor? _selectedContractor;

  List<Contractor> get contractors => _contractors;
  bool get isLoading => _isLoading;
  Contractor? get selectedContractor => _selectedContractor;

  Future<void> fetchContractors() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/contractors');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _contractors = (data['contractors'] as List)
            .map((contractor) => Contractor.fromJson(contractor))
            .toList();
      }
    } catch (e) {
      print('Error fetching contractors: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<List<Contractor>> searchContractors(Map<String, dynamic> filters) async {
    try {
      final response = await ApiService.post('/contractors/search', filters);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['contractors'] as List)
            .map((contractor) => Contractor.fromJson(contractor))
            .toList();
      }
    } catch (e) {
      print('Error searching contractors: $e');
    }
    return [];
  }

  void selectContractor(Contractor contractor) {
    _selectedContractor = contractor;
    notifyListeners();
  }
}