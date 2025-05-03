import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nes_ui/nes_ui.dart';
import '../models/project.dart';
import '../models/theme_provider.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isNesTheme = themeProvider.isNesTheme;

    return isNesTheme
        ? buildNesProjectCard(context)
        : buildDefaultProjectCard(context);
  }

  Widget buildNesProjectCard(BuildContext context) {
    return NesContainer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Image Placeholder
            Container(
              height: 100,
              color: Colors.grey.shade300,
              child: Center(
                child: Text(project.title),
              ),
            ),
            const SizedBox(height: 16),
            // Project Title
            Text(
              project.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            // Project Description
            Text(
              project.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            // Tech Stack
            Wrap(
              spacing: 8,
              children: project.technologies.map((tech) {
                return NesContainer(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    tech,
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            // Project Links
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NesButton(
                  type: NesButtonType.primary,
                  onPressed: () {
                    // Open project URL
                  },
                  child: const Text('View'),
                ),
                NesButton(
                  type: NesButtonType.normal,
                  onPressed: () {
                    // Open GitHub URL
                  },
                  child: const Text('Code'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDefaultProjectCard(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Image Placeholder
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(project.title),
              ),
            ),
            const SizedBox(height: 16),
            // Project Title
            Text(
              project.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            // Project Description
            Text(
              project.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            // Tech Stack
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: project.technologies.map((tech) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tech,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade800,
                    ),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            // Project Links
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Open project URL
                  },
                  child: const Text('View Project'),
                ),
                TextButton(
                  onPressed: () {
                    // Open GitHub URL
                  },
                  child: const Text('View Code'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
