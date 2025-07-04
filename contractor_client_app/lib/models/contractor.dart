class Contractor {
  final String id;
  final PersonalInfo personalInfo;
  final BusinessInfo businessInfo;
  final List<String> serviceAreas;
  final Expertise expertise;
  final Pricing pricing;
  final Reviews reviews;
  final List<String> portfolio;
  final Verification verification;
  final String status;
  final DateTime createdAt;

  Contractor({
    required this.id,
    required this.personalInfo,
    required this.businessInfo,
    required this.serviceAreas,
    required this.expertise,
    required this.pricing,
    required this.reviews,
    required this.portfolio,
    required this.verification,
    required this.status,
    required this.createdAt,
  });

  factory Contractor.fromJson(Map<String, dynamic> json) {
    return Contractor(
      id: json['_id'],
      personalInfo: PersonalInfo.fromJson(json['personalInfo']),
      businessInfo: BusinessInfo.fromJson(json['businessInfo']),
      serviceAreas: List<String>.from(json['serviceAreas'] ?? []),
      expertise: Expertise.fromJson(json['expertise']),
      pricing: Pricing.fromJson(json['pricing']),
      reviews: Reviews.fromJson(json['reviews']),
      portfolio: List<String>.from(json['portfolio'] ?? []),
      verification: Verification.fromJson(json['verification']),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class PersonalInfo {
  final String name;
  final String email;
  final String phone;
  final String profilePicture;
  final String bio;

  PersonalInfo({
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePicture,
    required this.bio,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profilePicture: json['profilePicture'] ?? '',
      bio: json['bio'] ?? '',
    );
  }
}

class BusinessInfo {
  final String companyName;
  final String businessType;
  final String gstNumber;
  final String licenseNumber;
  final int yearsOfExperience;
  final String address;

  BusinessInfo({
    required this.companyName,
    required this.businessType,
    required this.gstNumber,
    required this.licenseNumber,
    required this.yearsOfExperience,
    required this.address,
  });

  factory BusinessInfo.fromJson(Map<String, dynamic> json) {
    return BusinessInfo(
      companyName: json['companyName'],
      businessType: json['businessType'],
      gstNumber: json['gstNumber'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
      yearsOfExperience: json['yearsOfExperience'] ?? 0,
      address: json['address'],
    );
  }
}

class Expertise {
  final List<String> categories;
  final List<String> skills;
  final List<String> certifications;

  Expertise({
    required this.categories,
    required this.skills,
    required this.certifications,
  });

  factory Expertise.fromJson(Map<String, dynamic> json) {
    return Expertise(
      categories: List<String>.from(json['categories'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      certifications: List<String>.from(json['certifications'] ?? []),
    );
  }
}

class Pricing {
  final double hourlyRate;
  final double minProjectValue;
  final double maxProjectValue;

  Pricing({
    required this.hourlyRate,
    required this.minProjectValue,
    required this.maxProjectValue,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      hourlyRate: (json['hourlyRate'] ?? 0).toDouble(),
      minProjectValue: (json['minProjectValue'] ?? 0).toDouble(),
      maxProjectValue: (json['maxProjectValue'] ?? 0).toDouble(),
    );
  }
}

class Reviews {
  final double averageRating;
  final int totalReviews;
  final List<Review> recentReviews;

  Reviews({
    required this.averageRating,
    required this.totalReviews,
    required this.recentReviews,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      recentReviews: (json['recentReviews'] as List<dynamic>?)
              ?.map((review) => Review.fromJson(review))
              .toList() ??
          [],
    );
  }
}

class Review {
  final String clientName;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.clientName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      clientName: json['clientName'],
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'],
      date: DateTime.parse(json['date']),
    );
  }
}

class Verification {
  final bool isVerified;
  final bool documentsVerified;
  final bool backgroundChecked;
  final DateTime? verificationDate;

  Verification({
    required this.isVerified,
    required this.documentsVerified,
    required this.backgroundChecked,
    this.verificationDate,
  });

  factory Verification.fromJson(Map<String, dynamic> json) {
    return Verification(
      isVerified: json['isVerified'] ?? false,
      documentsVerified: json['documentsVerified'] ?? false,
      backgroundChecked: json['backgroundChecked'] ?? false,
      verificationDate: json['verificationDate'] != null
          ? DateTime.parse(json['verificationDate'])
          : null,
    );
  }
}