const express = require('express');
const router = express.Router();
const ProjectController = require('../controllers/ProjectController');
const authMiddleware = require('../middleware/auth');

// Create new project
router.post('/', authMiddleware, ProjectController.createProject);

// Get project details
router.get('/:projectId', authMiddleware, ProjectController.getProjectDetails);

// Update project progress
router.patch('/:projectId/progress', authMiddleware, ProjectController.updateProgress);

// Get client projects
router.get('/client/:clientId', authMiddleware, ProjectController.getClientProjects);

// Get contractor projects
router.get('/contractor/:contractorId', authMiddleware, ProjectController.getContractorProjects);

module.exports = router;