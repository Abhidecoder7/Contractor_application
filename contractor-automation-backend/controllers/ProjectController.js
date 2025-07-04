const Project = require('../models/Project');
const Client = require('../models/Client');
const Contractor = require('../models/Contractor');
const MatchingService = require('../services/MatchingService');
const NotificationService = require('../services/NotificationService');

class ProjectController {
  async createProject(req, res) {
    try {
      const {
        clientId,
        projectDetails,
        requirements,
        budget,
        timeline,
        location,
        documents,
        matching
      } = req.body;

      // Validate required fields
      if (!clientId || !projectDetails || !budget || !location) {
        return res.status(400).json({
          success: false,
          message: 'Missing required fields'
        });
      }

      // Create project
      const project = new Project({
        clientId,
        projectDetails,
        requirements,
        budget: {
          ...budget,
          remainingAmount: budget.total - (budget.advancePaid || 0)
        },
        timeline,
        location,
        documents,
        matching,
        status: 'Requested'
      });

      await project.save();

      // Find matching contractors
      const matchingResult = await MatchingService.findBestMatches(req.body);

      if (matchingResult.success && matchingResult.matches.length > 0) {
        // Auto-assign to best match if score is high enough
        const bestMatch = matchingResult.matches[0];
        
        if (bestMatch.score >= 80) {
          await this.assignContractor(project._id, bestMatch.contractor._id);
        }

        // Store alternative contractors
        project.matching.alternativeContractors = matchingResult.matches
          .slice(1, 4)
          .map(match => match.contractor._id);
        
        await project.save();
      }

      // Populate and return
      const populatedProject = await Project.findById(project._id)
        .populate('clientId', 'personalInfo')
        .populate('contractorId', 'personalInfo businessInfo ratings')
        .populate('matching.alternativeContractors', 'personalInfo businessInfo ratings');

      res.status(201).json({
        success: true,
        message: 'Project created successfully',
        project: populatedProject,
        matchingResult
      });

    } catch (error) {
      console.error('Create project error:', error);
      res.status(500).json({
        success: false,
        message: 'Error creating project',
        error: error.message
      });
    }
  }

  async assignContractor(projectId, contractorId) {
    try {
      // Update project
      const project = await Project.findByIdAndUpdate(
        projectId,
        {
          contractorId,
          status: 'Assigned',
          'timeline.actualStartDate': new Date()
        },
        { new: true }
      );

      // Update contractor's current projects
      await Contractor.findByIdAndUpdate(
        contractorId,
        {
          $inc: { 'availability.currentProjects': 1 },
          $push: { 'projectHistory': projectId }
        }
      );

      // Send notifications
      await NotificationService.sendContractorAssignment(contractorId, projectId);
      await NotificationService.sendClientAssignment(project.clientId, contractorId);

      return project;

    } catch (error) {
      console.error('Assign contractor error:', error);
      throw error;
    }
  }

  async updateProgress(req, res) {
    try {
      const { projectId } = req.params;
      const { progress, phase, dailyUpdate } = req.body;

      const updateData = {};

      if (progress !== undefined) {
        updateData['progress.overallPercentage'] = progress;
      }

      if (phase) {
        updateData.$push = { 'progress.phases': phase };
      }

      if (dailyUpdate) {
        updateData.$push = { 'progress.dailyUpdates': dailyUpdate };
      }

      const project = await Project.findByIdAndUpdate(
        projectId,
        updateData,
        { new: true }
      ).populate('clientId contractorId');

      // Send progress notification to client
      await NotificationService.sendProgressUpdate(project.clientId._id, projectId, progress);

      res.json({
        success: true,
        message: 'Progress updated successfully',
        project
      });

    } catch (error) {
      console.error('Update progress error:', error);
      res.status(500).json({
        success: false,
        message: 'Error updating progress',
        error: error.message
      });
    }
  }

  async getProjectDetails(req, res) {
    try {
      const { projectId } = req.params;

      const project = await Project.findById(projectId)
        .populate('clientId', 'personalInfo address preferences')
        .populate('contractorId', 'personalInfo businessInfo ratings portfolio')
        .populate('matching.alternativeContractors', 'personalInfo businessInfo ratings');

      if (!project) {
        return res.status(404).json({
          success: false,
          message: 'Project not found'
        });
      }

      res.json({
        success: true,
        project
      });

    } catch (error) {
      console.error('Get project details error:', error);
      res.status(500).json({
        success: false,
        message: 'Error fetching project details',
        error: error.message
      });
    }
  }

  async getClientProjects(req, res) {
    try {
      const { clientId } = req.params;
      const { status, page = 1, limit = 10 } = req.query;

      const query = { clientId };
      if (status) query.status = status;

      const projects = await Project.find(query)
        .populate('contractorId', 'personalInfo businessInfo ratings')
        .sort({ createdAt: -1 })
        .limit(limit * 1)
        .skip((page - 1) * limit);

      const total = await Project.countDocuments(query);

      res.json({
        success: true,
        projects,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total,
          pages: Math.ceil(total / limit)
        }
      });

    } catch (error) {
      console.error('Get client projects error:', error);
      res.status(500).json({
        success: false,
        message: 'Error fetching client projects',
        error: error.message
      });
    }
  }

  async getContractorProjects(req, res) {
    try {
      const { contractorId } = req.params;
      const { status, page = 1, limit = 10 } = req.query;

      const query = { contractorId };
      if (status) query.status = status;

      const projects = await Project.find(query)
        .populate('clientId', 'personalInfo address')
        .sort({ createdAt: -1 })
        .limit(limit * 1)
        .skip((page - 1) * limit);

      const total = await Project.countDocuments(query);

      res.json({
        success: true,
        projects,
        pagination: {
          page: parseInt(page),
          limit: parseInt(limit),
          total,
          pages: Math.ceil(total / limit)
        }
      });

    } catch (error) {
      console.error('Get contractor projects error:', error);
      res.status(500).json({
        success: false,
        message: 'Error fetching contractor projects',
        error: error.message
      });
    }
  }
}

module.exports = new ProjectController();