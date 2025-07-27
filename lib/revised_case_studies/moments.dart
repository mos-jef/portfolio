import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio_website/components/project_data.dart';
import 'package:portfolio_website/revised_case_studies/top_bar.dart';
import 'package:portfolio_website/widgets/case_study_carousel.dart';
import 'package:portfolio_website/widgets/cursor.dart';
import 'package:portfolio_website/widgets/floating_back_to_top_button.dart';
import 'package:portfolio_website/widgets/prototypes.dart';
import 'package:mouse_follower/mouse_follower.dart';
import 'package:flutter/foundation.dart'; 

class MomentsCaseStudy extends StatefulWidget {
  const MomentsCaseStudy({Key? key}) : super(key: key);

  @override
  State<MomentsCaseStudy> createState() => _MomentsCaseStudyState();
}

class _MomentsCaseStudyState extends State<MomentsCaseStudy> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
    Widget build(BuildContext context) {
    return MouseFollower(
      isVisible: kIsWeb, // Only visible on web browsers
      mouseStylesStack: [
        MouseStyle(
        size: const Size(7, 7),
        latency: const Duration(milliseconds: 25),
        opacity: 0.9,
        decoration: BoxDecoration(
          color: Colors.blue.shade600,
          shape: BoxShape.circle,
        ),
        visibleOnHover: false,
      ),
      MouseStyle(
        size: const Size(26, 26),
        latency: const Duration(milliseconds: 75),
        visibleOnHover: false,
        opacity: 0.7,
        child: BeatRing(color: Colors.blue.shade600, size: 26),
      ),
    ],
    onHoverMouseStylesStack: [
      MouseStyle(
        opacity: 0.4,
        size: Size(70, 70),
        latency: Duration(milliseconds: 25),
        child: BeatAnimationCircle(color: Colors.blue.shade600),
      ),
    ],
    child: Scaffold(
      backgroundColor: Colors.white,
      body: Stack(

        children: [
          // Main scrollable content with top padding to avoid overlap
          Padding(
            padding: EdgeInsets.only(top: 70.0), // Match top bar height
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Main content area - Updated with case study content
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section 1: Moments Overview
                        _buildCaseStudySection(
                          title: '',
                          isNarrow: true,
                          transparentBorder: false,
                          customHeight: 1100,
                          showDivider: true,
                          dividerColor: Color(0xFF838383),
                          dividerHeight: 1.0,
                          dividerWidth: 0.7,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final responsiveFontSize =
                                      constraints.maxWidth * 0.08;
                                  final clampedFontSize =
                                      responsiveFontSize.clamp(24.0, 72.0);

                                  return Text(
                                    'Moments',
                                    style: TextStyle(
                                      fontSize: clampedFontSize,
                                      fontFamily: 'Ghasan',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  );
                                },
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final responsiveVerticalSpacing =
                                      constraints.maxWidth * 0.05;
                                  final responsiveSmallSpacing =
                                      constraints.maxWidth * 0.025;
                                  final responsiveLargeSpacing =
                                      constraints.maxWidth * 0.075;

                                  return Column(
                                    children: [
                                      SizedBox(
                                          height: responsiveVerticalSpacing
                                              .clamp(20.0, 60.0)),
                                      Text(
                                        '1. Overview',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(
                                          height: responsiveSmallSpacing.clamp(
                                              15.0, 30.0)),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black87,
                                            height: 1.5,
                                            fontFamily: 'SFPro',
                                          ),
                                          children: [
                                            TextSpan(text: 'Moments '),
                                            TextSpan(
                                              text:
                                                  'redefines online interaction',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                                text:
                                                    ' through its B2C SaaS platform. Unlike other social media clients, Moments was designed as a '),
                                            TextSpan(
                                              text: 'friends-only',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(
                                                text:
                                                    ' picture-sharing network'),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          height: responsiveLargeSpacing.clamp(
                                              40.0, 80.0)),
                                      _buildWireframeImages(),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 60),

                        // Section 2: Role with four subheaders
                        _buildCaseStudySection(
                          title: '',
                          transparentBorder: false,
                          customHeight: 900,
                          showDivider: true,
                          dividerColor: const Color(0xFF838383),
                          dividerHeight: 1.0,
                          dividerWidth: 0.7,
                          content: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              // Header section

                              Text(
                                'Role',
                                style: TextStyle(
                                  fontSize: 60,
                                  fontFamily: 'Ghasan',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  height: 1.2
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 80),

                              // Four subheaders in a row with proper insets
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  // Left spacer for centering

                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(),
                                  ),


                                  // Content area


                                  Expanded(
                                    flex: 6, // Adjust this to control width
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [

                                        // Tools column

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Tools',
                                                style: TextStyle(
                                                  fontSize: 30, // Consistent with other subheaders
                                                  fontFamily: 'SFPro',
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87, // Black as requested
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                '• Figma\n• Zoom\n• Loom',
                                                style: TextStyle(
                                                  fontSize: 24, // Larger for consistency
                                                  fontFamily: 'SFPro',
                                                  color: Colors.black87,
                                                  height: 1.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // My Role column

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('My Role',
                                                style: TextStyle(
                                                  fontSize: 30, // Consistent with other subheaders
                                                  fontFamily: 'SFPro',
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87, // Black as requested
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text( '• UX/UI Designer & Researcher\n• User Testing\n• Quality Control\n• Prototyping\n• Iterative Redesign (hi-fidelity)\n• Dev Handoff',
                                                style: TextStyle(
                                                  fontSize: 24, // Larger for consistency
                                                  fontFamily: 'SFPro',
                                                  color: Colors.black87,
                                                  height: 1.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Timeline column
                                        
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:  CrossAxisAlignment.start,
                                            children: [
                                              Text('Timeline',
                                                style: TextStyle(
                                                  fontSize: 30, // Consistent with other subheaders
                                                  fontFamily: 'SFPro',
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors
                                                      .black87, // Black as requested
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text( '8+ weeks',
                                                style: TextStyle(
                                                  fontSize: 24, // Larger for consistency
                                                  fontFamily: 'SFPro',
                                                  color: Colors.black87,
                                                  height: 1.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Process column

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Process',
                                                style: TextStyle(
                                                  fontSize: 30, // Consistent with other subheaders
                                                  fontFamily: 'SFPro',
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87, // Black as requested
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                '• Prototyping\n• User Testing\n• Dev Handoff\n• Reflection',
                                                style: TextStyle(
                                                  fontSize: 24, // Larger for consistency
                                                  fontFamily: 'SFPro',
                                                  color: Colors.black87,
                                                  height: 1.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Right spacer for centering
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 40),


                        // Move the header above the large title
                        Container(
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              '2. Discovery',
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'SFPro',
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // NEW: Discovery Section:
                        Container(
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              'Mechanisms\nOf\nAbatement',
                              style: TextStyle(
                                fontSize: 60,
                                fontFamily: 'Ghasan',
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        SizedBox(height: 60),

                      // Section Discovery Content with Kickoff, Visualizing, Key Insights, Accomplishments
                        _buildCaseStudySection(
                          title: '',
                          transparentBorder: false,
                          customHeight: 2400, // Increased height to accommodate all content + image
                          showDivider: true,
                          dividerColor: Color(0xFF838383),
                          dividerHeight: 1.0,
                          dividerWidth: 0.7,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              // Kickoff section

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  // Left spacer

                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(),
                                  ),

                                  // Left side - Kickoff label

                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Kickoff',
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontFamily: 'SFPro',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(width: 20),

                                  // Right side - Kickoff text

                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontFamily: 'SFPro',
                                              color: Colors.black87,
                                              height: 1.4,
                                            ),
                                            children: [
                                              TextSpan(
                                                  text: 'Aligning with stakeholders\' concerns and goals, we conducted a '),
                                              TextSpan(
                                                text:  'comprehensive assessment',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                  text:
                                                      ' of their current platform. By comparing it against industry '),
                                              TextSpan(
                                                text: 'benchmarks',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(text: ' and '),
                                              TextSpan(
                                                text: 'competitors',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                  text:
                                                      ', and employing a range of '),
                                              TextSpan(
                                                text: 'analytical techniques',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                  text:
                                                      ', we aimed to identify strengths and opportunities for '),
                                              TextSpan(
                                                text: 'enhancement',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(text: '.'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Right spacer
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(),
                                  ),
                                ],
                              ),

                              SizedBox(height: 60),

                              // Visualizing section
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left spacer
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(),
                                  ),
                                  // Left side - Visualizing label

                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Visualizing',
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontFamily: 'SFPro',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  // Right side - Visualizing text
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'We outlined the steps users would take, to achieve their goals. Creating a visual flow of all available functions and mechanisms of action',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: 'SFPro',
                                            color: Colors.black87,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Right spacer
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(),
                                  ),
                                ],
                              ),

                              SizedBox(height: 60),

                              // Key Insights section
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left spacer
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(),
                                  ),
                                  // Left side - Key Insights label
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Key Insights',
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontFamily: 'SFPro',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  // Right side - Key Insights text
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Mapping out the steps and analyzing the overall experience led us to discover myriad design gaps and room for improvement.',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: 'SFPro',
                                            color: Colors.black87,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Right spacer
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(),
                                  ),
                                ],
                              ),

                              SizedBox(height: 60),

                              // Accomplishments section
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left spacer
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(),
                                  ),
                                  // Left side - Accomplishments label
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Accomplishments',
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontFamily: 'SFPro',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  // Right side - Accomplishments bullet points
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '• We scaled back the UI that did not comport with the 60/30/10 rule\n\n• We discovered several user journeys\' that had yet to be considered and tied up loose ends not yet fully fleshed out\n\n• Optimized touch points, identified areas of friction for users and designed a more robust, effective, and intuitive user experience',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: 'SFPro',
                                            color: Colors.black87,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Right spacer
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(),
                                  ),
                                ],
                              ),

                              SizedBox(height: 60),

                              // Centered user flow image
                              Container(
                                width: double.infinity,
                                child: Center(
                                  child: Container(
                                    constraints: BoxConstraints( maxWidth: 1600), // Control max width
                                    child: Image.asset(
                                      'assets/moments/user_flow2.png',
                                      fit: BoxFit.contain,
                                      filterQuality: FilterQuality.high,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          height: 1600,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.account_tree,
                                                  size: 80,
                                                  color: Colors.grey.shade400,
                                                ),
                                                SizedBox(height: 16),
                                                Text(
                                                  'User Flow Image\nNot Found',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey.shade600,
                                                    fontFamily: 'SFPro',
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 60),

                       // Section 5: Final Stages with User Testing and Final Screens
                        _buildCaseStudySection(
                          title: '',
                          transparentBorder: false,
                          customHeight: 1500, // Increased to accommodate prototype
                          showDivider: false, // Remove divider from here
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Centered main title
                              Text(
                                'Final Stages',
                                style: TextStyle(
                                  fontSize: 60,
                                  fontFamily: 'Ghasan',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 50),

                              // User Testing / Final Screens & Prototype columns
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left spacer
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(),
                                  ),

                                  // User Testing column
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'User Testing',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: 'SFPro',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'SFPro',
                                              color: Colors.black87,
                                              height: 1.4,
                                            ),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      'We reorganized the user testing distribution based on our '),
                                              TextSpan(
                                                text: 'designated roles',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                  text:
                                                      '. As a team effort, we crafted a thorough '),
                                              TextSpan(
                                                text: 'testing script.',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                  text:
                                                      ' Individually, we procured '),
                                              TextSpan(
                                                text: 'test participants',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                  text:
                                                      ', conducted user tests, and then shared the outcomes and '),
                                              TextSpan(
                                                text: 'analysis',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                  text: ' of our user tests.'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(width: 40),

                                  // Final Screens & Prototype column
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Final Screens & Prototype',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: 'SFPro',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'SFPro',
                                              color: Colors.black87,
                                              height: 1.4,
                                            ),
                                            children: [
                                              TextSpan(text: 'With our user '),
                                              TextSpan(
                                                text: 'testing insights',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                  text:
                                                      ', we implemented any necessary '),
                                              TextSpan(
                                                text: 'design iterations',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                  text: ' and completed the '),
                                              TextSpan(
                                                text: 'final touches',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                  text:
                                                      ' on both the prototype and high-fidelity versions. Subsequently, we convened a final meeting with the stakeholders to secure their ultimate approval before '),
                                              TextSpan(
                                                text:
                                                    'delivering the finalized screens',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                  text:
                                                      ' to the development team.'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Right spacer
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(),
                                  ),
                                ],
                              ),

                              SizedBox(
                                  height:
                                      40), // Reduced spacing to bring prototype closer

                              // Centered Figma Prototype - closer to the text above
                              Container(
                                width: double.infinity,
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Interactive Prototype',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Explore the interactive Moments prototype below',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'SFPro',
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 30),
                                      MomentsPrototype(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 60),

                        // Divider line - now positioned between prototype and next section
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final screenWidth =
                                MediaQuery.of(context).size.width;
                            final calculatedDividerWidth = screenWidth * 0.7;

                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 30),
                              child: Center(
                                child: Container(
                                  width: calculatedDividerWidth,
                                  height: 1.0,
                                  color: Color(0xFF838383),
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 60),

                        // 3. Dev Handoff header - now above "Thinking Like A Developer"
                        Container(
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              '3. Dev Handoff',
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'SFPro',
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        SizedBox(height: 30),

                        // "Thinking Like A Developer" header - now below the section number
                        Container(
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              'Thinking\nLike\nA Developer',
                              style: TextStyle(
                                fontSize: 60,
                                fontFamily: 'Ghasan',
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        SizedBox(height: 60),


                        // Section 6: Dev Handoff with centered text and full-width carousel

                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                             
                              SizedBox(height: 40),

                              // Centered text content
                              Container(
                                width: 600,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Efficient, Meticulous, Thorough...',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'SFPro',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: 'SFPro',
                                          color: Colors.black87,
                                          height: 1.5,
                                        ),
                                        children: [
                                          TextSpan(text: 'Taking '),
                                          TextSpan(
                                            text: 'meticulous care',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                              text:
                                                  ' to ensure that each design component '),
                                          TextSpan(
                                            text: 'seamlessly',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                              text:
                                                  ' matched the prerequisites for development, and thus eliminating any potential for confusion or inconsistencies, we '),
                                          TextSpan(
                                            text: 'thoroughly documented',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                              text:
                                                  ' every feature of the screens and prototype. This ensured a '),
                                          TextSpan(
                                            text:
                                                'seamless and efficient handoff',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                              text: ' to the development team'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 60),

                              // Full-width carousel below centered text
                              CaseStudyCarouselPresets
                                  .momentsDevHandoffCarousel(
                                      compactMode: false),
                            ],
                          ),
                        ),

                        SizedBox(height: 60),

                        // Divider line between carousel and reflection
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final screenWidth =
                                  MediaQuery.of(context).size.width;
                              final calculatedDividerWidth = screenWidth * 0.7;

                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 30),
                                child: Center(
                                  child: Container(
                                    width: calculatedDividerWidth,
                                    height: 1.0,
                                    color: Color(0xFF838383),
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 60),

                        // Section 7: Reflection with centered box
                          _buildCaseStudySection(
                            title: '',
                            customHeight: 600,
                            showDivider: false,
                            content: Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width *
                                    0.5, // Half width
                                padding: EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // Reflection header inside the box
                                    Text(
                                      'Reflection',
                                      style: TextStyle(
                                        fontSize: 60,
                                        fontFamily: 'Ghasan',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                        height: 1.2,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                    SizedBox(height: 24),

                                    // Text content
                                    Text(
                                      'Moments was an exciting project. Knowing the design elements I helped construct would be used on a social media platform similar to the ones I use personally made the project uniquely tangible and interesting.\n\nThe primary challenge involved uncovering shortcomings within the existing platform model. Our team had to not only anticipate the behavior of new users upon their initial interaction with Moments but also consider the preconceptions formed by the widespread use of popular social media apps from which Moments aimed to distinguish itself.\n\nWith additional time and a broader scope dedicated to Moments, my focus would have been on enhancing the user flow and refining the platform\'s visual design.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'SFPro',
                                        color: Colors.black87,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        SizedBox(height: 160), // extra space
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

            // Fixed top bar that never moves
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CaseStudyTopBar(
                caseStudyTitle: 'Moments',
                onBackPressed: () => Navigator.of(context).pop(),
                currentTheme: PortfolioTheme.wireframe,
                onMainAreaPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ),

            // ⭐ NEW: Floating back to top button
            FloatingBackToTopButton(
              scrollController: _scrollController,
              bottom: 24.0,
              right: 24.0,
              size: 56.0,
              backgroundColor: Colors.white,
              borderColor: Colors.black,
              iconColor: Colors.black,
              borderWidth: 1.0,
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for building case study sections

  Widget _buildCaseStudySection({
    required String title,
    required Widget content,
    bool isNarrow = false,
    bool transparentBorder = true,
    double? customHeight,
    bool showDivider = false,
    Color dividerColor = Colors.black,
    double dividerHeight = 2.0,
    double dividerWidth = 0.6,
  }) {
    return Column(
      children: [
        Center(
          child: Container(
            width: isNarrow ? 800 : double.infinity,
            height: customHeight,
            constraints: customHeight == null
                ? null
                : BoxConstraints(minHeight: customHeight),
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: transparentBorder
                    ? Colors.transparent
                    : Colors.grey.shade300.withAlpha(0),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title.isNotEmpty)
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Ghasan',
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                  ),
                if (title.isNotEmpty) SizedBox(height: 30),
                content,
              ],
            ),
          ),
        ),

        // Divider section
        if (showDivider)
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = MediaQuery.of(context).size.width;
              final calculatedDividerWidth = screenWidth * dividerWidth;

              return Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Container(
                    width: calculatedDividerWidth,
                    height: dividerHeight,
                    color: dividerColor,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildWireframeImages() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double spacingMultiplier = 0.015;
        final double minSpacing = 2.0;
        final double maxSpacing = 15.0;

        final responsiveHorizontalSpacing =
            constraints.maxWidth * spacingMultiplier;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: _buildWireframeImage('assets/moments/devices/hero.png'),
            ),
            SizedBox(
                width:
                    responsiveHorizontalSpacing.clamp(minSpacing, maxSpacing)),
            Flexible(
              child: _buildWireframeImage('assets/moments/devices/8.png'),
            ),
            SizedBox(
                width:
                    responsiveHorizontalSpacing.clamp(minSpacing, maxSpacing)),
            Flexible(
              child: _buildWireframeImage('assets/moments/devices/10.png'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWireframeImage(String imagePath) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double spacingDivisor = 1.9;
        final double minWidth = 320.0;
        final double maxWidth = 420.0;
        final double aspectRatio = 1.5;
        final double innerPadding = 4.0;

        final availableWidth = constraints.maxWidth / spacingDivisor;
        final imageWidth = availableWidth.clamp(minWidth, maxWidth);
        final imageHeight = imageWidth * aspectRatio;

        return Container(
          width: imageWidth,
          height: imageHeight,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(0),
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(color: Colors.grey.shade300.withAlpha(50), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(30),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.all(innerPadding),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade100,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone_android,
                              color: Colors.grey.shade400,
                              size: imageWidth * 0.25),
                          SizedBox(height: 8),
                          Text(
                            'Wireframe\nNot Found',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: imageWidth * 0.06,
                              fontFamily: 'SFPro',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

// Moments Project Data
final ProjectData momentsStudy = ProjectData(
  id: 'moments',
  title: 'Moments',
  subtitle: 'A member-based B2C social media application',
  originalLink: 'https://jeffpdx.net/p/02db657c',
  heroImage: 'assets/backgroundheader.png',
  logoImage: 'assets/moments/devices/hero.png',
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
              'This initial exploration helped me locate potential areas to focus on that would resonate with users and provide value. What questions did users have? What were their pain points? What were common complaints?',
        ),
        ContentSection(
          subtitle: 'Competitive Analysis',
          text:
              'I analyzed major social media platforms including Instagram, Facebook, and newer players like BeReal to understand current market offerings and identify gaps.',
        ),
        ContentSection(
          subtitle: 'User Interviews',
          text:
              'Conducted in-depth interviews with 15 social media users aged 18-35 to understand their frustrations with current platforms and desired features.',
        ),
      ],
    ),

    // Page 3: Prototyping
    ProjectPage(
      title: 'Prototyping',
      sections: [
        ContentSection(
          subtitle: 'Low-Fidelity Wireframes',
          text:
              'Started with paper sketches and basic wireframes to explore different layout options and user flow possibilities.',
        ),
        ContentSection(
          subtitle: 'Interactive Prototypes',
          text:
              'Created interactive prototypes in Figma to test core user journeys including onboarding, content sharing, and friend connections.',
        ),
        ContentSection(
          subtitle: 'Design Iterations',
          text:
              'Through multiple iterations, refined the interface to achieve the desired minimalist aesthetic while maintaining functionality.',
        ),
      ],
    ),

    // Page 4: User Testing
    ProjectPage(
      title: 'User Testing',
      sections: [
        ContentSection(
          subtitle: 'Testing Methodology',
          text:
              'Conducted moderated usability testing sessions with 10 participants to validate design decisions and identify usability issues.',
        ),
        ContentSection(
          subtitle: 'Key Insights',
          text:
              '• Users appreciated the clean, distraction-free interface\n• The friend-only model resonated strongly with privacy-conscious users\n• Some users needed more guidance during the onboarding process\n• The simplified sharing flow was intuitive and well-received',
        ),
        ContentSection(
          subtitle: 'Design Refinements',
          text:
              'Based on testing feedback, improved the onboarding flow, added contextual help, and refined the navigation structure.',
        ),
      ],
    ),

    // Page 5: Dev Handoff
    ProjectPage(
      title: 'Dev Handoff',
      sections: [
        ContentSection(
          subtitle: 'Design System',
          text:
              'Created a comprehensive design system with detailed specifications, component library, and usage guidelines for the development team.',
        ),
        ContentSection(
          subtitle: 'Documentation',
          text:
              'Provided detailed specifications including spacing, typography, color values, and interaction states to ensure accurate implementation.',
        ),
        ContentSection(
          subtitle: 'Collaboration',
          text:
              'Worked closely with developers throughout the implementation phase to address technical constraints and maintain design integrity.',
        ),
      ],
    ),

    // Page 6: Reflection
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
