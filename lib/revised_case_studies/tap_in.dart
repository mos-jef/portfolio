import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio_website/themes/wireframe/utils/wireframe_color_manager.dart';

class TapInCaseStudy extends StatefulWidget {
  const TapInCaseStudy({Key? key}) : super(key: key);

  @override
  State<TapInCaseStudy> createState() => _TapInCaseStudyState();
}

class _TapInCaseStudyState extends State<TapInCaseStudy> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main scrollable content

          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Custom app bar with back button

              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                pinned: true,
                automaticallyImplyLeading: false,
                toolbarHeight: 80,
                flexibleSpace: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Row(
                    children: [
                      // Back button

                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: WireframeColorManager.colors.surface,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: WireframeColorManager.colors.border,
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: WireframeColorManager.colors.text,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),

                      // Case study title

                      Text(
                        'Tap In',
                        style: TextStyle(
                          fontSize: 32,
                          fontFamily: 'SFPro',
                          fontWeight:
                              FontWeight.w600, // This will use SFPro SemiBold
                          color: WireframeColorManager.colors.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Main content area - Updated with case study content

              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section 1: Balancing Innovation and Zeitgeist

                      _buildCaseStudySection(
                        title: '',
                        isNarrow: true,
                        transparentBorder: false, // Keep border for now, change to true later
                        customHeight: 1100, // Taller section
                        showDivider: true, // Shows the divider
                        dividerColor: Color(0xFF838383), // (Figma hex format)
                        dividerHeight: 1.0, // 1px thick
                        dividerWidth: 0.7, // 70% of screen width
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            LayoutBuilder(
                              builder: (context, constraints) {
                                // Calculate responsive font size based on container width
                                final responsiveFontSize = constraints.maxWidth * 0.08; // 8% of container width
                                final clampedFontSize = responsiveFontSize.clamp(24.0, 72.0); // Min 24px, Max 72px

                                return Text(
                                  'Balancing Innovation\nand Zeitgeist',
                                  style: TextStyle(
                                    fontSize: clampedFontSize, // DYNAMIC SIZE
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
                                        height: responsiveVerticalSpacing.clamp(
                                            20.0,
                                            60.0)), // Dynamic spacing (was 40)
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
                                            15.0,
                                            30.0)), // Dynamic spacing (was 20)
                                    Text(
                                      'This case study showcases how I\nbalanced\nInnovation with convention\nwhile creating a custom\nSocial Media Platform from scratch.\nDiscover how I did this by joining\nand downloading Tap In',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black87,
                                        height: 1.5,
                                        fontFamily: 'SFPro',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                        height: responsiveLargeSpacing.clamp(
                                            40.0,
                                            80.0)), // Dynamic spacing (was 60)
                                    _buildWireframeImages(),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 60),

                      // Section 2: Role

_buildCaseStudySection(
  title: '',
  transparentBorder: false,
  customHeight: 900,
  showDivider: true, // Shows the divider
  dividerColor: Color(0xFF838383), // (Figma hex format)
  dividerHeight: 1.0, // 1px thick
  dividerWidth: 0.7, // 70% of screen width
  content: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Header section
      Text(
        '2. ROLE',
        style: TextStyle(
          fontSize: 24, // Same as Section 1's "1. Overview"
          fontFamily: 'SFPro',
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      LayoutBuilder(
        builder: (context, constraints) {
          final responsiveVerticalSpacing = constraints.maxWidth * 0.05;
          final responsiveHorizontalSpacing = constraints.maxWidth * 0.075;
          final responsiveSmallSpacing = constraints.maxWidth * 0.035;
          
          return Column(
            children: [
              SizedBox(height: responsiveVerticalSpacing.clamp(25.0, 60.0)),
              // Content row with text and image
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side - Text content
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transcending\nDesign\nCustom',
                          style: TextStyle(
                            fontSize: 60,
                            fontFamily: 'Ghasan',
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: responsiveSmallSpacing.clamp(20.0, 40.0)),
                        Container(
                          width: double.infinity,
                          child: Text(
                            'After spending years in jiu-jitsu, I felt it was time to shake things up. So, I took on a six-month contract with a global BJJ franchise — my first venture into social media. This role wasn\'t just about bringing my existing skills to the table; it was about diving headfirst into a new domain and making a meaningful impact for people and a sport I cherish',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'SFPro',
                              color: Colors.black87,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: responsiveHorizontalSpacing.clamp(40.0, 80.0)),

                                    // Right side - Penrose Triangle

                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            height: 600,
                                            child: Center(
                                              child: Builder(
                                                builder: (context) {
                                                  try {
                                                    return SvgPicture.asset(
                                                      'assets/tapin/penrose_triangle.svg',
                                                      height: 550,
                                                      width: 550,
                                                      fit: BoxFit.contain,
                                                      placeholderBuilder:
                                                          (BuildContext
                                                                  context) =>
                                                              Container(
                                                        height: 550,
                                                        width: 550,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .grey.shade200,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .shade300),
                                                        ),
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons.image,
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                                size: 50,
                                                              ),
                                                              SizedBox(
                                                                  height: 8),
                                                              Text(
                                                                'SVG Loading...',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'SFPro',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  } catch (e) {
                                                    return Container(
                                                      height: 550,
                                                      width: 550,
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade200,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade300),
                                                      ),
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.error,
                                                              color: Colors
                                                                  .red.shade400,
                                                              size: 50,
                                                            ),
                                                            SizedBox(height: 8),
                                                            Text(
                                                              'SVG Error',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .red
                                                                    .shade600,
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'SFPro',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 60),

                      // Section 3: Challenge/Solution

                      _buildCaseStudySection(
                        title: '',
                        transparentBorder: false,
                        customHeight: 1300, // Taller to accommodate pyramid below
                        showDivider: true, // Shows the divider
                        dividerColor: Color(0xFF838383), // (Figma hex format)
                        dividerHeight: 1.0, // 1px thick
                        dividerWidth: 0.7, // 70% of screen width
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Centered header section
                            Text(
                              '3. Key Challenges',
                              style: TextStyle(
                                fontSize: 24, // Same as other sections
                                fontFamily: 'SFPro',
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 40), // Adjustable spacing

                            // Centered main title
                            Text('Innovating The\nFamiliar',
                                style: TextStyle(
                                  fontSize:
                                      60, // Same as Section 2's main title
                                  fontFamily:
                                      'Ghasan', // Same font as other sections
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center),
                            SizedBox(height: 50), // Adjustable spacing

                            // Challenge/Solution columns (top section)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left spacer to push content toward center
                                Expanded(
                                  flex:
                                      1, // Adjustable - increase to push content more toward center
                                  child: SizedBox(),
                                ),

                                // Left side - Challenge column
                                Expanded(
                                  flex:
                                      2, // Takes up 2/5 of the remaining width - adjustable
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Challenge',
                                        style: TextStyle(
                                          fontSize:
                                              24, // Adjustable subheader size
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(
                                          height: 15), // Adjustable spacing
                                      Text(
                                        'As the only UX designer for the entire product, I found myself simultaneously working on four projects:',
                                        style: TextStyle(
                                          fontSize:
                                              20, // Adjustable body text size
                                          fontFamily: 'SFPro',
                                          color: Colors.black87,
                                          height: 1.4,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '• Enhancing Social Engagement\n• Communication Enhancement\n• Legacy and New Member retention\n• Engendering Interface Pivots\n• Transcendent Design',
                                        style: TextStyle(
                                          fontSize:
                                              20, // Adjustable list text size
                                          fontFamily: 'SFPro',
                                          color: Colors.black87,
                                          height: 1.4,
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        'Each facet had its own challenges and tight deadlines. The pressure was on to deliver top-notch work across the board while getting up to speed with the ins and outs of the Oregon Jiu Jitsu Community',
                                        style: TextStyle(
                                          fontSize:
                                              20, // Adjustable body text size
                                          fontFamily: 'SFPro',
                                          color: Colors.black87,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                    width:
                                        40), // Adjustable spacing between columns

                                // Right side - Solution column
                                Expanded(
                                  flex:
                                      2, // Takes up 2/5 of the remaining width - adjustable
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Solution',
                                        style: TextStyle(
                                          fontSize:
                                              24, // Adjustable subheader size
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(
                                          height: 15), // Adjustable spacing
                                      Text(
                                        'Realizing I needed a game plan to stay sane and productive, I turned to the 50-20-20-10 Rule to prioritize my efforts:',
                                        style: TextStyle(
                                          fontSize:
                                              20, // Adjustable body text size
                                          fontFamily: 'SFPro',
                                          color: Colors.black87,
                                          height: 1.4,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '• 50% on the highest priority (Communication)\n• 20% on the second priority (Social Engagement)\n• 20% on the second priority (Member Retention)\n• 10% split between the remaining two (Interface Pivots and Design Innovation)',
                                        style: TextStyle(
                                          fontSize:
                                              20, // Adjustable list text size
                                          fontFamily: 'SFPro',
                                          color: Colors.black87,
                                          height: 1.4,
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        'This wasn\'t a rigid rule but gave me a solid framework to manage my time and energy effectively.',
                                        style: TextStyle(
                                          fontSize:
                                              20, // Adjustable body text size
                                          fontFamily: 'SFPro',
                                          color: Colors.black87,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Right spacer to push content toward center
                                Expanded(
                                  flex:
                                      1, // Adjustable - increase to push content more toward center
                                  child: SizedBox(),
                                ),
                              ],
                            ),

                            SizedBox( height: 60), // Adjustable spacing before pyramid

                            // UX Pyramid - positioned below and centered
                            LayoutBuilder(
                              builder: (context, constraints) {
                                // 🎛️ PYRAMID RESPONSIVENESS CONTROLS
                                final double maxPyramidWidth = constraints.maxWidth * 0.6; // 90% of available width
                                final double pyramidWidth = maxPyramidWidth.clamp(300.0, 750.0); // Min 300px, Max 750px
                                final double pyramidHeight = pyramidWidth * 0.50; // Height is 60% of width

                                return Center(
                                  child: Container(
                                    width: pyramidWidth,
                                    height: pyramidHeight,
                                    child: Builder(
                                      builder: (context) {
                                        try {
                                          return Image.asset(
                                            'assets/tapin/ux_pyramid.png',
                                            width: pyramidWidth,
                                            height: pyramidHeight,
                                            fit: BoxFit.contain,
                                            filterQuality: FilterQuality.high,
                                          );
                                        } catch (e) {
                                          return Container(
                                            width: pyramidWidth,
                                            height: pyramidHeight,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:BorderRadius.circular(8),
                                              border: Border.all( color: Colors.grey.shade300),
                                            ),
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.layers,
                                                    color: Colors.grey.shade400,
                                                    size: pyramidWidth * 0.1, // Responsive icon size
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    'UX Pyramid\nLoading...',
                                                    style: TextStyle(
                                                      color: Colors.grey.shade600,
                                                      fontSize: pyramidWidth * 0.02, // Responsive text size
                                                      fontFamily: 'SFPro',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      
                      SizedBox(height: 160),

                      // Section 4: Design Management

                      _buildCaseStudySection(
                        title: '',
                        transparentBorder: false,
                        customHeight: 1200, // Taller to accommodate SVG below
                        showDivider: true, // Shows the divider
                        dividerColor: Color(0xFF838383), // (Figma hex format)
                        dividerHeight: 1.0, // 1px thick
                        dividerWidth: 0.7, // 70% of screen width
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Centered header section
                            Text(
                              '4. Design Management',
                              style: TextStyle(
                                fontSize: 24, // Same as other sections
                                fontFamily: 'SFPro',
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 40), // Adjustable spacing

                            // Centered main title
                            Text(
                              'A thousand drums,\none beat',
                              style: TextStyle(
                                fontSize: 60, // Same as Section 3's main title
                                fontFamily:
                                    'Ghasan', // Same font as other sections
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 50), // Adjustable spacing

                            // Challenge/Solution columns (top section)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left spacer to push content toward center
                                Expanded(
                                  flex:
                                      1, // Adjustable - increase to push content more toward center
                                  child: SizedBox(),
                                ),

                                // Left side - Challenge column
                                Expanded(
                                  flex:
                                      2, // Takes up 2/5 of the remaining width - adjustable
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Challenge',
                                        style: TextStyle(
                                          fontSize:
                                              24, // Adjustable subheader size
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(
                                          height: 15), // Adjustable spacing
                                      Text(
                                        'Getting design approval was a complex process involving interviews, testing, stakeholders, product owners, time and availability',
                                        style: TextStyle(
                                          fontSize:
                                              20, // Adjustable body text size
                                          fontFamily: 'SFPro',
                                          color: Colors.black87,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                    width:
                                        40), // Adjustable spacing between columns

                                // Right side - Solution column
                                Expanded(
                                  flex:
                                      2, // Takes up 2/5 of the remaining width - adjustable
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Solution',
                                        style: TextStyle(
                                          fontSize:
                                              24, // Adjustable subheader size
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(
                                          height: 15), // Adjustable spacing
                                      Text(
                                        'I developed a process of automated interview feedback, interval testing, analysis, and regularly scheduled meetings to optimize time and resource investment',
                                        style: TextStyle(
                                          fontSize:
                                              20, // Adjustable body text size
                                          fontFamily: 'SFPro',
                                          color: Colors.black87,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Right spacer to push content toward center
                                Expanded(
                                  flex:
                                      1, // Adjustable - increase to push content more toward center
                                  child: SizedBox(),
                                ),
                              ],
                            ),

                            SizedBox(
                                height:
                                    60), // Adjustable spacing before design principles

                            // Design Principles SVG - positioned below and centered
                            Center(
                              child: Container(
                                height: 450, // Adjustable container height
                                width: 750, // Adjustable container width
                                child: SvgPicture.asset(
                                  'assets/tapin/design_principles.svg',
                                  height: 400, // Adjustable SVG size
                                  width: 700, // Adjustable SVG size
                                  fit: BoxFit.contain,
                                  placeholderBuilder: (BuildContext context) =>
                                      Container(
                                    height: 400,
                                    width: 700,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.design_services,
                                            color: Colors.grey.shade400,
                                            size: 50,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Design Principles\nLoading...',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 14,
                                              fontFamily: 'SFPro',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 60),

                      // Section 5: Discovery Process

                      // Section 5: Obstacles Engender Creativity
                      _buildCaseStudySection(
                        title: '',
                        transparentBorder: false,
                        customHeight: 1400, // Taller to accommodate all content
                        showDivider: true, // Shows the divider
                        dividerColor: Color(0xFF838383), // (Figma hex format)
                        dividerHeight: 1.0, // 1px thick
                        dividerWidth: 0.7, // 70% of screen width
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Centered main title
                            Text(
                              'Obstacles Engender\nCreativity',
                              style: TextStyle(
                                fontSize: 60, // Same as other main titles
                                fontFamily:
                                    'Ghasan', // Same font as other sections
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 50), // Adjustable spacing

                            // Problem row with three columns
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left spacer
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(),
                                ),

                                // Problem column
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Problem',
                                        style: TextStyle(
                                          fontSize: 24, // Same as subheaders
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(width: 40), // Spacing between columns

                                // Resource Strain column
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Resource Strain',
                                        style: TextStyle(
                                          fontSize:
                                              20, // Slightly smaller subheader
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Being the lone designer, the workload was hefty. Designs often weren\'t fully fleshed out before hitting development, leaving developers without enough guidance.',
                                        style: TextStyle(
                                          fontSize: 16, // Body text size
                                          fontFamily: 'SFPro',
                                          color: Colors.black87,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(width: 40), // Spacing between columns

                                // Mission Creep column
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Mission Creep',
                                        style: TextStyle(
                                          fontSize:
                                              20, // Slightly smaller subheader
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Stakeholders and interview participants alike, elicited expansive and exponentially more complex development and design parameters',
                                        style: TextStyle(
                                          fontSize: 16, // Body text size
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

                            SizedBox(height: 40), // Spacing between sections

                            // Solution row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left spacer
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(),
                                ),

                                // Solution column
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Solution',
                                        style: TextStyle(
                                          fontSize:
                                              24, // Same as Problem header
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(width: 40), // Spacing between columns

                                // The Discovery Process and Key Features
                                Expanded(
                                  flex: 4, // Takes up more space for content
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'The Discovery Process',
                                        style: TextStyle(
                                          fontSize:
                                              20, // Same as Resource Strain
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Utilizing standard methods of heuristic analysis, interviews, user-testing, secondary research and the Google Design Sprint I was able to adeptly and swiftly bring new and updated design/ development strategies to the stakeholders. Enabling me to generate ideation, design proposals, and adjustments to stakeholders efficiently and cogently',
                                        style: TextStyle(
                                          fontSize: 16, // Body text size
                                          fontFamily: 'SFPro',
                                          color: Colors.black87,
                                          height: 1.4,
                                        ),
                                      ),
                                      SizedBox(height: 25),

                                      // Key Features subheader
                                      Text(
                                        'Key Features',
                                        style: TextStyle(
                                          fontSize: 18, // Subheader size
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 15),

                                      // Feature 1
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  '• Design Tokens for Consistency: ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'SFPro',
                                                fontWeight: FontWeight
                                                    .w600, // Bold until colon
                                                color: Colors.black87,
                                                height: 1.4,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  'Proposed implementing design tokens to unify design and development, reducing rework and ensuring everything looks and feels cohesive.',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'SFPro',
                                                fontWeight: FontWeight
                                                    .normal, // Regular after colon
                                                color: Colors.black87,
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 12),

                                      // Feature 2
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  '• Rapid Prototyping and Testing: ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'SFPro',
                                                fontWeight: FontWeight
                                                    .w600, // Bold until colon
                                                color: Colors.black87,
                                                height: 1.4,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  'By leveraging existing solutions, we could quickly create prototypes and present them to customers sooner, enabling us to fine-tune features before launch.',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'SFPro',
                                                fontWeight: FontWeight
                                                    .normal, // Regular after colon
                                                color: Colors.black87,
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 12),

                                      // Feature 3
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  '• Extensive Interviews & User Testing: ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'SFPro',
                                                fontWeight: FontWeight
                                                    .w600, // Bold until colon
                                                color: Colors.black87,
                                                height: 1.4,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  'By leveraging proximity to test subjects and interviewees, I could leverage rapid feedback to maximize design needs, user satisfaction, and corresponding red-designs',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'SFPro',
                                                fontWeight: FontWeight
                                                    .normal, // Regular after colon
                                                color: Colors.black87,
                                                height: 1.4,
                                              ),
                                            ),
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
                                height: 60), // Spacing before process overview

                            // Process Overview SVG - positioned below and centered
                            Center(
                              child: Container(
                                height: 350, // Adjustable container height
                                width: 800, // Adjustable container width
                                child: SvgPicture.asset(
                                  'assets/tapin/process_overview.svg',
                                  height: 320, // Adjustable SVG size
                                  width: 750, // Adjustable SVG size
                                  fit: BoxFit.contain,
                                  placeholderBuilder: (BuildContext context) =>
                                      Container(
                                    height: 320,
                                    width: 750,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
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
                                            color: Colors.grey.shade400,
                                            size: 50,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Process Overview\nLoading...',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 14,
                                              fontFamily: 'SFPro',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Section 6: UX Design Research
                      _buildCaseStudySection(
                        title: '',
                        transparentBorder: false,
                        customHeight: 600, // Shorter section as requested
                        showDivider: false, // Shows the divider
                        dividerColor: Color(0xFF838383), // (Figma hex format)
                        dividerHeight: 1.0, // 1px thick
                        dividerWidth: 0.7, // 70% of screen width
                        content: Container(
                          padding: EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Color(0xFFE8E8E8), // Light gray background like screenshot
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Header
                              Text(
                                '5. UX Design',
                                style: TextStyle(
                                  fontSize: 24, // Same as other section headers
                                  fontFamily: 'SFPro',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 15),

                              // Main title
                              Text(
                                'Research',
                                style: TextStyle(
                                  fontSize: 60, // Same as other main titles
                                  fontFamily: 'Ghasan',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 40),

                              // Content row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left side - Text content
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Qualitative Interviews',
                                          style: TextStyle(
                                            fontSize: 24, // Same as subheaders
                                            fontFamily: 'SFPro',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          'After my secondary research, I conducted qualitative interviews to study the usability, use metrics, and utility of the designs and proto-types I had created. I conducted several rounds of interviews, with each new design iteration. Regular attendance by test subjects and their willingness to participate was a blessing I was extremely greatful for',
                                          style: TextStyle(
                                            fontSize: 16, // Same as body text
                                            fontFamily: 'SFPro',
                                            color: Colors.black87,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox( width: 60), // Space between text and icons

                                  // Right side - Interactive icons
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // Questions/Survey icon
                                        _buildInteractiveIcon(
                                          imagePath: 'assets/Survey.png',
                                          label: 'Questions',
                                          onTap: () => _openSurveyPDF(context),
                                        ),

                                        // Video Interviews icon 1
                                        _buildInteractiveIcon(
                                          imagePath: 'assets/Video.png',
                                          label: 'Video\nInterviews',
                                          onTap: () =>
                                              _openVideoLink(context, 'video1'),
                                        ),

                                        // Video Interviews icon 2
                                        _buildInteractiveIcon(
                                          imagePath: 'assets/Video.png',
                                          label: 'Video\nInterviews',
                                          onTap: () =>
                                              _openVideoLink(context, 'video2'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Section: Heuristic Market Analysis

                      _buildCaseStudySection(
                        title: '',
                        transparentBorder: false,
                        customHeight: 800, // Adjustable height
                        showDivider: true, // Shows the divider
                        dividerColor: Color(0xFF838383), // (Figma hex format)
                        dividerHeight: 1.0, // 1px thick
                        dividerWidth: 0.7, // 70% of screen width
                        content: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left side - Title and description
                            Expanded(
                              flex: 2, // Takes up 2/5 of the width
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Heuristic\nMarket Analysis',
                                    style: TextStyle(
                                      fontSize: 60, // Same as other main titles
                                      fontFamily: 'Ghasan',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      height: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Container(
                                    width: double.infinity, // Takes only the left column width
                                    child: Text(
                                      'I studied a few current market offerings for sports-teams and athletic-professionals and did a comparative analysis of them with our discovered opportunity areas.',
                                      style: TextStyle(
                                        fontSize: 16, // Same as body text
                                        fontFamily: 'SFPro',
                                        color: Colors.black87,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 60), // Space between text and table

                            // Right side - Competitive analysis table
                            Expanded(
                              flex: 3, // Takes up 3/5 of the width
                              child: _buildCompetitiveTableUpdated(),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 60),

                      // Section 8: Takeaways
                      _buildCaseStudySection(
                        title: '',
                        customHeight: 400,
                        showDivider: false, // Shows the divider
                        dividerColor: Color(0xFF838383).withAlpha(0), // (Figma hex format)
                        dividerHeight: 1.0, // 1px thick
                        dividerWidth: 0.7, // 70% of screen width
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Takeaways',
                              style: TextStyle(
                                fontSize: 60, // Same as other main titles
                                fontFamily: 'Ghasan',
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 100),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _buildTakeawayItem(
                                    title: 'Power of Design Research',
                                    description:
                                        'The willingness of BJJ students to take the time and share their personal stories, personal preferences, and take surveys became the foundation of the project.',
                                  ),
                                ),
                                SizedBox(width: 80),
                                Expanded(
                                  child: _buildTakeawayItem(
                                    title: 'Narrative',
                                    description:
                                        'I created prototypes catering to multiple scenarios for users along with simulating the social experience.',
                                  ),
                                ),
                                SizedBox(width: 40),
                                Expanded(
                                  child: _buildTakeawayItem(
                                    title: 'Service Design',
                                    description:
                                        'Deep-diving into creating an in-depth journey map as well as present and future service maps based on gathered data heavily informed the opportunity areas.',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 60),

                      // Section 9: Reflection and Next Steps

                      _buildReflectionSection(),

                      SizedBox(height: 160), // extra space
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
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
    bool showDivider = false, // NEW: Show divider below section
    Color dividerColor = Colors.black, // NEW: Divider color
    double dividerHeight = 2.0, // NEW: Divider thickness
    double dividerWidth = 0.6, // NEW: Divider width (as % of screen)
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

        // 🎛️ DIVIDER SECTION - Shows only if showDivider is true
        if (showDivider)
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = MediaQuery.of(context).size.width;
              final calculatedDividerWidth = screenWidth * dividerWidth;

              return Container(
                margin: EdgeInsets.symmetric(
                    vertical: 30), // Space above and below divider
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

  // Interactive icon builder with hover effects
  Widget _buildInteractiveIcon({
    required String imagePath,
    required String label,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // Hand cursor on hover
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 100,
          child: Column(
            children: [
              // Icon image
              Container(
                width: 80,
                height: 80,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 12),

              // Label
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'SFPro',
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

// PDF opener method
  void _openSurveyPDF(BuildContext context) async {
    try {
      // For now, show a dialog - you can implement actual PDF opening later
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Survey PDF'),
          content: Text(
              'Survey PDF would open here.\n\nImplement with url_launcher or pdf_viewer package.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        ),
      );

      // TODO: Implement actual PDF opening
      // You can use url_launcher package:
      // await launch('assets/tapin/survey.pdf');
    } catch (e) {
      print('Error opening PDF: $e');
    }
  }

// Video link opener method
  void _openVideoLink(BuildContext context, String videoId) async {
    try {
      // For now, show a dialog - replace with actual video URLs
      String videoTitle =
          videoId == 'video1' ? 'Interview Session 1' : 'Interview Session 2';

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Video Interview'),
          content: Text(
              '$videoTitle would open here.\n\nReplace with YouTube URL or video player.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        ),
      );

      // TODO: Implement actual video opening
      // Replace with your YouTube URLs:
      // String url = videoId == 'video1'
      //     ? 'https://youtube.com/watch?v=YOUR_VIDEO_1'     // https://drive.google.com/file/d/1GywIfiw_TQKKVBPeRP_RQtRuYGHDQldG/view?usp=drive_link
      //     : 'https://youtube.com/watch?v=YOUR_VIDEO_2';    // https://drive.google.com/file/d/1IUCO63Q2735fobdWyerRgGaBk0ZEVA0v/view?usp=drive_link
      // await launch(url);
    } catch (e) {
      print('Error opening video: $e');
    }
  }

  Widget _buildCompetitiveTableUpdated() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, // Same background as section
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header row with images
          Row(
            children: [
              // Empty space for feature column
              Expanded(flex: 3, child: SizedBox()),

              // Game Changer column

              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: Image.asset(
                        'assets/game_changer.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade300,
                            child: Icon(Icons.image, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'GAME CHANGER',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'SFPro',
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // WhatsApp column
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: Image.asset(
                        'assets/whatsapp.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade300,
                            child: Icon(Icons.image, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'WHATSAPP',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'SFPro',
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Tap-in column
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: Image.asset(
                        'assets/tapin_logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade300,
                            child: Icon(Icons.image, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'TAP-IN',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'SFPro',
                        fontWeight: FontWeight.w600,
                        color: Colors.blue, // Blue for "Our Proposed Solution"
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 30),

          // Feature rows
          ...List.generate(12, (index) {
            final features = [
              'BJJ/COMBAT-SPORT SPECIFIC',
              'GYM/TEAM SPECIFIC CAPABILITY',
              'CENTRALIZED GYM HUB',
              'ALERTS AND PUSH NOTIFICATIONS',
              'BELT/RANK USER CONVENTION',
              'PRIVATE CHAT CHANNELS',
              'DIRECT MESSAGING BETWEEN USERS',
              'PERSONAL PHOTO/AVATARS',
              'IMAGE AND VIDEO HOSTING',
              'FIGHT CLOCK/TIMER',
              'LIVE CHAT FEEDS',
              'CHANNEL/ROOM SUBSCRIPTIONS',
            ];
            return _buildFeatureRowUpdated(features[index], index);
          }),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String feature, int index) {
    // Define different statuses for demonstration
    final statuses = [
      [true, true, true], // All have it
      [true, true, true], // All have it
      [true, true, true], // All have it
      [true, true, true], // All have it
      [true, false, true], // Mixed
      [false, true, true], // Mixed
      [false, false, true], // Only ours
      [false, false, true], // Only ours
      [false, false, true], // Only ours
      [false, false, true], // Only ours
      [false, false, true], // Only ours
      [false, false, true], // Only ours
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              feature,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: statuses[index][0] ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: statuses[index][1] ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: statuses[index][2] ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTakeawayItem({
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24, // Same as subheaders in other sections
            fontFamily: 'SFPro',
            fontWeight: FontWeight.w600, // SFPro SemiBold
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10),
        Text(
          description,
          style: TextStyle(
            fontSize: 16, // Same as body text in other sections
            fontFamily: 'SFPro', // Conforming font
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildReflectionSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white, // Keep main container white
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reflection column with F9DEAB background
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(30), // Inner padding
                  decoration: BoxDecoration(
                    color: Color(0xFFF9DEAB), // Your specified Reflection color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reflection',
                        style: TextStyle(
                          fontSize: 24, // Same as other subheaders
                          fontFamily: 'SFPro',
                          fontWeight: FontWeight.w600, // SFPro SemiBold
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildReflectionItem('Critique on Exceptionality',
                          'While there are myriad social media platforms, there are no direct communication and social media platforms centered around combat-sports or as highly developed as mainstream social media apps. None the less, not all target users might want to make a switch from legacy social media.'),
                      SizedBox(height: 15),
                      _buildReflectionItem(
                          'Some gyms do not bother with social or communication mediums at all', 'Because some gyms are less organized, the ability of gym members to create their own connections was integrated but the outcome of that is unknowable until commercial distribution'),
                      SizedBox(height: 15),
                      _buildReflectionItem(
                          'Monetization Ambiguity',
                          'Until full roll-out with time, it will remain unknown to what effect advertisements, app-purchase to download, or in-app purchases will prove most lucrative and beneficial to stakeholders'), 
                    ],
                  ),
                ),
              ),

              SizedBox(width: 40),

              // Next Steps column with F9CFAB background
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(30), // Inner padding
                  decoration: BoxDecoration(
                    color: Color(0xFFF9CFAB), // Your specified Next Steps color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Steps',
                        style: TextStyle(
                          fontSize: 24, // Same as other subheaders
                          fontFamily: 'SFPro',
                          fontWeight: FontWeight.w600, // SFPro SemiBold
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildNextStepItem('Visualize Onboarding',
                          'Creating an onboarding process to inform new users about the full functionality and utility of Tap-In.'),
                      SizedBox(height: 15),
                      _buildNextStepItem('Social Media App',
                          'I\'d like to follow user/s use of the app as an alternative to legacy social media and to what extent the gravity of X, WhatsApp, and others proves hard to break '),
                      SizedBox(height: 15),
                      _buildNextStepItem(
                          'Data Assimilation',
                          'Analyzing data metrics for use by age, rank, region and other variables might prove instrumental in design focus and upkeep down the road'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16, // Consistent with other sections
            fontFamily: 'SFPro',
            fontWeight: FontWeight.w600, // SFPro SemiBold
            color: Colors.black87,
          ),
        ),
        if (description.isNotEmpty) ...[
          SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(
              fontSize: 14, // Slightly smaller for descriptions
              fontFamily: 'SFPro', // Conforming font
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNextStepItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16, // Consistent with reflection items
            fontFamily: 'SFPro',
            fontWeight: FontWeight.w600, // SFPro SemiBold
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5),
        Text(
          description,
          style: TextStyle(
            fontSize: 14, // Slightly smaller for descriptions
            fontFamily: 'SFPro', // Conforming font
            color: Colors.black87,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildWireframeImages() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 🎛️ SPACING CONTROLS - Change these values!
        final double spacingMultiplier = 0.015; // Spacing between images (try 0.01, 0.02, 0.025)
        final double minSpacing = 2.0; // Minimum spacing (try 5, 10, 15)
        final double maxSpacing = 15.0; // Maximum spacing (try 12, 18, 25)

        final responsiveHorizontalSpacing =
            constraints.maxWidth * spacingMultiplier;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: _buildWireframeImage('assets/tapin/wireframe1.png'),
            ),
            SizedBox(
                width:
                    responsiveHorizontalSpacing.clamp(minSpacing, maxSpacing)),
            Flexible(
              child: _buildWireframeImage('assets/tapin/wireframe2.png'),
            ),
            SizedBox(
                width:
                    responsiveHorizontalSpacing.clamp(minSpacing, maxSpacing)),
            Flexible(
              child: _buildWireframeImage('assets/tapin/wireframe3.png'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWireframeImage(String imagePath) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 🎛️ QUICK SIZING CONTROLS - Change these values to experiment!
        final double spacingDivisor =  1.9; // Lower = bigger images (try 2.8, 3.0, 3.5)
        final double minWidth = 320.0; // Minimum image width (try 150, 200, 220)
        final double maxWidth = 420.0; // Maximum image width (try 280, 350, 400)
        final double aspectRatio = 1.5; // Height multiplier (try 1.8, 2.0, 2.5)
        final double innerPadding = 4.0; // Internal padding (try 4, 8, 10)

        // Calculate responsive size
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

  Widget _buildUXPyramid() {
    return Container(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Base pyramid
          Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: CustomPaint(
              painter: PyramidPainter(),
            ),
          ),
          // UX Pyramid label
          Positioned(
            left: 20,
            top: 20,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                'The UX\nPyramid',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStakeholderPrinciples() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stakeholder Management Principles',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'SFPro',
              fontWeight: FontWeight
                  .w600, // This will use SFPro SemiBold // This will use SFPro SemiBold
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildPrincipleItem(Icons.assignment, 'Do your homework',
                  'Invest time upfront to prepare and align with stakeholders. It speeds up sign-off down the line.'),
              _buildPrincipleItem(Icons.access_time, 'Waste no time',
                  'Streamline meetings by trimming unnecessary participants and appointing a coordinator to keep things on track.'),
              _buildPrincipleItem(Icons.build, 'Use tools wisely',
                  'Choose the most suitable communication method—whether it\'s email, one-on-one chats, or group meetings.'),
              _buildPrincipleItem(
                  Icons.check_circle,
                  'Done is better than perfect',
                  'Accept that not everything can be resolved. Prioritise tasks by impact using frameworks like MoSCoW.'),
              _buildPrincipleItem(Icons.visibility, 'Show, don\'t tell',
                  'Support design decisions with data and user research. Real-world examples or case studies can make a big difference.'),
              _buildPrincipleItem(Icons.people, 'Build relationships',
                  'Get to know key decision-makers and don\'t hesitate to lean on them to help resolve disputes.'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrincipleItem(IconData icon, String title, String description) {
    return Container(
      width: 250,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'SFPro',
                    fontWeight: FontWeight
                        .w600, // This will use SFPro SemiBold // This will use SFPro SemiBold
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProblemSection(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'SFPro',
            fontWeight: FontWeight
                .w600, // This will use SFPro SemiBold // This will use SFPro SemiBold
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildSolutionSection(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'SFPro',
            fontWeight: FontWeight
                .w600, // This will use SFPro SemiBold // This will use SFPro SemiBold
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildKeyFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Features',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'SFPro',
            fontWeight: FontWeight.w600, // This will use SFPro SemiBold
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        _buildFeatureItem('Design Tokens for Consistency',
            'Proposed implementing design tokens to unify design and development, reducing rework and ensuring everything looks and feels cohesive.'),
        SizedBox(height: 8),
        _buildFeatureItem('Rapid Prototyping and Testing',
            'By leveraging existing solutions, we could quickly create prototypes and present them to customers sooner, enabling us to fine-tune features before launch.'),
        SizedBox(height: 8),
        _buildFeatureItem('Extensive Interviews & User Testing',
            'By leveraging proximity to test subjects and interviewees, I could leverage rapid feedback to maximize design needs, user satisfaction, and corresponding red-designs'),
      ],
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• $title',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'SFPro',
            fontWeight: FontWeight.w600, // This will use SFPro SemiBold
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProcessOverview() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Process Overview',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'SFPro',
              fontWeight: FontWeight.w600, // This will use SFPro SemiBold
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          // Process timeline
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProcessStep('KICKOFF', ['Brief', 'Handover']),
              _buildProcessStep('DISCOVERY 1', [
                'Lean UX canvas',
                'Business case',
                'Strategy',
                'Lo-fi solutions'
              ]),
              _buildProcessStep('DISCOVERY 2', [
                'UX design',
                'Viability, desirability, feasibility analysis'
              ]),
              _buildProcessStep(
                  'CLOSING', ['Recommendations', 'Decision making']),
              _buildProcessStep('PRODUCTION', []),
            ],
          ),
          SizedBox(height: 30),
          // Stakeholder engagement timeline
          Container(
            height: 60,
            child: Stack(
              children: [
                // Timeline line
                Positioned(
                  left: 0,
                  right: 0,
                  top: 30,
                  child: Container(
                    height: 2,
                    color: Colors.grey.shade300,
                  ),
                ),
                // Process icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildProcessIcon(Icons.search, 'Secondary Research'),
                    _buildProcessIcon(
                        Icons.record_voice_over, 'Recruited and Interviewed'),
                    _buildProcessIcon(
                        Icons.analytics, 'Data Clustering & Synthesis'),
                    _buildProcessIcon(
                        Icons.lightbulb, 'Framework & Opportunity'),
                    _buildProcessIcon(Icons.lightbulb_outline, 'Ideation'),
                    _buildProcessIcon(Icons.description, 'User Testing'),
                    _buildProcessIcon(
                        Icons.design_services, 'High Fidelity Designs'),
                    _buildProcessIcon(Icons.edit_document, 'Product Planning'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessStep(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'SFPro',
            fontWeight: FontWeight.w600, // This will use SFPro SemiBold
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4),
        ...items.map((item) => Text(
              '• $item',
              style: TextStyle(
                fontSize: 10,
                color: Colors.black87,
              ),
            )),
      ],
    );
  }

  Widget _buildProcessIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue),
          ),
          child: Icon(icon, size: 20, color: Colors.blue),
        ),
        SizedBox(height: 4),
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 8,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildQualitativeInterviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Qualitative\nInterviews',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w300,
            color: Colors.black87,
            height: 1.2,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'After our secondary research, we conducted qualitative interviews to study the underlying reasons for the low emotional health and stress management of ER nurses.\n\nRecruiting ER nurses was also one of the biggest challenges we faced in our process.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
        SizedBox(height: 30),
        // Interview participants
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildParticipant('3', 'ER Nurses',
                'to understand scope of work and pain points'),
            _buildParticipant(
                '1', 'ICU Nurse', 'to understand contrast between departments'),
            _buildParticipant(
                '1', 'Nurse Union Rep', 'to learn about the current situation'),
            _buildParticipant('1', 'ER Nurse\'s Partner',
                'to understand impact on personal lives'),
          ],
        ),
      ],
    );
  }

  Widget _buildParticipant(String number, String title, String description) {
    return Container(
      width: 120,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'SFPro',
              fontWeight: FontWeight.w600, // This will use SFPro SemiBold
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 10,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInterviewCards() {
    return Container(
      height: 300,
      child: Stack(
        children: [
          // Background cards
          ...List.generate(5, (index) {
            return Positioned(
              right: index * 8.0,
              top: index * 4.0,
              child: Container(
                width: 200,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            );
          }),
          // Front card with content
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 200,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(8)),
                    ),
                    child: Center(
                      child: Text(
                        'Interviewing',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'SFPro',
                          fontWeight:
                              FontWeight.w600, // This will use SFPro SemiBold
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Myriad interviews spanning months were conducted with a wide cross-section of gym members',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Pagination dots
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: index == 0 ? Colors.blue : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRowUpdated(String feature, int index) {
    // Define different statuses for demonstration
    final statuses = [
      [false, false, true], // Only Tap-in has BJJ/Combat-Sport Specific
      [false, false, true], // Only Tap-in has Gym/Team Specific
      [false, false, true], // Only Tap-in has Centralized Gym Hub
      [true, true, true], // All have Alerts and Push Notifications
      [false, false, true], // Only Tap-in has Belt/Rank convention
      [false, true, true], // WhatsApp and Tap-in have Private Chat
      [false, true, true], // WhatsApp and Tap-in have Direct Messaging
      [false, true, true], // WhatsApp and Tap-in have Personal Photo/Avatars
      [false, true, true], // WhatsApp and Tap-in have Image/Video Hosting
      [false, false, true], // Only Tap-in has Fight Clock/Timer
      [false, true, true], // WhatsApp and Tap-in have Live Chat Feeds
      [false, false, true], // Only Tap-in has Channel/Room Subscriptions
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Feature name
          Expanded(
            flex: 3,
            child: Text(
              feature,
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'SFPro',
                fontWeight: FontWeight.w500,
                color: Colors.black87, // Same color as all other text
              ),
            ),
          ),

          // Game Changer status
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: statuses[index][0] ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // WhatsApp status
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: statuses[index][1] ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // Tap-in status
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: statuses[index][2] ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for UX Pyramid
class PyramidPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    // Draw pyramid layers
    final layers = [
      {'color': Colors.red.shade100, 'text': 'Significant'},
      {'color': Colors.orange.shade100, 'text': 'Enjoyable'},
      {'color': Colors.yellow.shade100, 'text': 'Convenient'},
      {'color': Colors.grey.shade200, 'text': 'Usable'},
      {'color': Colors.grey.shade300, 'text': 'Reliable'},
      {'color': Colors.grey.shade400, 'text': 'Functional'},
    ];

    double layerHeight = size.height / 6;

    for (int i = 0; i < layers.length; i++) {
      double topWidth = size.width * (0.3 + (i * 0.12));
      double bottomWidth = size.width * (0.3 + ((i + 1) * 0.12));
      double y = i * layerHeight;

      fillPaint.color = layers[i]['color'] as Color;

      // Draw trapezoid
      final path = Path();
      path.moveTo((size.width - topWidth) / 2, y);
      path.lineTo((size.width + topWidth) / 2, y);
      path.lineTo((size.width + bottomWidth) / 2, y + layerHeight);
      path.lineTo((size.width - bottomWidth) / 2, y + layerHeight);
      path.close();

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
