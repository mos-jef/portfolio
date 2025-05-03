import 'package:flutter/material.dart';

// Data Models for Project Cases
class ProjectData {
  final String id;
  final String title;
  final String subtitle;
  final String originalLink;
  final String heroImage;
  final String logoImage;
  final List<ProjectPage> pages;

  ProjectData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.originalLink,
    this.heroImage = '',
    this.logoImage = '',
    required this.pages,
  });
}

class ProjectPage {
  final String title;
  final List<ContentSection> sections;

  ProjectPage({
    required this.title,
    required this.sections,
  });
}

class ContentSection {
  final String subtitle;
  final String text;
  final String image;

  ContentSection({
    this.subtitle = '',
    required this.text,
    this.image = '',
  });
}
