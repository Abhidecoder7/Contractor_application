const mongoose = require('mongoose');

const projectSchema = new mongoose.Schema({
  clientId: { type: mongoose.Schema.Types.ObjectId, ref: 'Client', required: true },
  contractorId: { type: mongoose.Schema.Types.ObjectId, ref: 'Contractor' },
  
  projectDetails: {
    title: { type: String, required: true },
    description: { type: String, required: true },
    category: { type: String, required: true },
    subcategory: String,
    propertyType: { type: String, enum: ['Residential', 'Commercial', 'Industrial'] },
    configuration: { type: String, required: true },
    squareFootage: Number,
    floors: Number,
    rooms: {
      bedrooms: Number,
      bathrooms: Number,
      kitchen: Number,
      livingRooms: Number,
      others: Number
    }
  },
  
  requirements: {
    workType: [String],
    furnishing: { type: String, enum: ['Fully Furnished', 'Semi Furnished', 'Unfurnished'] },
    specialRequirements: [String],
    designStyle: String,
    colorPreferences: [String],
    materialPreferences: [String],
    appliancesIncluded: Boolean,
    customRequests: String
  },
  
  budget: {
    total: { type: Number, required: true },
    breakdown: {
      materials: Number,
      labor: Number,
      design: Number,
      miscellaneous: Number
    },
    paymentSchedule: [String],
    advancePaid: { type: Number, default: 0 },
    remainingAmount: Number
  },
  
  timeline: {
    preferredStartDate: Date,
    expectedCompletionDate: Date,
    actualStartDate: Date,
    actualCompletionDate: Date,
    milestones: [{
      title: String,
      date: Date,
      status: { type: String, enum: ['Pending', 'InProgress', 'Completed'] },
      description: String
    }]
  },
  
  location: {
    address: { type: String, required: true },
    city: { type: String, required: true },
    state: { type: String, required: true },
    pincode: { type: String, required: true },
    coordinates: {
      latitude: Number,
      longitude: Number
    },
    accessibility: String,
    parkingAvailable: Boolean
  },
  
  documents: {
    floorPlans: [String],
    referenceImages: [String],
    permits: [String],
    agreements: [String]
  },
  
  communication: {
    messages: [{
      senderId: mongoose.Schema.Types.ObjectId,
      senderType: { type: String, enum: ['Client', 'Contractor'] },
      message: String,
      timestamp: { type: Date, default: Date.now },
      attachments: [String]
    }],
    meetings: [{
      scheduledDate: Date,
      duration: Number,
      type: { type: String, enum: ['Video', 'Audio', 'InPerson'] },
      notes: String
    }]
  },
  
  progress: {
    overallPercentage: { type: Number, default: 0 },
    phases: [{
      name: String,
      startDate: Date,
      endDate: Date,
      progress: Number,
      status: { type: String, enum: ['NotStarted', 'InProgress', 'Completed'] },
      images: [String]
    }],
    dailyUpdates: [{
      date: Date,
      workDone: String,
      images: [String],
      issuesReported: String
    }]
  },
  
  matching: {
    urgencyLevel: { type: String, enum: ['Low', 'Medium', 'High'], default: 'Medium' },
    algorithmScore: Number,
    alternativeContractors: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Contractor' }],
    reassignmentHistory: [{
      previousContractor: { type: mongoose.Schema.Types.ObjectId, ref: 'Contractor' },
      newContractor: { type: mongoose.Schema.Types.ObjectId, ref: 'Contractor' },
      reason: String,
      date: Date
    }]
  },
  
  quality: {
    inspections: [{
      date: Date,
      inspector: String,
      rating: Number,
      issues: [String],
      images: [String]
    }],
    clientFeedback: [{
      date: Date,
      rating: Number,
      feedback: String,
      images: [String]
    }]
  },
  
  financials: {
    totalCost: Number,
    paidAmount: { type: Number, default: 0 },
    pendingAmount: Number,
    extraCharges: [{
      description: String,
      amount: Number,
      approved: Boolean
    }],
    invoices: [String]
  },
  
  status: { 
    type: String, 
    enum: ['Requested', 'Assigned', 'InProgress', 'Completed', 'Cancelled', 'OnHold'], 
    default: 'Requested' 
  }
}, {
  timestamps: true
});

module.exports = mongoose.model('Project', projectSchema);