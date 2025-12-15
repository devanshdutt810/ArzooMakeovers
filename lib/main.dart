// Single-file Flutter web app: Makeup Artist Portfolio — Kanika-inspired layout
// Save as lib/main.dart in the existing Flutter project (web or mobile).
// Dependencies (add to pubspec.yaml):
//   google_fonts: ^9.0.0
// No booking functionality — just portfolio, about, services, contact, testimonials.
// Single-file Flutter web app: Makeup Artist Portfolio — Kanika-inspired layout
// Save as lib/main.dart in the existing Flutter project (web or mobile).
// Dependencies (add to pubspec.yaml):
//   google_fonts: ^9.0.0
// No booking functionality — just portfolio, about, services, contact, testimonials.

import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MakeupPortfolioApp());
}

class MakeupPortfolioApp extends StatelessWidget {
  const MakeupPortfolioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aarzoo Makeovers',
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.openSansTextTheme(ThemeData.dark().textTheme),
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFF050509),
      ),
      home: const PortfolioHome(),
    );
  }
}

// ================= SERVICES DATA =================
final Map<String, List<Map<String, dynamic>>> makeupServicesData = {
  'Air Brush': [
    {
      'title': 'Bridal Makeup',
      'inclusions':
          'Hairstyles, Hair Accessories, Colored Lenses, False Lashes, Draping',
      'studioPrice': 24999,
      'venuePrice': 30000,
    },
    {
      'title': 'Occasion Makeup',
      'inclusions':
          'Makeup for occasions like Roka, Sagan, Sangeet, Mehndi etc.',
      'studioPrice': 12999,
      'venuePrice': 15000,
    },
    {
      'title': 'Party Makeup',
      'inclusions': 'Hairstyles & False Lashes',
      'studioPrice': 4999,
      'venuePrice': 6000,
    },
  ],

  'HD': [
    {
      'title': 'Bridal Makeup',
      'inclusions':
          'Hairstyles, Hair Accessories, Colored Lenses, False Lashes, Draping',
      'studioPrice': 19999,
      'venuePrice': 25000,
    },
    {
      'title': 'Occasion Makeup',
      'inclusions':
          'Makeup for occasions like Roka, Sagan, Sangeet, Mehndi etc.',
      'studioPrice': 11999,
      'venuePrice': 15000,
    },
    {
      'title': 'Party Makeup',
      'inclusions': 'Hairstyles & False Lashes',
      'studioPrice': 3499,
      'venuePrice': 5000,
    },
  ],
  'Basic': [
    {
      'title': 'Basic Makeup',
      'inclusions': '-',
      'studioPrice': 2499,
      'venuePrice': null,
    },
  ],
};
final List<Map<String, dynamic>> preBridalPackagesData = [
  {
    'name': 'Package 1',
    'price': 6999,
    'inclusions': [
      'Face Bleach / De-Tan',
      'Facial – Blossom Kochhar (According to Skin Type)',
      'Wax – Arms & Legs (Chocolate)',
      'Manicure',
      'Pedicure',
      'Hair Spa (Loreal)',
      'Threading',
      'Upper Lips',
    ],
  },
  {
    'name': 'Package 2',
    'price': 9999,
    'inclusions': [
      'Face Bleach / De-Tan',
      'Facial – O3+ with Power Mask',
      'Full Body Wax (Chocolate)',
      'Full Body Scrub',
      'Full Body Massage (Cream)',
      'Manicure (Deluxe)',
      'Pedicure (Deluxe)',
      'Hair Spa (Loreal)',
      'Threading',
      'Upper Lips',
    ],
  },
  {
    'name': 'Package 3',
    'price': 14999,
    'inclusions': [
      'Face Bleach / De-Tan',
      'Facial – Hydra',
      'Full Body Wax (Rica)',
      'Body Polishing (Gold)',
      'Manicure (De-Tan)',
      'Pedicure (De-Tan)',
      'Hair Keratin',
      'Hair Cut',
      'Nail Extensions (Hands)',
      'Gel Nail Paint (Feet)',
      'Threading',
      'Upper Lips',
    ],
  },
];

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({Key? key}) : super(key: key);

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final GlobalKey _portfolioKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  String _activeServiceCategory = 'Air Brush';
  final ScrollController _scrollController = ScrollController();
  final PageController _testiController = PageController(viewportFraction: 1);
  final PageController _portfolioController = PageController(
    viewportFraction: 0.5,
  );
  // Testimonials data: name + quote + avatar for glassmorphic cards
  final List<Map<String, String>> _testimonials = [
    {
      'name': 'Chitra Singh',
      'quote':
          'Anjana Rajput was my makeup artist on my engagement day and I really liked her work. She did exactly what I wanted and made my bridal makeup experience really fun.',
      'avatar': 'chitra.jpeg',
    },
    {
      'name': 'Mrs. Parvesh',
      'quote':
          'Anjana understood my skin and features perfectly. The look stayed flawless all night and photographed beautifully. I received so many compliments.',
      'avatar': 'parvesh.png',
    },
    {
      'name': 'Prabha S.',
      'quote':
          'From consultation to the final touch-up, the entire experience was so professional and warm. Highly recommend for bridal and party looks.',
      'avatar': 'prabha.png',
    },
  ];
  int _currentTestimonial = 0;
  int _currentPortfolio = 0;

  // portfolio items with category to support filtering (loaded from AssetManifest)
  List<Map<String, String>> _portfolio = [];

  String _activeCategory = 'All';
  String _activeNav = 'Portfolio';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {});
    _loadPortfolioAssets();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _testiController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredPortfolio {
    if (_activeCategory == 'All') return _portfolio;
    return _portfolio
        .where((p) => (p['category'] ?? '') == _activeCategory)
        .toList();
  }

  Future<void> _loadPortfolioAssets() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      bool _isImagePath(String path) {
        return path.endsWith('.jpg') ||
            path.endsWith('.jpeg') ||
            path.endsWith('.png') ||
            path.endsWith('.webp');
      }

      // Collect bridal images
      final bridalPaths =
          manifestMap.keys
              .where(
                (path) =>
                    path.startsWith('assets/bridal/') && _isImagePath(path),
              )
              .toList()
            ..sort();

      // Collect party images
      final partyPaths =
          manifestMap.keys
              .where(
                (path) =>
                    path.startsWith('assets/party/') && _isImagePath(path),
              )
              .toList()
            ..sort();

      // Collect hair images
      final hairPaths =
          manifestMap.keys
              .where(
                (path) => path.startsWith('assets/hair/') && _isImagePath(path),
              )
              .toList()
            ..sort();

      setState(() {
        _portfolio = [
          ...bridalPaths.map((p) => {'src': p, 'category': 'Bridal'}),
          ...partyPaths.map((p) => {'src': p, 'category': 'Party'}),
          ...hairPaths.map((p) => {'src': p, 'category': 'Hair'}),
        ];
      });
    } catch (e) {
      // Optionally handle or log the error
    }
  }

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    final size = MediaQuery.of(context).size;
    final width = size.width;

    final bool isMobile = width < 700;
    final bool isTablet = width >= 700 && width < 1100;
    final bool isDesktop = width >= 1100;

    final double heroWidth = isMobile
        ? width - 32
        : (isTablet ? width * 0.8 : 780.0);

    final double portfolioCardWidth = isDesktop
        ? width * 0.23
        : (isTablet ? width * 0.4 : width * 0.72);

    final double portfolioCardHeight = isDesktop
        ? 520.0
        : (isTablet ? 460.0 : 360.0);

    final double portfolioCarouselHeight = portfolioCardHeight + 80;

    final double navWidth = (width - 32) < 820.0 ? (width - 32) : 820.0;

    // Testimonials sizing
    final double testimonialCardHeight = isMobile ? 300.0 : 210.0;
    final double testimonialTrackHeight = testimonialCardHeight + 40.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Main scrollable content with background image and dark overlay
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
                // colorFilter: ColorFilter.mode(
                //   Colors.black.withOpacity(0.6),
                //   BlendMode.darken,
                // ),
              ),
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Spacer so hero sits comfortably below navbar
                  const SizedBox(height: 120),

                  // Hero (minimal, centered) — transparent on gradient background
                  Center(
                    child: GlassmorphicContainer(
                      width: heroWidth,
                      height: isMobile ? 340 : 320,
                      borderRadius: 24,
                      blur: 18,
                      alignment: Alignment.center,
                      border: 1,
                      linearGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.14),
                          Colors.white.withOpacity(0.04),
                        ],
                      ),
                      borderGradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.35),
                          Colors.white.withOpacity(0.08),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 28,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/imp_files/logo.png',
                              width: isMobile ? 160 : 190,
                              height: isMobile ? 160 : 190,
                            ),
                            // CircleAvatar(
                            //   radius: 92,
                            //   backgroundImage: AssetImage(
                            //     'assets/imp_files/logo.png',
                            //   ),
                            //   backgroundColor: Colors.transparent,
                            // ),
                            // Text(
                            //   'Aarzoo Makeovers',
                            //   style: TextStyle(
                            //     fontSize: isMobile ? 30 : 44,
                            //     fontWeight: FontWeight.w800,
                            //     height: 1.02,
                            //     color: const Color(0xFFE85D83).withOpacity(0.9),
                            //   ),
                            // ),
                            //const SizedBox(height: 10),
                            // Text(
                            //   'Bridal • Party • Hair',
                            //   style: TextStyle(
                            //     fontSize: isMobile ? 13 : 16,
                            //     color: Colors.white,
                            //   ),
                            // ),
                            const SizedBox(height: 22),
                            SizedBox(
                              width: isMobile ? width - 64 : 720,
                              child: Text(
                                'Professional makeup artist based in Delhi. Creating timeless bridal looks and editorial worthy transformations that photograph beautifully.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Portfolio header + category chips (directly on gradient)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28.0,
                      vertical: 24.0,
                    ),
                    child: Container(
                      key: _portfolioKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Signature Looks',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w700,
                                height: 0.95,
                                color: Color(0xFFE85D83).withOpacity(0.9),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Center(
                            child: Wrap(
                              spacing: 8,
                              children: ['All', 'Party', 'Bridal', 'Hair']
                                  .map(
                                    (c) => Padding(
                                      padding: EdgeInsets.all(8),
                                      child: GlassmorphicContainer(
                                        width: 110.0,
                                        height: 40.0,
                                        borderRadius: 999,
                                        blur: 18,
                                        alignment: Alignment.center,
                                        border: 1,
                                        linearGradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: _activeCategory == c
                                              ? [
                                                  const Color(
                                                    0xFFE85D83,
                                                  ).withOpacity(0.9),
                                                  Colors.white.withOpacity(
                                                    0.10,
                                                  ),
                                                ]
                                              : [
                                                  Colors.white.withOpacity(
                                                    0.12,
                                                  ),
                                                  Colors.white.withOpacity(
                                                    0.04,
                                                  ),
                                                ],
                                        ),
                                        borderGradient: LinearGradient(
                                          colors: [
                                            _activeCategory == c
                                                ? const Color(
                                                    0xFFE85D83,
                                                  ).withOpacity(0.9)
                                                : Colors.white24,
                                            Colors.white.withOpacity(0.05),
                                          ],
                                        ),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _activeCategory = c;
                                              _currentPortfolio = 0;
                                            });
                                            if (_filteredPortfolio.isNotEmpty) {
                                              _portfolioController.jumpToPage(
                                                0,
                                              );
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            child: Text(
                                              c,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: _activeCategory == c
                                                    ? Colors.white
                                                    : Colors.white.withOpacity(
                                                        0.78,
                                                      ),
                                                fontSize: 13,
                                                fontWeight: _activeCategory == c
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Portfolio carousel — cinematic horizontal slider
                          Center(
                            child: SizedBox(
                              height: portfolioCarouselHeight,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  PageView.builder(
                                    controller: _portfolioController,
                                    itemCount: _filteredPortfolio.length,
                                    onPageChanged: (index) {
                                      setState(() => _currentPortfolio = index);
                                    },
                                    itemBuilder: (context, index) {
                                      final item = _filteredPortfolio[index];
                                      final src = item['src']!;
                                      final category = item['category']!;

                                      return AnimatedBuilder(
                                        animation: _portfolioController,
                                        builder: (context, child) {
                                          double scale = 1.0;
                                          if (_portfolioController
                                              .position
                                              .haveDimensions) {
                                            final page =
                                                _portfolioController.page ??
                                                0.0;
                                            final diff = (page - index).abs();
                                            scale = (1 - diff * 0.15).clamp(
                                              0.85,
                                              1.0,
                                            );
                                          }
                                          return Transform.scale(
                                            scale: scale,
                                            child: child,
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                            vertical: 8.0,
                                          ),
                                          child: _PortfolioTile(
                                            src: src,
                                            width: portfolioCardWidth,
                                            height: portfolioCardHeight,
                                            category: category,
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  // Left arrow for portfolio carousel
                                  Positioned(
                                    left: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (_filteredPortfolio.isEmpty)
                                            return;
                                          final prev = _currentPortfolio;
                                          final target = (prev - 1).clamp(
                                            0,
                                            _filteredPortfolio.length - 1,
                                          );
                                          _portfolioController.animateToPage(
                                            target,
                                            duration: const Duration(
                                              milliseconds: 400,
                                            ),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                        child: const _SliderArrow(
                                          icon:
                                              Icons.arrow_back_ios_new_rounded,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Right arrow for portfolio carousel
                                  Positioned(
                                    right: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (_filteredPortfolio.isEmpty)
                                            return;
                                          final next = _currentPortfolio;
                                          final target = (next + 1).clamp(
                                            0,
                                            _filteredPortfolio.length - 1,
                                          );
                                          _portfolioController.animateToPage(
                                            target,
                                            duration: const Duration(
                                              milliseconds: 400,
                                            ),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                        child: const _SliderArrow(
                                          icon: Icons.arrow_forward_ios_rounded,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 36),
                          // ================= END SERVICES SECTION =================

                          // About + Services similar to Kanika site
                          // About — editorial reference style
                          Container(
                            key: _aboutKey,
                            child: GlassmorphicContainer(
                              width: double.infinity,
                              height: 520.0,
                              borderRadius: 24,
                              blur: 18,
                              alignment: Alignment.center,
                              border: 1,
                              linearGradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.12),
                                  Colors.white.withOpacity(0.03),
                                ],
                              ),
                              borderGradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.35),
                                  Colors.white.withOpacity(0.05),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: SingleChildScrollView(
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final bool isNarrowAbout =
                                          constraints.maxWidth < 900;

                                      final imageWidget = ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                          'assets/imp_files/AnjanaRajput.png',
                                          fit: BoxFit.cover,
                                          height: isNarrowAbout ? 300 : 440,
                                        ),
                                      );

                                      final textWidget = Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Meet Anjana Rajput',
                                            style: TextStyle(
                                              fontSize: isNarrowAbout ? 32 : 50,
                                              fontWeight: FontWeight.w700,
                                              height: 0.95,
                                              color: const Color(
                                                0xFFE85D83,
                                              ).withOpacity(0.9),
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          Text(
                                            'Top Makeup Artist in\nDelhi NCR',
                                            style: TextStyle(
                                              fontSize: isNarrowAbout ? 22 : 32,
                                              fontWeight: FontWeight.w500,
                                              height: 1.15,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          Text(
                                            'Anjana Rajput is a professional makeup artist in Delhi, with incredible expertise and knowledge in transforming a woman’s beauty with a touch of her makeup brush. Pursuing her passion in this field, Anjana learned the art of makeup & also holds professional certifications. This makes her blend the art of makeup with tailored skincare solutions that enhances your beauty from inside out.',
                                            style: TextStyle(
                                              fontSize: 15,
                                              height: 1.7,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Anjana\'s sophisticated and stylish personality reflects in her makeup, resulting in marvellous beauty makeovers that make heads turn in appreciation.',
                                            style: TextStyle(
                                              fontSize: 15,
                                              height: 1.7,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      );

                                      if (isNarrowAbout) {
                                        // On mobile / narrow: stack image then text, no Expanded
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            imageWidget,
                                            const SizedBox(height: 24),
                                            textWidget,
                                          ],
                                        );
                                      } else {
                                        // On wide screens: side-by-side using Expanded
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(child: imageWidget),
                                            const SizedBox(width: 32),
                                            Expanded(child: textWidget),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 36),

                          // ================= SERVICES SECTION =================
                          Container(
                            key: _servicesKey,
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    'Our Services',
                                    style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.w700,
                                      height: 0.95,
                                      color: const Color(
                                        0xFFE85D83,
                                      ).withOpacity(0.9),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Center(
                                  child: Wrap(
                                    spacing: 8,
                                    children: makeupServicesData.keys.map((
                                      category,
                                    ) {
                                      final bool isActive =
                                          _activeServiceCategory == category;
                                      return Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: GlassmorphicContainer(
                                          width: 130,
                                          height: 40,
                                          borderRadius: 999,
                                          blur: 18,
                                          alignment: Alignment.center,
                                          border: 1,
                                          linearGradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: isActive
                                                ? [
                                                    const Color(
                                                      0xFFE85D83,
                                                    ).withOpacity(0.9),
                                                    Colors.white.withOpacity(
                                                      0.10,
                                                    ),
                                                  ]
                                                : [
                                                    Colors.white.withOpacity(
                                                      0.12,
                                                    ),
                                                    Colors.white.withOpacity(
                                                      0.04,
                                                    ),
                                                  ],
                                          ),
                                          borderGradient: LinearGradient(
                                            colors: [
                                              isActive
                                                  ? const Color(
                                                      0xFFE85D83,
                                                    ).withOpacity(0.9)
                                                  : Colors.white24,
                                              Colors.white.withOpacity(0.05),
                                            ],
                                          ),
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _activeServiceCategory =
                                                    category;
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 18,
                                                    vertical: 8,
                                                  ),
                                              child: Text(
                                                category,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: isActive
                                                      ? FontWeight.w600
                                                      : FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Column(
                                  children: makeupServicesData[_activeServiceCategory]!.map((
                                    service,
                                  ) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      child: GlassmorphicContainer(
                                        width: double.infinity,
                                        height: isMobile ? 220 : 180,
                                        borderRadius: 24,
                                        blur: 18,
                                        alignment: Alignment.centerLeft,
                                        border: 1,
                                        linearGradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white.withOpacity(0.14),
                                            Colors.white.withOpacity(0.04),
                                          ],
                                        ),
                                        borderGradient: LinearGradient(
                                          colors: [
                                            Colors.white.withOpacity(0.35),
                                            Colors.white.withOpacity(0.05),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  service['title'],
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  service['inclusions'],
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    height: 1.5,
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                                const SizedBox(height: 18),
                                                Wrap(
                                                  spacing: 12,
                                                  runSpacing: 12,
                                                  children: [
                                                    _PricePill(
                                                      label: 'Studio',
                                                      price:
                                                          service['studioPrice'],
                                                    ),
                                                    _PricePill(
                                                      label: 'Venue',
                                                      price:
                                                          service['venuePrice'],
                                                      accent: true,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 48),
                                Center(
                                  child: Text(
                                    'Pre-Bridal Packages',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(
                                        0xFFE85D83,
                                      ).withOpacity(0.9),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Wrap(
                                  spacing: 24,
                                  runSpacing: 24,
                                  children: preBridalPackagesData.map((pkg) {
                                    return GlassmorphicContainer(
                                      width: isMobile ? width - 32 : 360,
                                      height: isMobile ? 520 : 420,
                                      borderRadius: 24,
                                      blur: 18,
                                      alignment: Alignment.centerLeft,
                                      border: 1,
                                      linearGradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white.withOpacity(0.14),
                                          Colors.white.withOpacity(0.04),
                                        ],
                                      ),
                                      borderGradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.35),
                                          Colors.white.withOpacity(0.05),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                pkg['name'],
                                                style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              ...pkg['inclusions']
                                                  .map<Widget>(
                                                    (i) => Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            bottom: 6,
                                                          ),
                                                      child: Text(
                                                        '• $i',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white70,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              const SizedBox(height: 16),
                                              _PricePill(
                                                label: 'Price',
                                                price: pkg['price'],
                                                accent: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 56),
                              ],
                            ),
                          ),

                          // Testimonials — large editorial slider look
                          // Testimonials — swipeable card slider
                          // Center(
                          //   child: Text(
                          //     'Testimonials',
                          //     style: TextStyle(
                          //       fontSize: 26,
                          //       fontWeight: FontWeight.w700,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              'What Our Clients Say',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w700,
                                height: 0.95,
                                color: Color(0xFFE85D83).withOpacity(0.9),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // swipeable framed PageView
                          // swipeable framed PageView
                          Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: testimonialTrackHeight,
                                    color: Colors.transparent,
                                  ),

                                  // Main PageView slider
                                  SizedBox(
                                    height: testimonialTrackHeight,
                                    child: PageView.builder(
                                      controller: _testiController,
                                      itemCount: _testimonials.length,
                                      onPageChanged: (index) {
                                        setState(
                                          () => _currentTestimonial = index,
                                        );
                                      },
                                      itemBuilder: (context, index) {
                                        final t = _testimonials[index];
                                        return Center(
                                          child: SizedBox.fromSize(
                                            size: Size(
                                              MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.72,
                                              testimonialCardHeight,
                                            ),
                                            child: _TestimonialCard(
                                              name: t['name']!,
                                              quote: t['quote']!,
                                              avatar: t['avatar']!,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  // Left arrow
                                  Positioned(
                                    left: 0,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 12),
                                      child: GestureDetector(
                                        onTap: () {
                                          final prev = _currentTestimonial;
                                          final target = (prev - 1).clamp(
                                            0,
                                            _testimonials.length - 1,
                                          );
                                          _testiController.animateToPage(
                                            target,
                                            duration: const Duration(
                                              milliseconds: 400,
                                            ),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                        child: const _SliderArrow(
                                          icon:
                                              Icons.arrow_back_ios_new_rounded,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Right arrow
                                  Positioned(
                                    right: 0,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 12),
                                      child: GestureDetector(
                                        onTap: () {
                                          final next = _currentTestimonial;
                                          final target = (next + 1).clamp(
                                            0,
                                            _testimonials.length - 1,
                                          );
                                          _testiController.animateToPage(
                                            target,
                                            duration: const Duration(
                                              milliseconds: 400,
                                            ),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                        child: const _SliderArrow(
                                          icon: Icons.arrow_forward_ios_rounded,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 36),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_testimonials.length, (i) {
                              final selected = _currentTestimonial == i;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: selected ? 18 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFFE85D83)
                                      : Colors.white24,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 36),

                          // Connect section with circular glassmorphic buttons
                          Container(
                            key: _contactKey,
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Connect with Us',
                                    style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.w700,
                                      height: 0.95,
                                      color: Color(0xFFE85D83).withOpacity(0.9),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 18,
                                    runSpacing: 18,
                                    children: [
                                      _ContactCircleButton(
                                        assetPath: 'assets/icons/telephone.png',
                                        tooltip: 'Call',
                                        onTap: () =>
                                            _launchUri('tel:9540686022'),
                                      ),
                                      _ContactCircleButton(
                                        assetPath: 'assets/icons/instagram.png',
                                        tooltip: 'Instagram',
                                        onTap: () => _launchUri(
                                          'https://instagram.com/aarzoomakeover',
                                        ),
                                      ),
                                      _ContactCircleButton(
                                        assetPath: 'assets/icons/whatsapp.png',
                                        tooltip: 'WhatsApp',
                                        onTap: () => _launchUri(
                                          'https://wa.me/9540686022',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Footer
                          Center(
                            child: Text(
                              '© $year Aarzoo Makeovers — All rights reserved.',
                            ),
                          ),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Sticky navbar — glassmorphic using package
          // Sticky navbar — centered, glassmorphic using package
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Center(
                child: GlassmorphicContainer(
                  width: navWidth, // responsive, shorter fixed width, centered
                  height: 72,
                  borderRadius: 40,
                  blur: 18,
                  alignment: Alignment.center,
                  border: 1,
                  linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.15),
                      Colors.white.withOpacity(0.03),
                    ],
                  ),
                  borderGradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.35),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Container(
                          //   width: 46,
                          //   height: 46,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(50),
                          //     gradient: const LinearGradient(
                          //       colors: [Color(0xFFFFA3D7), Color(0xFFFF6B9A)],
                          //     ),
                          //   ),
                          //   child: const Center(
                          //     child: Icon(Icons.brush, color: Colors.white),
                          //   ),
                          // ),
                          // CircleAvatar(
                          //   radius: 48,
                          //   backgroundImage: AssetImage(
                          //     'assets/imp_files/logo.png',
                          //   ),
                          //   backgroundColor: Colors.transparent,
                          // ),
                          // const SizedBox(width: 15),
                          _NavLabel(
                            'Portfolio',
                            isActive: _activeNav == 'Portfolio',
                            onTap: () {
                              setState(() => _activeNav = 'Portfolio');
                              _scrollToKey(_portfolioKey);
                            },
                          ),
                          const SizedBox(width: 15),
                          _NavLabel(
                            'About',
                            isActive: _activeNav == 'About',
                            onTap: () {
                              setState(() => _activeNav = 'About');
                              _scrollToKey(_aboutKey);
                            },
                          ),
                          const SizedBox(width: 15),
                          _NavLabel(
                            'Services',
                            isActive: _activeNav == 'Services',
                            onTap: () {
                              setState(() => _activeNav = 'Services');
                              _scrollToKey(_servicesKey);
                            },
                          ),
                          const SizedBox(width: 15),
                          _NavLabel(
                            'Contact',
                            isActive: _activeNav == 'Contact',
                            onTap: () {
                              setState(() => _activeNav = 'Contact');
                              _scrollToKey(_contactKey);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToKey(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      alignment: 0.1,
    );
  }

  Future<void> _launchUri(String uri) async {
    final url = Uri.parse(uri);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // ignore failure in UI; could show a snackbar if needed
    }
  }
}

class _ContactCircleButton extends StatelessWidget {
  final String assetPath;
  final String tooltip;
  final VoidCallback onTap;

  const _ContactCircleButton({
    required this.assetPath,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: 72,
      height: 72,
      borderRadius: 36,
      blur: 18,
      alignment: Alignment.center,
      border: 1,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.18),
          Colors.white.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.4), Colors.white.withOpacity(0.08)],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Tooltip(
          message: tooltip,
          child: Image.asset(
            assetPath,
            width: 36,
            height: 36,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _NavLabel extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const _NavLabel(this.text, {required this.onTap, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final List<Color> bgColors = isActive
        ? [
            const Color(0xFFE85D83).withOpacity(0.9),
            Colors.white.withOpacity(0.10),
          ]
        : [Colors.white.withOpacity(0.12), Colors.white.withOpacity(0.04)];

    final List<Color> borderColors = isActive
        ? [
            const Color(0xFFE85D83).withOpacity(0.9),
            Colors.white.withOpacity(0.05),
          ]
        : [Colors.white24, Colors.white.withOpacity(0.05)];

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: GlassmorphicContainer(
          width: 110.0,
          height: 40.0,
          borderRadius: 999,
          blur: 18,
          alignment: Alignment.center,
          border: 1,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: bgColors,
          ),
          borderGradient: LinearGradient(colors: borderColors),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PortfolioTile extends StatefulWidget {
  final String src;
  final double width;
  final double height;
  final String category;
  const _PortfolioTile({
    required this.src,
    required this.width,
    required this.height,
    required this.category,
    Key? key,
  }) : super(key: key);

  @override
  State<_PortfolioTile> createState() => _PortfolioTileState();
}

class _PortfolioTileState extends State<_PortfolioTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => _openLightbox(context, widget.src),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 220),
          scale: _hover ? 1.03 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(_hover ? 0.28 : 0.08),
                width: 0.6,
              ),
              boxShadow: _hover
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.28),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: widget.src,
                    child: widget.src.startsWith('assets/')
                        ? Image.asset(widget.src, fit: BoxFit.cover)
                        : Image.network(widget.src, fit: BoxFit.cover),
                  ),
                  // Bottom overlay with category + view label
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _hover ? 1.0 : 0.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.85),
                              Colors.black.withOpacity(0.0),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.fullscreen,
                                  size: 14,
                                  color: Colors.white70,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'View In Fullscreen',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openLightbox(BuildContext context, String src) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Hero(
                        tag: src,
                        child: src.startsWith('assets/')
                            ? Image.asset(src, fit: BoxFit.contain)
                            : Image.network(src, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Slider arrow helper widget for testimonials slider
class _SliderArrow extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _SliderArrow({required this.icon, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: 48,
      height: 48,
      borderRadius: 24,
      blur: 14,
      alignment: Alignment.center,
      border: 1,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.18),
          Colors.white.withOpacity(0.04),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.35),
          Colors.white.withOpacity(0.05),
        ],
      ),
      child: Icon(icon, size: 20, color: Colors.white.withOpacity(0.9)),
    );
  }
}

class _PricePill extends StatelessWidget {
  final String label;
  final int? price;
  final bool accent;

  const _PricePill({
    required this.label,
    required this.price,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##,###');
    return GlassmorphicContainer(
      width: 140,
      height: 40,
      borderRadius: 999,
      blur: 16,
      alignment: Alignment.center,
      border: 1,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: price == null
            ? [Colors.white.withOpacity(0.06), Colors.white.withOpacity(0.02)]
            : accent
            ? [
                const Color(0xFFE85D83).withOpacity(0.9),
                Colors.white.withOpacity(0.12),
              ]
            : [Colors.white.withOpacity(0.18), Colors.white.withOpacity(0.05)],
      ),
      borderGradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.35),
          Colors.white.withOpacity(0.05),
        ],
      ),
      child: Text(
        price == null ? '$label: N/A' : '$label: ₹${formatter.format(price)}',
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String name;
  final String quote;
  final String avatar;

  const _TestimonialCard({
    required this.name,
    required this.quote,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 700;
    final double cardHeight = isMobile ? 280 : 200;

    return GlassmorphicContainer(
      width: double.infinity,
      height: cardHeight,
      borderRadius: 24,
      blur: 18,
      alignment: Alignment.center,
      border: 0,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.14),
          Colors.white.withOpacity(0.04),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          Colors.transparent.withOpacity(0.35),
          Colors.transparent.withOpacity(0.08),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GlassmorphicContainer(
                width: 112,
                height: 112,
                borderRadius: 56,
                blur: 12,
                alignment: Alignment.center,
                border: 1,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.22),
                    Colors.white.withOpacity(0.06),
                  ],
                ),
                borderGradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.55),
                    Colors.white.withOpacity(0.10),
                  ],
                ),
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: AssetImage('assets/avatars/$avatar'),
                  backgroundColor: Colors.transparent,
                ),
              ),
              //Text(''),
              Center(
                child: Text(
                  quote,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.white,
                  ),
                ),
              ),
              //Text(''),
              Center(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Color(0xFFE85D83),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SocialChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
