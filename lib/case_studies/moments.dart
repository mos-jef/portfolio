import 'package:flutter/material.dart';
import 'package:portfolio_website/components/project_data.dart';

// Moments Project Data
final ProjectData momentsProject = ProjectData(
  id: 'moments',
  title: 'Moments',
  subtitle: 'A member-based B2C social media application',
  originalLink: 'https://jeffpdx.net/p/02db657c',
  heroImage: 'assets/backgroundheader.png',
  logoImage: 'assets/moments/devices/hero.png',  //"D:\Jeff\portfolio_website\assets\moments\devices\hero.png"
  pages: [
    // Page 1: Project Overview
    ProjectPage(
      title: 'Project Overview',
      sections: [
        ContentSection(
          text:
              'Moments is a UX/UI Designer & Developer (member-based) B2C social media application aiming to redefine the landscape.',
        ),
        ContentSection(
          subtitle: 'Problem',
          text:
              'The contemporary environment brought with it rampant bloating associated with excessive social comparisons, advertising, and data collection. Members were frustrated by the sheer amount of "noise" inherent to contemporary apps and desired a return to the fundamental value of social media.',
        ),
        ContentSection(
          subtitle: 'Solution',
          text:
              'With its foundational aim and minimalist focus calling upon a "less is more" UX approach, the design of Moments allows family and friends to enjoy the simplicity of a pre-social-comparison era. Moments focuses on experiences, not data collection, vanity metrics, or advertisements.',
        ),
        ContentSection(
          subtitle: 'Tools',
          text: 'Figma, Miro, FigJam, Procreate, Illustrator, Zoom, Loom',
        ),
        ContentSection(
          subtitle: 'My Role',
          text:
              'UX/UI Designer & Developer\n\n• Ideation\n• Mental Models\n• Journey Maps\n• User Stories\n• Ethnographic Research\n• Sketching\n• JTBD Interviews\n• Wireframing\n• Prototyping\n• Usability Testing\n• Redesign',
        ),
        ContentSection(
          subtitle: 'Timeline',
          text: '8 months',
        ),
        ContentSection(
          subtitle: 'Process',
          text: 'Discovery, Prototyping, User Testing, Dev Handoff, Reflection',
        ),
      ],
    ),

    // Page 2: Discovery
    ProjectPage(
      title: 'Discovery',
      sections: [
        ContentSection(
          subtitle: 'Kick-off',
          text:
              'Before beginning any actual research, I wanted to get a clear picture of the situation as it currently existed. I began examining social media applications thoroughly, noting their strengths, weaknesses, and opportunities.',
        ),
        ContentSection(
          text:
              'This initial exploration helped me locate potential areas to focus on that would resonate with users and provide value. What questions did users have? What were their pain points? What were common complaints? What would make their experience better?',
        ),
        ContentSection(
          text:
              'After examining and breaking down some of the current designs, specifically social media apps, I discovered several key areas for potential improvement and began considering features and mechanisms that would address common pain points.',
        ),
        ContentSection(
          text:
              'In this process, attempts to bridge the gap between our technical capabilities and user needs yielded key insights. I identified the need for a platform that prioritizes the core values of sharing moments without the noise of excessive features and advertisements.',
        ),
      ],
    ),

    // Page 3: Research
    ProjectPage(
      title: 'Research',
      sections: [
        ContentSection(
          subtitle: 'Secondary Research',
          text:
              'My secondary research focused on the evolving landscape of social media and user sentiment toward existing platforms. I discovered growing dissatisfaction with data collection practices, algorithm-driven content, and the mental health impacts of social comparison.',
        ),
        ContentSection(
          subtitle: 'Primary Research',
          text:
              'To gain deeper insights, I conducted interviews with potential users across different demographic groups. The research aimed to understand their current social media habits, pain points, and desires for a more authentic platform.',
        ),
        ContentSection(
          subtitle: 'Interviews',
          text:
              'I selected ten candidates representing diverse age groups, professions, and digital literacy levels. The interviews revealed consistent themes around privacy concerns, content overload, and a desire to return to more meaningful connections rather than performative sharing.',
        ),
        ContentSection(
          subtitle: 'Key Findings',
          text:
              '• Users expressed fatigue with current platforms\' focus on metrics and engagement\n• Many reported feeling anxious about posting content due to perceived judgment\n• There was strong interest in platforms that prioritize genuine moments over polished content\n• Users valued privacy controls and transparent data practices\n• The ability to share with specific groups rather than broadcasting was highly desired',
        ),
      ],
    ),

    // Page 4: Prototyping
    ProjectPage(
      title: 'Prototyping',
      sections: [
        ContentSection(
          subtitle: 'Wireframes',
          text:
              'Based on research insights, I created low-fidelity wireframes focusing on simplicity and core functionality. The design prioritized the sharing experience while minimizing distractions like metrics, suggestions, and advertisements.',
        ),
        ContentSection(
          subtitle: 'Design System',
          text:
              'I developed a clean, minimalist design system with abundant white space to create a calm, focused user experience. The color palette uses soft blues and whites to evoke a sense of clarity and tranquility, contrasting with the visual noise of competitor apps.',
        ),
        ContentSection(
          subtitle: 'Interactive Prototype',
          text:
              'The high-fidelity prototype incorporated intuitive gestures for navigation and interaction. Key features included a streamlined posting process, customizable sharing circles, and chronological content viewing without algorithmic intervention.',
        ),
        ContentSection(
          text:
              'The core functionality focused on capturing and sharing moments with specific groups, removing the pressure of public broadcasting and performance metrics that characterize other platforms.',
        ),

        ContentSection(
          subtitle: 'Figma Prototype',
          text:
              'Below you can explore the interactive Figma prototype demonstrating the application\'s core user flows and interactions. Click the button to open the full interactive experience.',
        ),

        ContentSection(
          subtitle: 'Device Mockups',
          text:
              'Below you can see the various device mockups showcasing the application\'s interface and key features. The design emphasizes simplicity, clean typography, and an uncluttered user experience.',
          image:
              '', // This will be handled by a custom image carousel in the portfolio viewer
        ),
      ],
    ),

    // Page 5: User Testing
    ProjectPage(
      title: 'User Testing',
      sections: [
        ContentSection(
          subtitle: 'Testing Methodology',
          text:
              'After developing the Moments prototype, I conducted usability testing with potential users. Participants were given specific tasks to complete while thinking aloud, allowing me to identify pain points and areas for improvement.',
        ),
        ContentSection(
          subtitle: 'Key Insights',
          text:
              'The user testing revealed valuable insights that influenced the final design:\n\n• Users appreciated the simplified interface but needed clearer indicators for sharing settings\n• The global map feature was highly engaging but needed more explanation\n• Some users expected to see notification counts but appreciated the option to disable them\n• The chronological feed was strongly preferred over algorithmic content arrangement',
        ),
        ContentSection(
          subtitle: 'Iterations',
          text:
              'Based on testing feedback, I implemented several design iterations:\n\n• Added subtle visual cues for sharing privacy settings\n• Created an onboarding tutorial for the global map feature\n• Refined navigation to reduce cognitive load\n• Enhanced photo editing tools while maintaining simplicity',
        ),
      ],
    ),

    // Page 6: Final Screens
    ProjectPage(
      title: 'Final Screens',
      sections: [
        ContentSection(
          subtitle: 'Polished Design',
          text:
              'With user testing insights incorporated, I finalized the design with attention to visual hierarchy and accessibility. The final screens maintained the minimalist approach while addressing all identified usability concerns.',
        ),
        ContentSection(
          subtitle: 'Key Features',
          text:
              '• Clean, distraction-free interface\n• Private sharing circles for targeted content sharing\n• Chronological feed without algorithmic manipulation\n• Global map to discover moments from around the world\n• Minimalist profile without engagement metrics\n• Simple photo editing with subtle filters',
        ),
        ContentSection(
          subtitle: 'Interaction Design',
          text:
              'The interaction design focused on reducing friction in the sharing process. Users can capture, edit, and share moments in three steps, compared to the industry average of five to seven steps on other platforms.',
        ),
      ],
    ),

    // Page 7: Dev Handoff
    ProjectPage(
      title: 'Dev Handoff',
      sections: [
        ContentSection(
          subtitle: 'Documentation',
          text:
              'To facilitate a smooth handoff to developers, I created comprehensive documentation including component libraries, interaction specifications, and accessibility requirements. Each screen was annotated with precise measurements and behavior notes.',
        ),
        ContentSection(
          subtitle: 'Design System',
          text:
              'The complete design system included:\n\n• Typography scale and usage guidelines\n• Color palette with accessibility compliance notation\n• Component library with states and variants\n• Spacing and layout grids\n• Animation timing and easing specifications',
        ),
        ContentSection(
          subtitle: 'Developer Collaboration',
          text:
              'Throughout the handoff process, I worked closely with developers to ensure design integrity and address technical constraints. This collaborative approach resulted in minimal design compromises while maintaining technical feasibility.',
        ),
        ContentSection(
          subtitle: 'Handoff Documentation',
          text:
              'Below are examples of the detailed documentation provided to the development team to ensure accurate implementation of the design.',
          image:
              '', // This will be handled by a custom image carousel in the portfolio viewer
        ),
      ],
    ),

    // Page 8: Reflection
    ProjectPage(
      title: 'Reflection',
      sections: [
        ContentSection(
          text:
              'Designing Moments was a rewarding challenge that allowed me to explore the balance between functionality and simplicity. The project reinforced my belief that successful digital products don\'t necessarily need more features—they need more thoughtfully implemented ones.',
        ),
        ContentSection(
          subtitle: 'Challenges',
          text:
              'The greatest challenge was resisting feature creep. There was constant temptation to add "just one more feature" that competitors offered. Staying true to the minimalist vision required discipline and continuous referencing of user research to validate design decisions.',
        ),
        ContentSection(
          subtitle: 'Learnings',
          text:
              'This project strengthened my skills in user research, interaction design, and developer collaboration. I learned that creating a truly user-centered product often means having the courage to exclude features that don\'t serve the core user needs, even when they\'re industry standards.',
        ),
        ContentSection(
          subtitle: 'Next Steps',
          text:
              'As Moments moves into development, I\'m continuing to refine the design based on technical feedback. Future plans include exploring additional accessibility features and preparing for beta testing with a diverse user group.',
        ),
        ContentSection(
          text: 'Thank you for reading my case study!',
        ),
      ],
    ),
  ],
);
