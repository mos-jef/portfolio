import 'package:flutter/material.dart';
import 'package:portfolio_website/components/project_data.dart';

// Tap In Project Data
final ProjectData tapInProject = ProjectData(
  id: 'tap-in',
  title: 'Tap In',
  subtitle: 'An all-encompassing B2C mobile application',
  originalLink: 'https://jeffpdx.net/p/02ec6dbb',
  heroImage: 'assets/tapin_header.png',
  logoImage: 'assets/tapin_logo.png',
  pages: [
    // Page 1: Project Overview
    ProjectPage(
      title: 'Project Overview',
      sections: [
        ContentSection(
          text:
              'Jiu-jitsu is a highly social activity, with millions of practitioners worldwide, yet lacks a dedicated application for the communication needs of practitioners and gyms.',
        ),
        ContentSection(
          subtitle: 'Problem',
          text:
              'The nature of jiu-jitsu fosters friendships and gym loyalty to a degree rarely found elsewhere among fitness gyms or competitive sports clubs. However, when outside of the gym interacting with teammates and gym-related events generally requires the utilization of several disparate media and social applications.',
        ),
        ContentSection(
          subtitle: 'Solution',
          text:
              'Tap In remedies these problems by serving as a central hub for gym-related information, content, events, and social media. Gym members can now find the assemblage of gym-specific content in a single resource.',
        ),
        ContentSection(
          subtitle: 'Tools',
          text: 'Miro, Figma, Procreate, Figjam, Zoom, Loom',
        ),
        ContentSection(
          subtitle: 'My Role',
          text:
              'Senior Software Engineer\nSenior UX/UI Designer & Researcher\n\n• Ideation\n• Mental Models\n• Journey Maps\n• User Stories\n• Ethnographic Research\n• Sketching\n• JTBD Interviews\n• Wireframing\n• Prototyping\n• Usability Testing\n• Redesign',
        ),
        ContentSection(
          subtitle: 'Timeline',
          text: '10 months',
        ),
        ContentSection(
          subtitle: 'Process',
          text: 'Discovery, Research, Ideation, Design, Testing, Reflection',
        ),
      ],
    ),

    // Page 2: Research
    ProjectPage(
      title: 'Research',
      sections: [
        ContentSection(
          subtitle: 'Secondary Research',
          text:
              'My secondary research was primarily focused on the role of digital engagement with fitness and martial arts gyms.\n\nI discovered that online engagement with gyms plays a more-than-anomalous part in growing/retaining membership as well as fostering positive opinions of a given gym regardless of long-term membership or new/prospective member.',
        ),
        ContentSection(
          subtitle: 'Primary Research',
          text:
              'My primary research sought to examine how jiu-jitsu practitioners utilize technology in their training, and what they may find helpful, lacking, unhelpful, and/or desire vis-a-vis the use of technology in their gyms. To do this, I would have to directly interview jiu-jitsu members, to wit:',
        ),
        ContentSection(
          subtitle: 'Interviews',
          text:
              'The first step in finding people to interview was to develop a screener survey so that I could find qualified candidates. I chose five candidates of varied ages and skill levels to best represent the ranges in age and skill level typically found within jiu-jitsu gyms. Once the surveys were completed, and qualified candidates were selected, I had to develop an interview script to ensure the interviews would meet the desired objective(s). Once completed, I began the in-person interview process by recording participants as they responded to my questions from the aforementioned script and analyzed the data provided in the recordings.\n\nIn analyzing the data, I discovered that gym members were overwhelmed by the numerous apps required to keep up with social ad media content related to their gym. As well, more than half the interviewees were using several different apps solely for gym information or content.',
        ),
        ContentSection(
          subtitle: 'Affinity Mapping',
          text:
              'Upon analyzing the data from the interviews, I found five threads that every respondent touched upon in some way and began mapping the respective data points. Through affinity mapping, I was able to visually and viscerally understand the data results as well as the dispersal of the data by the interviewee and across demographics.',
        ),
        ContentSection(
          subtitle: 'Empathy Mapping',
          text:
              'From there, I continued looking at the interview data to better understand the thoughts, feelings, actions, and words of the interview subjects and prospective users. I found there were two types of users vis-a-vis digital media/communication and jiu-jitsu and created a visual representation of these users with quotes and sentiments expressed in the interview.',
        ),
      ],
    ),

    // Page 3: Research Outcomes
    ProjectPage(
      title: 'Research Outcomes',
      sections: [
        ContentSection(
          subtitle: 'Personas',
          text:
              'I wanted to form a deeper understanding of users\' goals, needs, experiences, and behaviors. Based on user interviews and surveys, I was able to break the test subjects into two distinct jiu-jitsu personas vis a vis their use of digital media and their gyms.\n\nBy doing so, I was able to more adeptly design the project for features that accommodate the wants, needs, and experiences of jiu-jitsu practitioners as a whole. I kept updating these personas throughout the project as I gathered more data and used these personas whenever I wanted to step out of myself and reconsider my initial ideas.',
        ),
        ContentSection(
          text: 'The Social Content Member\nThe Media Content Member',
        ),
        ContentSection(
          subtitle: 'HMW\'s',
          text:
              'Now that the interviews were complete and the data analyzed, I began the process of thinking about how to put that data into practice and integrate it into development.\n\nTo help me functionally distill the data, I asked myself a series of "how might we (HMW)" questions to integrate design and experience with the data I\'d received, to wit:\n\n• How might we foster social engagement between gym members?\n\n• How might we enable gym members to feel less overwhelmed/confused/unaware?\n\n• How might we enable gym members to find/modulate what they\'re looking for easily?\n\n• How might we improve communication vis-a-vis teammates/coaches/members?\n\n• How might we improve access to information and content alike?',
        ),
      ],
    ),

    // Page 4: Ideation
    ProjectPage(
      title: 'Ideation',
      sections: [
        ContentSection(
          subtitle: 'Brainstorming',
          text:
              'Once the HMWs were complete, it was time to begin brainstorming on the structure and functionality of the app through user stories, sketches of user flows, and site maps.',
        ),
        ContentSection(
          subtitle: 'User Stories',
          text:
              'Before I could begin sketching, I first needed to ascertain what users wanted. For this, I devised a ranked list of importance per certain features or experiences as elaborated from the results of the interviews and personas, to wit:\n\n"I want to toggle alerts so that I can be made aware only about the content of my choosing"\n\n"I want to be able to add and delete my own comments/post-history/account so that I can feel safer sharing and interacting with my teammates and coaches"\n\n"I want to be able to create threads for teammates and coaches to comment on so that I am not beholden to the topics chosen only by the gym/coaches"',
        ),
        ContentSection(
          subtitle: 'Site Map',
          text:
              'Now that I had some ideas about what users wanted and how to incorporate those ideas, I turned to the design and experience facets of development. I created a site map to gauge the layout and flow of the application to come.',
        ),
        ContentSection(
          subtitle: 'User Flows',
          text:
              'From here, I needed to determine how to optimally design intuitive, user-friendly pathways for users to proceed through the app and tailor the prospective experience of the application. To do this, I created a visual guide to represent how such a flow might work, using the most germane functions of the project as described by interviewees, to wit:\n\n• Paying gym fees\n\n• Adding classes to packages\n\n• Checking private notifications',
        ),
        ContentSection(
          subtitle: 'Sketches',
          text:
              'Now that the stories, site maps, and flows were integrated into something tangible, I began to work on sketches in Procreate. I created potential mock-ups of the layout, style, and functionality of the flows above. I explored the orientation of data fields, media, images, shapes, and common practices concerning billing applications.',
        ),
      ],
    ),

    // Page 5: Design Process
    ProjectPage(
      title: 'Design Process',
      sections: [
        ContentSection(
          subtitle: 'Wireframes',
          text:
              'With personas and sketches completed, the focus shifted to a more detailed development stage. I transformed my initial sketches into low-fidelity wireframes, enabling me to evaluate the project\'s functionality and layout. Utilizing common spacing practices, I established hierarchies through size and placement, ensuring a consistent and uniform approach to actions and choices throughout the design.',
        ),
        ContentSection(
          subtitle: 'UI Design',
          text:
              'The vision was to blend elements inspired by athletics and martial arts, all while maintaining a user interface reminiscent of applications familiar to BJJ practitioners. This provided ample creative freedom to explore various vectors of hierarchy, color, aesthetics, and utility.',
        ),
        ContentSection(
          subtitle: 'Mood Board',
          text:
              'To aid in the design process, I curated a mood board to encapsulate the style and essence of the project. Drawing inspiration from Brazilian jiu-jitsu, particularly the Brazilian Top Team school, I focused on the captivating themes of Brazil and the rainforest. My design choices revolved around a harmonious blend of blues, greens, and yellows in different depths and brightness levels.',
        ),
        ContentSection(
          text:
              'Brand personality: your local gym that is equally geared towards serious competitor training and self-defense as well as kids and family-classes',
        ),
        ContentSection(
          subtitle: 'Style Guide',
          text:
              'As the project advanced, major adjustments to the styling were piecemealed into the existing design. Feedback from users and the client at various stages led to the formation of two cohesive styles. Each style theme represents intrinsic qualities imbued within BJJ: on one hand, humility and eagerness of students seeking knowledge, and on the other, the self-discipline and dedication commonly associated with martial arts',
        ),
      ],
    ),

    // Page 6: Testing
    ProjectPage(
      title: 'Testing',
      sections: [
        ContentSection(
          subtitle: 'Prototype',
          text:
              'Now that my high-fidelity wireframes were completed, I still needed to create a prototype to test the usability and experience of the project. For this, I used Figma\'s prototyping feature with my high-fidelity frames and am happy to say that there were very few issues here.',
        ),
        ContentSection(
          subtitle: 'Usability Testing',
          text:
              'Much like my primary research, I would need to find prospective users to test my app and give me feedback that I could incorporate into the design of the project. This too, would require finding candidates for testing, devising a script, and conducting interviews.\n\nFor usability testing, I recruited five more jiu-jitsu practitioners from various backgrounds to test my prototype via assigned tasks which they were to complete, and then give me feedback per pre-selected questions germane to their experience.\n\nI tasked them primary features of the project, which were as follows:\n\n• Update profile images, taglines, and personal details\n\n• Creating a forum post and posting it to the forum home page\n\n• Navigating to the message center to access private messages\n\nThe findings were overwhelmingly positive, but there were a few minor recommendations concerning nomenclature.',
        ),
        ContentSection(
          subtitle: 'Redesign',
          text:
              'The design went through major alterations from beginning to end - and may still go through more in time. Redesigns were a result of user feedback and later-on, user-testing, as well as the client\'s evolving recommendations upon seeing the project progress.',
        ),
      ],
    ),

    // Page 7: Reflection
    ProjectPage(
      title: 'Reflection',
      sections: [
        ContentSection(
          text:
              'This project holds personal significance for me, given my daily training and current brown belt rank in BJJ. Having an understanding of how this app can benefit not only BJJ enthusiasts but also people I interact with regularly made this project particularly exciting and enjoyable.',
        ),
        ContentSection(
          subtitle: 'Next Steps',
          text:
              'Additional features: I would like to integrate live-streaming, add yet another theme (it\'s already half-built if I choose to go for it), add some animations at some point, and add personal media (photos/video) feature similar to facebook or instagram (storage and financial considerations withstanding)\n\nUser implementation: The release of the android application is nigh. I am presently in the user-testing phase vis-a-vis google play store. After successfully launching Tap In on Android, I will tackle the coding, styling, and other App Store/Xcode requirements and get Tap In launched for iOS platforms\n\nThank you for reading my case study!',
        ),
      ],
    ),
  ],
);
