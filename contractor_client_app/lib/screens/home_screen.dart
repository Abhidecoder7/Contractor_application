// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/project_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/project_card.dart';
import '../widgets/dashboard_stats.dart';
import 'project_create_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch projects once the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().fetchProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ContractorConnect'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Text(
                user?.name.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _DashboardTab(),
          _ProjectsTab(),
          _ContractorsTab(),
          _MessagesTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Contractors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            activeIcon: Icon(Icons.chat),
            label: 'Messages',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProjectCreateScreen()),
                );
              },
            )
          : null,
    );
  }
}

/* ---------------- Dashboard Tab ---------------- */

class _DashboardTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardStats(),
          const SizedBox(height: 24),
          const Text(
            'Recent Projects',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Consumer<ProjectProvider>(
            builder: (_, projectProvider, __) {
              if (projectProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              final recent = projectProvider.projects.take(3).toList();
              return Column(
                children: recent.map((p) => ProjectCard(project: p)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

/* ---------------- Projects Tab ---------------- */

class _ProjectsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (_, projectProvider, __) {
        if (projectProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: projectProvider.projects.length,
          itemBuilder: (_, i) => ProjectCard(project: projectProvider.projects[i]),
        );
      },
    );
  }
}

/* ---------------- Contractors Tab ---------------- */

class _ContractorsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace with real contractor list when provider is ready
    return _PlaceholderTab(
      icon: Icons.people_outline,
      title: 'Contractors',
      subtitle: 'Find and connect with contractors',
    );
  }
}

/* ---------------- Messages Tab ---------------- */

class _MessagesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace with real chat list when ready
    return _PlaceholderTab(
      icon: Icons.chat_outlined,
      title: 'Messages',
      subtitle: 'Communicate with your contractors',
    );
  }
}

/* ---------------- Generic Placeholder ---------------- */

class _PlaceholderTab extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _PlaceholderTab({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}