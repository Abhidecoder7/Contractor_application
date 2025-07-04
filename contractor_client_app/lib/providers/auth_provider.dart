import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  bool _isFirstTime = true;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  bool get isFirstTime => _isFirstTime;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['token'];
        _user = User.fromJson(data['user']);
        _isAuthenticated = true;
        _isFirstTime = false;
        
        // Save to local storage
        await _saveAuthData();
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Login error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(Map<String, dynamic> userData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.post('/auth/register', userData);

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        _token = data['token'];
        _user = User.fromJson(data['user']);
        _isAuthenticated = true;
        _isFirstTime = false;
        
        await _saveAuthData();
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Registration error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    _isAuthenticated = false;
    await _clearAuthData();
    notifyListeners();
  }

  Future<void> _saveAuthData() async {
    // In a real app, use secure storage
    // For now, we'll use a simple approach
  }

  Future<void> _clearAuthData() async {
    // Clear stored auth data
  }

  Future<void> loadAuthData() async {
    // Load auth data from storage
  }

  Future<void> updateProfile({required String name, required String email, required String phone}) async {}
}