import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ecommerce_app/widgets/about_section.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'package:ecommerce_app/screens/product_detail_screen.dart';

/// ───────────────────────────────────────────────────────────
///  CUSTOM IMAGE SLIDER  (no external package)
/// ───────────────────────────────────────────────────────────
class CustomImageSlider extends StatefulWidget {
  final List<String> imagePaths;
  const CustomImageSlider({super.key, required this.imagePaths});

  @override
  State<CustomImageSlider> createState() => _CustomImageSliderState();
}

class _CustomImageSliderState extends State<CustomImageSlider> {
  late final PageController _controller;
  int _current = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: .85);
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_controller.hasClients) {
        _current = (_current + 1) % widget.imagePaths.length;
        _controller.animateToPage(
          _current,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 200,
    child: Stack(
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.imagePaths.length,
          itemBuilder: (_, i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AnimatedOpacity(
                opacity: _current == i ? 1.0 : 0.7,
                duration: const Duration(milliseconds: 300),
                child: Image.asset(widget.imagePaths[i],
                    fit: BoxFit.cover, width: double.infinity),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.imagePaths.length, (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                height: 8,
                width: _current == i ? 24 : 8,
                decoration: BoxDecoration(
                  color: _current == i ? const Color(0xFF7DA7FF) : Colors.white38,
                  borderRadius: BorderRadius.circular(4),
                ),
              )),
            ),
          ),
        ),
      ],
    ),
  );
}

