import 'package:flutter/material.dart';
import 'package:portfolio_website/components/project_data.dart';

// CoreAi Project Data
final ProjectData coreAiProject = ProjectData(
  id: 'core-ai',
  title: 'CoreAi',
  subtitle: 'UX/UI designer and researcher',
  originalLink: 'https://jeffpdx.net/p/02175991', 
  heroImage: 'assets/backgroundheader.png',
  logoImage: 'assets/coreai/device1.png',
  pages: [
    // Page 1: Project Overview
    ProjectPage(
      title: 'Project Overview',
      sections: [
        ContentSection(
          text:
              'The organization often has tasks in dashboards to check, which impacts the time to integrate and process data and create metrics, potentially causing hours of unnecessary delays. Additionally, with often incomplete data, core processes could be hindered and even prevented from execution and completion.',
        ),
        ContentSection(
          subtitle: 'Problem',
          text:
              'The organization came to us concerned about their platform\'s inability to keep pace with growing data and analytics needs, particularly with the complexity and difficulties of finding meaningful information for their managers and leadership. This significantly hampered their ability to access accurate, up-to-date metrics.',
        ),
        ContentSection(
          subtitle: 'Solution',
          text:
              'CoreAi facilitates real-time data and communication, that could enhance information flow, enable responsive processes, improve decision-making processes and overall transparency. CoreAi brings transformations by generating dashboards thought differently supporting data-driven collaboration and transparency with minimal lag, enabling teams and departments of all sizes to access a unified single view of multiple pieces of data in a consolidated way.',
        ),
        ContentSection(
          subtitle: 'Tools',
          text: 'Miro\nFigma\nLooms\nLucidchart\nGoogle Workspace\nCanva',
        ),
        ContentSection(
          subtitle: 'My Role',
          text:
              'UX/UI Designer and Researcher\n\n• Ideation\n• Research\n• Journey Maps & User Flows\n• Sketching\n• Wireframing\n• Prototyping\n• Usability Testing\n• Visual Design\n• Design System Work\n• Documentation',
        ),
        ContentSection(
          subtitle: 'Timeline',
          text: '10 months',
        ),
        ContentSection(
          subtitle: 'Process',
          text: 'Discovery\nResearch\nIdeation\nDesign\nDevelopment\nReflection',
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
              'A meeting initial project overview facilitated an understanding between about the organization\'s preferences compared to competition, analyzing the desired architecture functionality and constraints.',
        ),
        ContentSection(
          subtitle: 'Heuristic Evaluation',
          text:
              'Utilized a competitive analysis to gain deeper insights into heuristics and platform trends amongst competitors, their workflows, and practices in the field.',
        ),
        ContentSection(
          text:
              'We conducted a set of basic competitive and proprietary evaluations whilst simultaneously streamlining key patterns and gaps that were either strengths or pain points for users.',
        ),
        ContentSection(
          subtitle: 'Key findings were as follows:',
          text:
              '• Discoverability for finding information\n  - Complex drop-down menus impacting navigation\n  - Limited search and filtering options\n  - Overwhelming volume of dashboards\n\n• Direct vs consequent flows\n  - Confusing interface\n  - Superfluous forms with substantial complexity\n  - Slow performance leading to increased wait times',
        ),
        ContentSection(
          subtitle: 'Competitive Analysis',
          text:
              'We began comparing features in competitors to evaluate performance and functionality, with a focus on usability, consistency in the interface preferences, and what lessons we might learn.',
        ),
        ContentSection(
          text:
              'Our analysis found many key focus areas in the interface improvements with the following:\n\n• Ease of customizability and efficiency of use\n• Different content filter and information breakdown options\n• User-friendly UI/UX with filtering and searching\n• Optimal integration with meeting and reporting',
        ),
      ],
    ),

    // Page 3: Ideation
    ProjectPage(
      title: 'Ideation',
      sections: [
        ContentSection(
          text:
              'We took a closer look at the platform and carefully observed what the platform in pain inspired me to better understand the pain potential users might experiencing vis the site and what elements of what we needed to accomplish.',
        ),
        ContentSection(
          text:
              'We began established communication with the stakeholder arising day by to understand the needs they had in mind and answer any questions about the mockups and the product design. Regular updates were essential to make the product more ideally usable.',
        ),
        ContentSection(
          subtitle: 'Content Analysis',
          text:
              'Immersing ourselves deeply in the platform\'s UX/UI enabled us to evaluate the interface hierarchy and develop a more extensive understanding of user needs, behaviors, and preferences.',
        ),
        ContentSection(
          subtitle: 'User Stories',
          text:
              'With a comprehensive grasp of the stakeholders vision and the required system modifications, I defined a series of user stories to better prioritize work items for system features.',
        ),
        ContentSection(
          text:
              'In discussing flow, we prioritized key tasks first with the team developing a clearer understanding of user needs and how these would interact to work.',
        ),
        ContentSection(
          text:
              '"As a user I want to manage my coaching calendars"\n"As a user I want to complete my feedback requests"\n"As a user I want to schedule a coaching session?"',
        ),
        ContentSection(
          subtitle: 'User Flows',
          text:
              'Building from this plan vision and the functionality needed, the next step is to understand the user journey by identifying how they would move through and complete a task. This enabled me to track the points of contact between elements to consider their path through the user journey.',
        ),
      ],
    ),

    // Page 4: Low and Mid-Fidelity Wireframes
    ProjectPage(
      title: 'Low and Mid-Fidelity Wireframes',
      sections: [
        ContentSection(
          subtitle: 'Wireframing',
          text:
              'Once we had an idea of how content was organized to proceed, we incorporated layouts to design a specific flow within the IA. These would become the base for our findings, identify interactions to be taken, future UX, and potential impediments to the experience.',
        ),
        ContentSection(
          subtitle: 'Mid-Fidelity',
          text:
              'Our teams testing in a collaborative approach, with each member of the 5 person team providing their own specific POV on the feature. Using a structured, systematic approach to manage the interface objects and engagement of interface elements in the next phase, the goal was to consider potential user expectations and enable more comprehensive end-user access.',
        ),
      ],
    ),

    // Page 5: Design
    ProjectPage(
      title: 'Design',
      sections: [
        ContentSection(
          subtitle: 'Mood boards and inspiration',
          text:
              'Utilizing inspiration from competitive applications, corporate, and design influences in the domain influenced how the visual design elements are used.',
        ),
        ContentSection(
          text:
              'As we settled into this, we updated mood boards inspired by the organizations preferences, as well considering their colors in a fresh perspective and through the lens and with our competitive analysis.',
        ),
        ContentSection(
          text:
              'Once again, we leveraged the power of collaborative reviews and improvements, examining shifting designs at intervals, which resulted in the final set designs.',
        ),
        ContentSection(
          subtitle: 'Color Exploration',
          text:
              'During exploration of color choices for the visual style (focusing on the blue shades that standard business consulting-type colors offer), we spent time carefully contrasting the color schemes to ensure accessibility considerations, while still maintaining the expected color palette for usability.',
        ),
        ContentSection(
          subtitle: 'Style Guide',
          text:
              'Through our work and based on exploration approach, we determined the colors for the project. Following this, we augmented the typography, iconography, and digital elements in keeping with established component standards, with an emphasis on maintaining consistency in typography and spacing, ensuring all use cases were integrated for feasibility and eligibility, and we recommended guidelines for sizing, scaling, and positioning.',
        ),
        ContentSection(
          subtitle: 'High Fidelity Wireframes',
          text:
              'With the style guide completed and after finalizing the conceptual approach, we developed comprehensive mockups with detailed component iterations, integrating specific variations of elements to ensure versatility in context. I then standardized the elements for adaptations in layouts, designing in a systematic way. Ultimately, our platform was enhanced by delivering the high-fidelity designs.',
        ),
        ContentSection(
          text:
              'My process focused on designing the page and interaction behaviors while ensuring the content was organized, relying on accessibility, responsive, and consistent patterns. I followed the WCAG guidelines in designing interface elements for user interaction, providing consistent patterns for interface elements that would perform in a similar fashion in other situations.',
        ),
      ],
    ),

    // Page 6: Final Screens
    ProjectPage(
      title: 'Final Screens',
      sections: [
        ContentSection(
          text:
              'After reaching out to specific functions, we had one final meeting with the stakeholders to review and design sign-off before handing over final screens to the development team.',
        ),
      ],
    ),

    // Page 7: Dev Handoff
    ProjectPage(
      title: 'Dev Handoff',
      sections: [
        ContentSection(
          text:
              'We ensured that every design element aligned seamlessly with development requirements, paying attention to visual consistency and documentation. The next steps job was handled by the development team, applying a prudent review of our documented work fulfilled in creating our style, the detailed markup, and the brand of the overall style sheet page itself to guarantee a successful delivery.',
        ),
      ],
    ),

    // Page 8: Reflection
    ProjectPage(
      title: 'Reflection',
      sections: [
        ContentSection(
          text:
              'CoreAi has an exciting project as well which functionally does a task that the company and other of its companies currently use, or in a similar structure. Being able to present this style to a specific presenter was gratifying.',
        ),
        ContentSection(
          text:
              'Working with a team of exceptional individuals who encouraged feedback along the way made the client very satisfied with my role, and appreciative of my communication, structured and progress tracking specific to the challenge present there.',
        ),
        ContentSection(
          text:
              'Our approach included a balance of detail and usability for more complex development of the major design elements creating a visually appealing interface for intuitive access to equally "technical" information.',
        ),
        ContentSection(
          text: 'Thank you for reading my case study!',
        ),
      ],
    ),
  ],
);