class Project {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> technologies;
  final String projectUrl;
  final String githubUrl;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.technologies,
    required this.projectUrl,
    required this.githubUrl,
  });

  static List<Project> getDummyProjects() {
    return [
      Project(
        id: '1',
        title: 'E-Commerce Website',
        description: 'A full-stack e-commerce website with user authentication, product filtering, and checkout.',
        imageUrl: 'assets/project1.jpg',
        technologies: ['Flutter', 'Firebase', 'Stripe'],
        projectUrl: 'https://example.com/project1',
        githubUrl: 'https://github.com/yourusername/project1',
      ),
      Project(
        id: '2',
        title: 'Weather App',
        description: 'A mobile app that displays current weather conditions and forecasts for any location.',
        imageUrl: 'assets/project2.jpg',
        technologies: ['Flutter', 'Weather API', 'Bloc'],
        projectUrl: 'https://example.com/project2',
        githubUrl: 'https://github.com/yourusername/project2',
      ),
      Project(
        id: '3',
        title: 'Task Manager',
        description: 'A productivity app for managing daily tasks with reminders and categories.',
        imageUrl: 'assets/project3.jpg',
        technologies: ['Flutter', 'SQLite', 'Provider'],
        projectUrl: 'https://example.com/project3',
        githubUrl: 'https://github.com/yourusername/project3',
      ),
      Project(
        id: '4',
        title: 'Social Media Dashboard',
        description: 'An analytics dashboard that tracks engagement across multiple social media platforms.',
        imageUrl: 'assets/project4.jpg',
        technologies: ['Flutter', 'REST API', 'Charts'],
        projectUrl: 'https://example.com/project4',
        githubUrl: 'https://github.com/yourusername/project4',
      ),
    ];
  }
}