/// ───────────────────────────────────────────────────────────
///  HOME  SCREEN
/// ───────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _selectedIndex = 0; // Track selected navigation item

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Dummy data --------------------------------------------------------------
  final List<String> carouselImgs = const [
    'assets/images/slide1.png',
    'assets/images/slide2.png',
    'assets/images/slide3.png',
  ];

  final List<Map<String, dynamic>> categories = const [
    {'title': 'Men',        'icon': Icons.male},
    {'title': 'Women',      'icon': Icons.female},
    {'title': 'Kids',       'icon': Icons.child_care_outlined},
    {'title': 'Discounted', 'icon': Icons.discount_outlined},
    {'title': 'Old Money',  'icon': Icons.currency_exchange},
    {'title': 'Trending',   'icon': Icons.trending_up},
    {'title': 'Sports',     'icon': Icons.sports_baseball},
    {'title': 'Smartwatch', 'icon': Icons.watch},
  ];

  final List<Map<String, dynamic>> trending = const [
    {
      'img': 'assets/images/watch1.png',
      'name': 'Omega Seamaster',
      'price': '2,199 Rs',
      'originalPrice': '2,999 Rs',
      'discount': '25% OFF',
      'rating': 4.8,
      'reviews': 156,
      'ownerLogo': 'assets/images/logo.png',
      'tag': 'Luxury',
      'isFavorite': false,
    },
    {
      'img': 'assets/images/watch2.png',
      'name': 'Rolex Submariner',
      'price': '8,650 Rs',
      'originalPrice': '9,999 Rs',
      'discount': '13% OFF',
      'rating': 4.9,
      'reviews': 89,
      'ownerLogo': 'assets/images/logo.png',
      'tag': 'Premium',
      'isFavorite': true,
    },
    {
      'img': 'assets/images/watch3.png',
      'name': 'Apple Watch Ultra',
      'price': '799 Rs',
      'originalPrice': '899 Rs',
      'discount': '11% OFF',
      'rating': 4.7,
      'reviews': 234,
      'ownerLogo': 'assets/images/logo.png',
      'tag': 'Smart',
      'isFavorite': false,
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _controller.forward(from: 0); // Trigger animation for the tap effect
    });
    if (index != _selectedIndex && Navigator.canPop(context)) {
      Navigator.pushNamed(context, '/${['home', 'categories', 'cart', 'profile'][index]}');
    }
  }

  void _navigateToStore() {
    // Placeholder for future store screen navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Store (To be implemented)')),
    );
  }

  void _navigateToProductDetail(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  void _toggleFavorite(int index) {
    setState(() {
      trending[index]['isFavorite'] = !trending[index]['isFavorite'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFF7DA7FF);
    final userName = 'Abdullah';
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 260,
            collapsedHeight: 60,
            backgroundColor: Colors.transparent,
            pinned: true,
            clipBehavior: Clip.antiAlias,
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(45)),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: LayoutBuilder(
                builder: (context, constraints) {
                  final top = constraints.biggest.height;
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildAppBarContent(accent, userName),
                      if (top <= 100)
                        Center(
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 50,
                            fit: BoxFit.contain,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CustomImageSlider(imagePaths: carouselImgs),
            ),
          ),
          SliverToBoxAdapter(
              child: _buildSectionHeader(context, 'Categories')),
          SliverToBoxAdapter(child: _buildCategoriesRow(accent)),
          SliverToBoxAdapter(
              child: _buildSectionHeader(context, 'Trending Watches')),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: screenWidth > 600 ? 3 : 2,
                childAspectRatio: _getChildAspectRatio(screenWidth, screenHeight),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, i) => _buildEnhancedTrendingItem(i, accent, screenWidth),
                childCount: trending.length,
              ),
            ),
          ),
          SliverToBoxAdapter(child: AboutSection(accent: accent)),
          SliverToBoxAdapter(child: _buildContactSection(accent)),
          const SliverToBoxAdapter(child: SizedBox(height: 80)), // Space for bottom nav
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        animationController: _controller, // Pass the animation controller for smooth transitions
      ),
    );
  }

  // Helper method to get responsive aspect ratio
  double _getChildAspectRatio(double screenWidth, double screenHeight) {
    if (screenWidth < 360) {
      // Very small screens (old phones)
      return 0.55;
    } else if (screenWidth < 400) {
      // Small screens
      return 0.6;
    } else if (screenWidth < 500) {
      // Medium screens
      return 0.65;
    } else if (screenWidth > 600) {
      // Tablets and larger screens
      return 0.7;
    } else {
      // Default for most phones
      return 0.62;
    }
  }

  // ── APP BAR CONTENT ──────────────────────────────────────────────────────
  Widget _buildAppBarContent(Color accent, String name) {
    final double topPad = MediaQuery.of(context).padding.top;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(45)),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent.withOpacity(.45), Colors.black87],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54.withOpacity(.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16 + topPad, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _controller.forward(from: 0),
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (_, child) => Transform.scale(
                          scale: 1 + _animation.value * 0.1,
                          child: child,
                        ),
                        child: const CircleAvatar(
                          radius: 22,
                          backgroundImage: AssetImage('assets/images/img.jpg'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    'Hello $name!\n Find your dream Watches here!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.1),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white.withOpacity(.15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26.withOpacity(.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      const Icon(Icons.search, color: Colors.tealAccent, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: 'Search your favourites...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.white54, fontSize: 16),
                          ),
                          onTap: () => _controller.forward(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── SECTION HEADERS, CATEGORIES, TRENDING, CONTACT ───────────────────────
  Widget _buildSectionHeader(BuildContext ctx, String title) => Padding(
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
    child: Row(
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w700)),
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/categories');
          },
          child: const Text('View All', style: TextStyle(color: Color(0xFF7DA7FF))),
        ),
      ],
    ),
  );

  Widget _buildCategoriesRow(Color accent) => SizedBox(
    height: 100,
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, i) {
        final cat = categories[i];
        return GestureDetector(
          onTap: () {},
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 85,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white.withOpacity(.08), Colors.grey[900]!],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(cat['icon'], color: accent, size: 30),
                  const SizedBox(height: 6),
                  Text(cat['title'],
                      style: const TextStyle(
                          fontSize: 12, color: Colors.white70)),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );

  Widget _buildEnhancedTrendingItem(int idx, Color accent, double screenWidth) {
    final item = trending[idx];
    final isSmallScreen = screenWidth < 400;
    final isVerySmallScreen = screenWidth < 360;

    return GestureDetector(
      onTap: () => _navigateToProductDetail(item),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey[900]!.withOpacity(0.9),
              Colors.black87,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: accent.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with overlay elements
            Expanded(
              flex: isVerySmallScreen ? 2 : 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Stack(
                  children: [
                    // Main image
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.asset(
                        item['img'],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    // Discount badge
                    if (item['discount'] != null)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isVerySmallScreen ? 6 : 8,
                            vertical: isVerySmallScreen ? 3 : 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            item['discount'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isVerySmallScreen ? 8 : 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    // Favorite button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => _toggleFavorite(idx),
                        child: Container(
                          padding: EdgeInsets.all(isVerySmallScreen ? 4 : 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            item['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                            color: item['isFavorite'] ? Colors.red : Colors.white,
                            size: isVerySmallScreen ? 14 : 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content section
            Expanded(
              flex: isVerySmallScreen ? 3 : 2,
              child: Padding(
                padding: EdgeInsets.all(isVerySmallScreen ? 8 : 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Owner and name row
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _navigateToStore,
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: accent.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: isVerySmallScreen ? 10 : 12,
                              backgroundImage: AssetImage(item['ownerLogo']),
                            ),
                          ),
                        ),
                        SizedBox(width: isVerySmallScreen ? 6 : 8),
                        Expanded(
                          child: Text(
                            item['name'],
                            style: TextStyle(
                              fontSize: isVerySmallScreen ? 11 : 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                            maxLines: isVerySmallScreen ? 2 : 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isVerySmallScreen ? 4 : 6),
                    // Price section
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              item['price'],
                              style: TextStyle(
                                fontSize: isVerySmallScreen ? 12 : 13,
                                color: accent,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          SizedBox(width: isVerySmallScreen ? 4 : 6),
                          if (item['originalPrice'] != null)
                            Flexible(
                              child: Text(
                                item['originalPrice'],
                                style: TextStyle(
                                  fontSize: isVerySmallScreen ? 9 : 10,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: isVerySmallScreen ? 4 : 6),
                    // Rating and tag section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Rating
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: isVerySmallScreen ? 10 : 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${item['rating']}',
                                style: TextStyle(
                                  fontSize: isVerySmallScreen ? 9 : 10,
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '(${item['reviews']})',
                                style: TextStyle(
                                  fontSize: isVerySmallScreen ? 8 : 9,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Tag
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isVerySmallScreen ? 4 : 6,
                            vertical: isVerySmallScreen ? 1 : 2,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                accent.withOpacity(0.2),
                                accent.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: accent.withOpacity(0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            item['tag'],
                            style: TextStyle(
                              fontSize: isVerySmallScreen ? 7 : 8,
                              color: accent,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(Color accent) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Contact Us',
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => Column(
            children: [
              _contactRow(Icons.location_on_outlined, '123 Market St, Lahore'),
              const SizedBox(height: 8),
              _contactRow(Icons.email_outlined, 'support@watchease.com'),
              const SizedBox(height: 8),
              _contactRow(FontAwesomeIcons.linkedin, 'linkedin.com/company/watchease'),
              const SizedBox(height: 8),
              _contactRow(FontAwesomeIcons.instagram, '@watch.ease'),
              const SizedBox(height: 8),
              _contactRow(FontAwesomeIcons.globe, 'www.watchease.com'),
            ].map((widget) => Transform.translate(
              offset: Offset(0, _animation.value * -10),
              child: Opacity(
                opacity: _animation.value,
                child: widget,
              ),
            )).toList(),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text('© 2025 WatchEase',
              style: TextStyle(color: Colors.white54, fontSize: 12)),
        ),
      ],
    ),
  );

  Widget _contactRow(IconData icon, String txt) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white.withOpacity(.05), Colors.grey[900]!],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.lightBlueAccent, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(txt,
                  style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ),
          ],
        ),
      ),
    ),
  );
}