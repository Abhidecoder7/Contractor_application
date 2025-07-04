const Contractor = require('../models/Contractor');
const geolib = require('geolib');

class MatchingService {
  constructor() {
    this.weights = {
      expertise: 0.25,
      availability: 0.20,
      rating: 0.20,
      location: 0.15,
      budget: 0.10,
      timeline: 0.05,
      urgency: 0.05
    };
  }

  async findBestMatches(projectRequirements, limit = 5) {
    try {
      // Get all eligible contractors
      const contractors = await this.getEligibleContractors(projectRequirements);
      
      if (contractors.length === 0) {
        return { success: false, message: 'No contractors available' };
      }

      // Calculate match scores
      const scoredContractors = await Promise.all(
        contractors.map(async (contractor) => {
          const score = await this.calculateMatchScore(contractor, projectRequirements);
          return { contractor, score };
        })
      );

      // Sort by score and return top matches
      const topMatches = scoredContractors
        .sort((a, b) => b.score - a.score)
        .slice(0, limit);

      return {
        success: true,
        matches: topMatches,
        totalAvailable: contractors.length
      };

    } catch (error) {
      console.error('Matching service error:', error);
      return { success: false, message: 'Error in matching process' };
    }
  }

  async getEligibleContractors(projectRequirements) {
    const query = {
      status: 'Active',
      'verification.profileVerified': true,
      $expr: {
        $lt: ['$availability.currentProjects', '$availability.maxConcurrentProjects']
      }
    };

    // Filter by expertise
    if (projectRequirements.category) {
      query['expertise.categories'] = projectRequirements.category;
    }

    if (projectRequirements.configuration) {
      query['expertise.configurations'] = projectRequirements.configuration;
    }

    if (projectRequirements.propertyType) {
      query['expertise.propertyTypes'] = projectRequirements.propertyType;
    }

    // Filter by service area
    if (projectRequirements.location && projectRequirements.location.city) {
      query.$or = [
        { 'serviceAreas.primary': projectRequirements.location.city },
        { 'serviceAreas.secondary': projectRequirements.location.city }
      ];
    }

    // Filter by budget range
    if (projectRequirements.budget && projectRequirements.budget.total) {
      query['pricing.minimumProject'] = { $lte: projectRequirements.budget.total };
    }

    return await Contractor.find(query).lean();
  }

  async calculateMatchScore(contractor, projectRequirements) {
    let totalScore = 0;

    // Expertise Score (25%)
    totalScore += this.calculateExpertiseScore(contractor, projectRequirements) * this.weights.expertise;

    // Availability Score (20%)
    totalScore += this.calculateAvailabilityScore(contractor, projectRequirements) * this.weights.availability;

    // Rating Score (20%)
    totalScore += this.calculateRatingScore(contractor) * this.weights.rating;

    // Location Score (15%)
    totalScore += this.calculateLocationScore(contractor, projectRequirements) * this.weights.location;

    // Budget Score (10%)
    totalScore += this.calculateBudgetScore(contractor, projectRequirements) * this.weights.budget;

    // Timeline Score (5%)
    totalScore += this.calculateTimelineScore(contractor, projectRequirements) * this.weights.timeline;

    // Urgency Score (5%)
    totalScore += this.calculateUrgencyScore(contractor, projectRequirements) * this.weights.urgency;

    return Math.round(totalScore * 100) / 100;
  }

  calculateExpertiseScore(contractor, project) {
    let score = 0;
    const maxScore = 100;

    // Category match
    if (contractor.expertise.categories.includes(project.category)) {
      score += 40;
    }

    // Configuration match
    if (contractor.expertise.configurations.includes(project.configuration)) {
      score += 30;
    }

    // Property type match
    if (contractor.expertise.propertyTypes.includes(project.propertyType)) {
      score += 20;
    }

    // Specialization bonus
    if (project.requirements && project.requirements.specialRequirements) {
      const matchingSpecializations = project.requirements.specialRequirements.filter(req =>
        contractor.expertise.specializations.includes(req)
      );
      score += Math.min(matchingSpecializations.length * 5, 10);
    }

    return Math.min(score, maxScore);
  }

  calculateAvailabilityScore(contractor, project) {
    const currentLoad = contractor.availability.currentProjects / contractor.availability.maxConcurrentProjects;
    const availabilityScore = (1 - currentLoad) * 100;

    // Bonus for immediate availability
    if (contractor.availability.currentProjects === 0) {
      return Math.min(availabilityScore + 20, 100);
    }

    return availabilityScore;
  }

  calculateRatingScore(contractor) {
    const rating = contractor.ratings.overall;
    const reviewCount = contractor.ratings.totalReviews;

    // Base score from rating
    let score = (rating / 5) * 80;

    // Review count bonus
    if (reviewCount > 50) score += 20;
    else if (reviewCount > 20) score += 15;
    else if (reviewCount > 10) score += 10;
    else if (reviewCount > 5) score += 5;

    return Math.min(score, 100);
  }

  calculateLocationScore(contractor, project) {
    if (!project.location || !project.location.coordinates) return 50;

    const contractorLocation = {
      latitude: contractor.serviceAreas.primaryCoordinates?.latitude || 0,
      longitude: contractor.serviceAreas.primaryCoordinates?.longitude || 0
    };

    const projectLocation = {
      latitude: project.location.coordinates.latitude,
      longitude: project.location.coordinates.longitude
    };

    if (!contractorLocation.latitude || !projectLocation.latitude) return 50;

    const distance = geolib.getDistance(contractorLocation, projectLocation) / 1000; // in km
    const maxDistance = contractor.serviceAreas.maxTravelDistance || 50;

    if (distance <= maxDistance) {
      return Math.max(100 - (distance / maxDistance) * 50, 50);
    }

    return 0;
  }

  calculateBudgetScore(contractor, project) {
    if (!project.budget || !project.budget.total) return 50;

    const projectBudget = project.budget.total;
    const minBudget = contractor.pricing.minimumProject || 0;

    if (projectBudget >= minBudget) {
      // Higher budget projects get better scores
      const budgetRatio = projectBudget / (minBudget || 1);
      return Math.min(50 + (budgetRatio * 10), 100);
    }

    return 0;
  }

  calculateTimelineScore(contractor, project) {
    if (!project.timeline || !project.timeline.preferredStartDate) return 50;

    const preferredStart = new Date(project.timeline.preferredStartDate);
    const today = new Date();
    const daysUntilStart = Math.floor((preferredStart - today) / (1000 * 60 * 60 * 24));

    // More time = better score for planning
    if (daysUntilStart > 30) return 100;
    if (daysUntilStart > 14) return 80;
    if (daysUntilStart > 7) return 60;
    if (daysUntilStart > 3) return 40;
    if (daysUntilStart >= 0) return 20;

    return 0; // Past date
  }

  calculateUrgencyScore(contractor, project) {
    const urgency = project.matching?.urgencyLevel || 'Medium';
    const availability = contractor.availability.currentProjects;

    if (urgency === 'High' && availability === 0) return 100;
    if (urgency === 'High' && availability === 1) return 80;
    if (urgency === 'Medium') return 60;
    if (urgency === 'Low') return 40;

    return 50;
  }
}

module.exports = new MatchingService();