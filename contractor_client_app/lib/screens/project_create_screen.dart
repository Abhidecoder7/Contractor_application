// lib/screens/project_create_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../models/project.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/dropdown_field.dart';

class ProjectCreateScreen extends StatefulWidget {
  @override
  _ProjectCreateScreenState createState() => _ProjectCreateScreenState();
}

class _ProjectCreateScreenState extends State<ProjectCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Form controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _budgetController = TextEditingController();
  final _squareFootageController = TextEditingController();
  final _customRequestsController = TextEditingController();

  // Form data
  String _selectedCategory = 'residential';
  String _selectedConfiguration = '1bhk';
  String _selectedPropertyType = 'apartment';
  List<String> _selectedWorkTypes = [];
  String _selectedFurnishing = 'unfurnished';
  String _selectedDesignStyle = 'modern';
  List<String> _selectedColors = [];
  DateTime? _preferredStartDate;
  DateTime? _expectedCompletionDate;
  int _bedrooms = 1;
  int _bathrooms = 1;
  int _floors = 1;

  final List<String> _categories = ['residential', 'commercial', 'industrial'];
  final List<String> _configurations = ['1bhk', '2bhk', '3bhk', '4bhk', '5bhk'];
  final List<String> _propertyTypes = ['apartment', 'villa', 'office', 'shop', 'warehouse'];
  final List<String> _workTypes = ['construction', 'renovation', 'interior', 'plumbing', 'electrical'];
  final List<String> _furnishingTypes = ['unfurnished', 'semi-furnished', 'fully-furnished'];
  final List<String> _designStyles = ['modern', 'traditional', 'contemporary', 'minimalist'];
  final List<String> _colorOptions = ['neutral', 'warm', 'cool', 'bold', 'earthy'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Project'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                _buildBasicInfoStep(),
                _buildLocationStep(),
                _buildRequirementsStep(),
                _buildBudgetTimelineStep(),
              ],
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: List.generate(4, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: index <= _currentStep ? AppColors.primary : AppColors.border,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 24),
            CustomTextField(
              label: 'Project Title',
              hint: 'Enter a title for your project',
              controller: _titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a project title';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            CustomTextField(
              label: 'Description',
              hint: 'Describe your project requirements',
              controller: _descriptionController,
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            DropdownField(
              label: 'Category',
              value: _selectedCategory,
              items: _categories,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            SizedBox(height: 16),
            DropdownField(
              label: 'Configuration',
              value: _selectedConfiguration,
              items: _configurations,
              onChanged: (value) {
                setState(() {
                  _selectedConfiguration = value!;
                });
              },
            ),
            SizedBox(height: 16),
            DropdownField(
              label: 'Property Type',
              value: _selectedPropertyType,
              items: _propertyTypes,
              onChanged: (value) {
                setState(() {
                  _selectedPropertyType = value!;
                });
              },
            ),
            SizedBox(height: 16),
            CustomTextField(
              label: 'Square Footage',
              hint: 'Enter area in sq ft',
              controller: _squareFootageController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Text(
              'Number of Rooms',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildRoomCounter('Bedrooms', _bedrooms, (value) {
                    setState(() {
                      _bedrooms = value;
                    });
                  }),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildRoomCounter('Bathrooms', _bathrooms, (value) {
                    setState(() {
                      _bathrooms = value;
                    });
                  }),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildRoomCounter('Floors', _floors, (value) {
              setState(() {
                _floors = value;
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 24),
          CustomTextField(
            label: 'Address',
            hint: 'Enter complete address',
            controller: _addressController,
            maxLines: 2,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the address';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          CustomTextField(
            label: 'City',
            hint: 'Enter city',
            controller: _cityController,
          ),
          SizedBox(height: 16),
          CustomTextField(
            label: 'State',
            hint: 'Enter state',
            controller: _stateController,
          ),
          SizedBox(height: 16),
          CustomTextField(
            label: 'Pincode',
            hint: 'Enter pincode',
            controller: _pincodeController,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementsStep() {
    return Center(child: Text('Requirements Step')); // TODO: Implement this step
  }

  Widget _buildBudgetTimelineStep() {
    return Center(child: Text('Budget & Timeline Step')); // TODO: Implement this step
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: CustomButton(
                text: 'Previous',
                color: AppColors.primary,
                onPressed: () {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                isOutlined: true,
              ),
            ),
          if (_currentStep > 0) SizedBox(width: 16),
          Expanded(
            child: CustomButton(
              text: _currentStep == 3 ? 'Submit' : 'Next',
              color: AppColors.primary,
              onPressed: () {
                if (_currentStep == 3) {
                  // Submit form
                  if (_formKey.currentState!.validate()) {
                    // TODO: Submit data to provider or API
                  }
                } else {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCounter(String label, int value, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: value > 0 ? () => onChanged(value - 1) : null,
            ),
            Text('$value'),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => onChanged(value + 1),
            ),
          ],
        )
      ],
    );
  }
}