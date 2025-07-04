const mongoose = require('mongoose');

const clientSchema = new mongoose.Schema({
  personalInfo: {
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    phone: { type: String, required: true },
    avatar: String,
    dateOfBirth: Date,
    gender: { type: String, enum: ['Male', 'Female', 'Other'] }
  },
  address: {
    street: String,
    city: String,
    state: String,
    pincode: String,
    landmark: String,
    coordinates: {
      latitude: Number,
      longitude: Number
    }
  },
  preferences: {
    budgetRange: {
      min: { type: Number, default: 0 },
      max: { type: Number, default: 1000000 }
    },
    preferredContractorGender: String,
    preferredLanguages: [String],
    previousExperienceLevel: String,
    communicationPreference: { type: String, enum: ['Phone', 'Email', 'Chat', 'All'] }
  },
  verification: {
    phoneVerified: { type: Boolean, default: false },
    emailVerified: { type: Boolean, default: false },
    documentVerified: { type: Boolean, default: false }
  },
  projectHistory: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Project' }],
  savedContractors: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Contractor' }],
  ratings: {
    averageRating: { type: Number, default: 0 },
    totalReviews: { type: Number, default: 0 }
  },
  status: { type: String, enum: ['Active', 'Inactive', 'Blocked'], default: 'Active' }
}, {
  timestamps: true
});

module.exports = mongoose.model('Client', clientSchema);