import 'package:contractor_client_app/utils/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../models/project.dart';
import '../services/api_service.dart';

class ProjectProvider with ChangeNotifier {
  List<Project> _projects = [];
  bool _isLoading = false;
  Project? _selectedProject;

  List<Project> get projects => _projects;
  bool get isLoading => _isLoading;
  Project? get selectedProject => _selectedProject;

  Future<void> fetchProjects() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/projects');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _projects = (data['projects'] as List)
            .map((project) => Project.fromJson(project))
            .toList();
      }
    } catch (e) {
      print('Error fetching projects: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createProject(Project project) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.post('/projects', project.toJson());
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final newProject = Project.fromJson(data['project']);
        _projects.add(newProject);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error creating project: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> updateProject(String projectId, Map<String, dynamic> updates) async {
    try {
      final response = await ApiService.put('/projects/$projectId', updates);
      if (response.statusCode == 200) {
        await fetchProjects();
        return true;
      }
    } catch (e) {
      print('Error updating project: $e');
    }
    return false;
  }

  void selectProject(Project project) {
    _selectedProject = project;
    notifyListeners();
  }
}