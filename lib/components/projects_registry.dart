import 'package:portfolio_website/components/project_data.dart';
import 'package:portfolio_website/case_studies/tap_in.dart';
import 'package:portfolio_website/case_studies/moments.dart';
import 'package:portfolio_website/case_studies/core_ai.dart';
import 'package:portfolio_website/case_studies/plannie.dart';

// A registry of all available portfolio projects
class ProjectsRegistry {
  // Singleton implementation
  static final ProjectsRegistry _instance = ProjectsRegistry._internal();

  factory ProjectsRegistry() {
    return _instance;
  }

  ProjectsRegistry._internal();

  // Get a specific project by ID
  ProjectData getProject(String projectId) {
    switch (projectId.toLowerCase()) {
      case 'tap-in':
        return tapInProject;
      case 'moments':
        return momentsProject;
      case 'core-ai':
        return coreAiProject;
      case 'plannie':
        return plannieProject;
      case 'this-website':
        // Simple project for the website itself
        return ProjectData(
          id: 'this-website',
          title: 'Portfolio Website',
          subtitle: 'The website you\'re viewing right now',
          originalLink: 'https://jeffpdx.net',
          pages: [
            ProjectPage(
              title: 'Project Overview',
              sections: [
                ContentSection(
                  text: 'I made this portfolio website!',
                ),
                ContentSection(
                  subtitle: 'Technologies',
                  text: 'Flutter, Dart, Provider, NES UI, and more.',
                ),
              ],
            ),
          ],
        );
      default:
        // Default to Tap In if project ID not found
        return tapInProject;
    }
  }

  // Get all available projects
  List<ProjectData> getAllProjects() {
    return [
      tapInProject,
      momentsProject,
      coreAiProject,
      plannieProject,
      // Add more projects here as they're created
    ];
  }

  // Get project IDs for menu display
  List<Map<String, String>> getProjectsForMenu() {
    return [
      {'id': 'this-website', 'title': 'This Website'},
      {'id': 'tap-in', 'title': 'Tap In'},
      {'id': 'moments', 'title': 'Moments'},
      {'id': 'core-ai', 'title': 'CoreAi'},
      {'id': 'plannie', 'title': 'Plannie'},
      // Add more projects here as they're created
    ];
  }
}
