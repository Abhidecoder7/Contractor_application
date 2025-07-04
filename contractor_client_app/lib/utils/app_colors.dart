import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2563EB);
  static const primaryDark = Color(0xFF1E40AF);
  static const secondary = Color(0xFF10B981);
  static const accent = Color(0xFFEC4899);
  static const background = Color(0xFFF8FAFC);
  static const surface = Color(0xFFFFFFFF);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFEAB308);
  static const success = Color(0xFF10B981);
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const border = Color(0xFFE2E8F0);
  static const divider = Color(0xFFCBD5E1);
}

// lib/models/project.dart
class Project {
  final String id;
  final String clientId;
  final String? contractorId;
  final ProjectDetails projectDetails;
  final Requirements requirements;
  final Budget budget;
  final Timeline timeline;
  final Location location;
  final List<String> documents;
  final Progress progress;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Project({
    required this.id,
    required this.clientId,
    this.contractorId,
    required this.projectDetails,
    required this.requirements,
    required this.budget,
    required this.timeline,
    required this.location,
    required this.documents,
    required this.progress,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['_id'],
      clientId: json['clientId'],
      contractorId: json['contractorId'],
      projectDetails: ProjectDetails.fromJson(json['projectDetails']),
      requirements: Requirements.fromJson(json['requirements']),
      budget: Budget.fromJson(json['budget']),
      timeline: Timeline.fromJson(json['timeline']),
      location: Location.fromJson(json['location']),
      documents: List<String>.from(json['documents']['referenceImages'] ?? []),
      progress: Progress.fromJson(json['progress']),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'projectDetails': projectDetails.toJson(),
      'requirements': requirements.toJson(),
      'budget': budget.toJson(),
      'timeline': timeline.toJson(),
      'location': location.toJson(),
      'documents': {'referenceImages': documents},
    };
  }
}

class ProjectDetails {
  final String title;
  final String description;
  final String category;
  final String subcategory;
  final String propertyType;
  final String configuration;
  final int squareFootage;
  final int floors;
  final Rooms rooms;

  ProjectDetails({
    required this.title,
    required this.description,
    required this.category,
    required this.subcategory,
    required this.propertyType,
    required this.configuration,
    required this.squareFootage,
    required this.floors,
    required this.rooms,
  });

  factory ProjectDetails.fromJson(Map<String, dynamic> json) {
    return ProjectDetails(
      title: json['title'],
      description: json['description'],
      category: json['category'],
      subcategory: json['subcategory'] ?? '',
      propertyType: json['propertyType'],
      configuration: json['configuration'],
      squareFootage: json['squareFootage'] ?? 0,
      floors: json['floors'] ?? 1,
      rooms: Rooms.fromJson(json['rooms'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'subcategory': subcategory,
      'propertyType': propertyType,
      'configuration': configuration,
      'squareFootage': squareFootage,
      'floors': floors,
      'rooms': rooms.toJson(),
    };
  }
}

class Requirements {
  final List<String> workType;
  final String furnishing;
  final List<String> specialRequirements;
  final String designStyle;
  final List<String> colorPreferences;
  final String customRequests;

  Requirements({
    required this.workType,
    required this.furnishing,
    required this.specialRequirements,
    required this.designStyle,
    required this.colorPreferences,
    required this.customRequests,
  });

  factory Requirements.fromJson(Map<String, dynamic> json) {
    return Requirements(
      workType: List<String>.from(json['workType'] ?? []),
      furnishing: json['furnishing'] ?? '',
      specialRequirements: List<String>.from(json['specialRequirements'] ?? []),
      designStyle: json['designStyle'] ?? '',
      colorPreferences: List<String>.from(json['colorPreferences'] ?? []),
      customRequests: json['customRequests'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workType': workType,
      'furnishing': furnishing,
      'specialRequirements': specialRequirements,
      'designStyle': designStyle,
      'colorPreferences': colorPreferences,
      'customRequests': customRequests,
    };
  }
}

class Budget {
  final double total;
  final double advancePaid;
  final double remainingAmount;

  Budget({
    required this.total,
    required this.advancePaid,
    required this.remainingAmount,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      total: (json['total'] ?? 0).toDouble(),
      advancePaid: (json['advancePaid'] ?? 0).toDouble(),
      remainingAmount: (json['remainingAmount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'advancePaid': advancePaid,
      'remainingAmount': remainingAmount,
    };
  }
}

class Timeline {
  final DateTime? preferredStartDate;
  final DateTime? expectedCompletionDate;
  final DateTime? actualStartDate;
  final DateTime? actualCompletionDate;

  Timeline({
    this.preferredStartDate,
    this.expectedCompletionDate,
    this.actualStartDate,
    this.actualCompletionDate,
  });

  factory Timeline.fromJson(Map<String, dynamic> json) {
    return Timeline(
      preferredStartDate: json['preferredStartDate'] != null
          ? DateTime.parse(json['preferredStartDate'])
          : null,
      expectedCompletionDate: json['expectedCompletionDate'] != null
          ? DateTime.parse(json['expectedCompletionDate'])
          : null,
      actualStartDate: json['actualStartDate'] != null
          ? DateTime.parse(json['actualStartDate'])
          : null,
      actualCompletionDate: json['actualCompletionDate'] != null
          ? DateTime.parse(json['actualCompletionDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preferredStartDate': preferredStartDate?.toIso8601String(),
      'expectedCompletionDate': expectedCompletionDate?.toIso8601String(),
    };
  }
}

class Location {
  final String address;
  final String city;
  final String state;
  final String pincode;
  final double? latitude;
  final double? longitude;

  Location({
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.latitude,
    this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      address: json['address'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      latitude: json['coordinates']?['latitude']?.toDouble(),
      longitude: json['coordinates']?['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'coordinates': {
        'latitude': latitude,
        'longitude': longitude,
      },
    };
  }
}

class Progress {
  final double overallPercentage;
  final List<Phase> phases;

  Progress({
    required this.overallPercentage,
    required this.phases,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      overallPercentage: (json['overallPercentage'] ?? 0).toDouble(),
      phases: (json['phases'] as List<dynamic>?)
              ?.map((phase) => Phase.fromJson(phase))
              .toList() ??
          [],
    );
  }
}

class Phase {
  final String name;
  final DateTime? startDate;
  final DateTime? endDate;
  final double progress;
  final String status;

  Phase({
    required this.name,
    this.startDate,
    this.endDate,
    required this.progress,
    required this.status,
  });

  factory Phase.fromJson(Map<String, dynamic> json) {
    return Phase(
      name: json['name'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      progress: (json['progress'] ?? 0).toDouble(),
      status: json['status'],
    );
  }
}

class Rooms {
  final int bedrooms;
  final int bathrooms;
  final int kitchen;
  final int livingRooms;
  final int others;

  Rooms({
    required this.bedrooms,
    required this.bathrooms,
    required this.kitchen,
    required this.livingRooms,
    required this.others,
  });

  factory Rooms.fromJson(Map<String, dynamic> json) {
    return Rooms(
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      kitchen: json['kitchen'] ?? 0,
      livingRooms: json['livingRooms'] ?? 0,
      others: json['others'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'kitchen': kitchen,
      'livingRooms': livingRooms,
      'others': others,
    };
  }
}