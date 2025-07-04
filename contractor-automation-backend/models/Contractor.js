const mongoose = require('mongoose');

const contractorSchema = new mongoose.Schema({
  personalInfo: {
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    phone: { type: String, required: true },
    avatar: String,
    businessName: String,
    experience: { type: Number, required: true },
    languages: [String],
    gender: { type: String, enum: ['Male', 'Female', 'Other'] }
  },
  businessInfo: {
    registrationNumber: String,
    gstNumber: String,
    panNumber: String,
    businessType: { type: String, enum: ['Individual', 'Company', 'Partnership'] },
    teamSize: { type: Number, default: 1 },
    establishedYear: Number
  },
  serviceAreas: {
    primary: String,
    secondary: [String],
    maxTravelDistance: { type: Number, default: 50 }
  },
  expertise: {
    categories: [String],
    subcategories: [String],
    specializations: [String],
    configurations: [String],
    propertyTypes: [String]
  },
  pricing: {
    hourlyRate: Number,
    minimumProject: Number,
    consultationFee: Number,
    advancePercentage: { type: Number, default: 30 }
  },
  availability: {
    maxConcurrentProjects: { type: Number, default: 3 },
    currentProjects: { type: Number, default: 0 },
    weeklyHours: { type: Number, default: 40 },
    workingDays: [String],
    timeSlots: [String]
  },
  portfolio: {
    images: [String],
    videos: [String],
    documents: [String],
    testimonials: [String]
  },
  ratings: {
    overall: { type: Number, default: 0 },
    communication: { type: Number, default: 0 },
    quality: { type: Number, default: 0 },
    timeline: { type: Number, default: 0 },
    budget: { type: Number, default: 0 },
    totalReviews: { type: Number, default: 0 }
  },
  verification: {
    profileVerified: { type: Boolean, default: false },
    documentVerified: { type: Boolean, default: false },
    backgroundCheck: { type: Boolean, default: false },
    insuranceVerified: { type: Boolean, default: false }
  },
  projectHistory: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Project' }],
  earnings: {
    totalEarned: { type: Number, default: 0 },
    currentMonthEarning: { type: Number, default: 0 },
    pendingPayments: { type: Number, default: 0 }
  },
  status: { type: String, enum: ['Active', 'Inactive', 'Suspended'], default: 'Active' }
}, {
  timestamps: true
});

module.exports = mongoose.model('Contractor', contractorSchema);