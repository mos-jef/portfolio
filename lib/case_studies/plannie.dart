import 'package:flutter/material.dart';
import 'package:portfolio_website/components/project_data.dart';
import 'package:url_launcher/url_launcher.dart';

// Plannie Project Data
final ProjectData plannieProject = ProjectData(
  id: 'plannie',
  title: 'Plannie',
  subtitle: 'UX/UI Designer for B2C enhancement project | Event planning website',
  originalLink: 'https://jeffpdx.net/p/YouJitsu',
  heroImage: 'assets/backgroundheader.png',
  logoImage: 'assets/plannie/device4.png',
  pages: [
    // Page 1: Project Overview
    ProjectPage(
      title: 'Project Overview',
      sections: [
        ContentSection(
          text:
              'Plannie is a network of sites global event planners that can be hired on demand for any size of project. Its these boring but getting UX refreshed in 2022.',
        ),
        ContentSection(
          subtitle: 'Problem',
          text:
              'There is currently no interactive platform enabling direct communication between users and planners without Plannie\'s intervention.',
        ),
        ContentSection(
          subtitle: 'Solution',
          text:
              'As the company gets bigger, there is more necessity for Plannie to be able to take a hands-off stance where one can interact more closely with their users while maintaining profits. As such an inclusive, clear, and streamlined interface for planners to grow and earn commissions.',
        ),
        ContentSection(
          subtitle: 'Tools',
          text: '• Figma\n• Miro\n• Loom',
        ),
        ContentSection(
          subtitle: 'My Role',
          text:
              '• UX design\n• Prototyping\n• Research',
        ),
        ContentSection(
          subtitle: 'Process',
          text: '• Discovery\n• Design\n• Prototyping\n• Reflection',
        ),
      ],
    ),

    // Page 2: Design
    ProjectPage(
      title: 'Design',
      sections: [
        ContentSection(
          subtitle: 'What was needed',
          text:
              'Keeping with a very contemporary, modern, sleek design, I used Material UI to investigate the design files for compliance, and this helped my task considerably, resulting from experience dealing with dashboards. The search page view has to remain through the navigation but, and considering there are unique pages (like the planner dashboard, the events page) this helped navigate screens easier.',
        ),
        ContentSection(
          subtitle: 'Planner Dashboard ticket',
          text:
              'All events, ticketed, and single-ticket/by should be easily accessible via the dashboard, with each having its own content area, with opportunities to grow as demand increases. The planner should be able to click into an event or ticketed event rather than having to go through a list. Additionally, a breakdown of the data that matters to them, such as the size of the event, address to the location as well as the budget allotted for the event. All of this should be contextual in terms of the type of event registered under the profile.\n\nAnother section of the page that would address is the elements of messages. Users that have contacted various planners should be able to view this as well, either by having a dropdown or by having an alert system. Additionally, if there\'s a popup indicating new messages, this should be highlighted via a badge.\n\nTheres hope that the Dashboard page or landscape is similar to how the Events page is, as well as the clients list and ticketed events.',
        ),
        ContentSection(
          subtitle: 'Events Page ticket',
          text:
              'Just order (recent first) which allows one to find events easier to moderate.\n\nThis events page should be accessible through the Nav Bar Slider menu. Links should include or could include:\n• The Navigation\n• Planners\n• Events\n• Tickets\n• Tag category\n\nThis page is essentially a messaging area on the right of the Events detail window. The user creates a dialogue for what the client sends back. Detailed page with information for planners to communicate to clients in that row.',
        ),
        ContentSection(
          subtitle: 'What was done',
          text:
              'I reworked the Dashboard and Events pages for improving clarity, took CTAs from the Hilden page (assessing the styling). I also took some cues with existing preferences across the site to maintain cohesiveness and fluidity.\n\nFurthermore, I conducted a thorough overhaul of the Events page, making significant changes to the Nav Bar Navigation Design layout, as well as the Events page itself, focusing on creating a better UX for clients, improving the purchasing experience. Communication between planners and users.',
        ),
      ],
    ),

    // Page 3: Prototyping
    ProjectPage(
      title: 'Prototyping',
      sections: [
        ContentSection(
          text:
              'Now that the structural interface issues were remedied, it was time to put everything together in the form of a prototype, to illustrate how the improvements to the website will function.',
        ),
        ContentSection(
          text:
              'I created an interactive prototype to demonstrate the improved user flow and functionality. The prototype showcases the key screens including the dashboard and events pages, allowing stakeholders to experience the enhanced interface before implementation.',
          image: '',
        ),
      ],
    ),

    // Page 4: Reflection
    ProjectPage(
      title: 'Reflection',
      sections: [
        ContentSection(
          text:
              'Plannie was a gratifying project. It seems the design assets I consolidated were beneficial and contextualized for other good leads to marketing.',
        ),
        ContentSection(
          text:
              'Developing within the parameters granted to me was more of a challenge than any other aspect of layout and design consideration and enabled an exciting re-definition of design. I think extensive planning helps overall with project scope.',
        ),
        ContentSection(
          text:
              'If given more time and scope with Plannie, I would have liked to optimize the user flow and visual design of the platform. There was a lot to work with in the regards.',
        ),
        ContentSection(
          text: 'Thank you for reading my case study!',
        ),
      ],
    ),
  ],
);