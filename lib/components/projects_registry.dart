import 'package:portfolio_website/components/project_data.dart';
import 'package:portfolio_website/revised_case_studies/tap_in.dart';
import 'package:portfolio_website/revised_case_studies/moments.dart';

// A registry of all available portfolio projects
class ProjectsRegistry {
  // Singleton implementation
  static final ProjectsRegistry _instance = ProjectsRegistry._internal();

  factory ProjectsRegistry() {
    return _instance;
  }

  ProjectsRegistry._internal();

  // Get a specific project by ID - USING REVISED CASE STUDIES ONLY
  // Get a specific project by ID - USING REVISED CASE STUDIES ONLY
  ProjectData getProject(String projectId) {
    switch (projectId.toLowerCase()) {
      case 'tap-in':
        return tapInStudy; // This now comes from revised_case_studies/tap_in.dart
      case 'moments':
        return momentsStudy; // This now comes from revised_case_studies/moments.dart
      default:
        // Default to Tap In if project ID not found
        return tapInStudy; // Using revised version
    }
  }

// Get all available projects - RESTRICTED to only Tap-In and Moments
  List<ProjectData> getAllProjects() {
    return [
      tapInStudy,
      momentsStudy,
      // Removed coreAiProject and plannieProject - only showing revised case studies
    ];
  }

  // Get project IDs for menu display - RESTRICTED to revised case studies only
  List<Map<String, String>> getProjectsForMenu() {
    return [
      {'id': 'this-website', 'title': 'This Website'},
      {'id': 'tap-in', 'title': 'Tap In'},
      {'id': 'moments', 'title': 'Moments'},
      // Removed core-ai and plannie - only showing revised case studies
    ];
  }
}
