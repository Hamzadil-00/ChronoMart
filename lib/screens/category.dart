import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/bottom_navigation_bar.dart'; // Import the separate BottomNavBar widget

class CategoriesScreen extends StatefulWidget {
  static const String routeName = '/categories';

  final List<Map<String, dynamic>> categories = const [
    {'title': 'Louis Moinet Watches', 'icon': Icons.watch},
    {'title': 'Trending for Men', 'icon': Icons.male},
    {'title': 'Trending for Women', 'icon': Icons.female},
    {'title': 'Trending for Kids', 'icon': Icons.child_care_outlined},
    {'title': 'Accessories', 'icon': Icons.shopping_bag},
    {'title': 'Discounted', 'icon': Icons.discount_outlined},
    {'title': 'Old Money', 'icon': Icons.currency_exchange},
    {'title': 'Sports', 'icon': Icons.sports_baseball},
    {'title': 'Smartwatch', 'icon': Icons.watch_later},
  ];

  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredCategories = [];
  String _selectedPriceFilter = 'All';
  int _selectedIndex = 1; // Default to Categories

  // List of unique images for each category
  final List<String> _categoryImages = [
    'assets/images/category/oldmoney.png',
    'assets/images/category/men.png',
    'assets/images/category/women.png',
    'assets/images/category/kids.png',
    'assets/images/category/men.png',
    'assets/images/category/women.png',
    'assets/images/category/oldmoney.png',
    'assets/images/category/kids.png',
    'assets/images/category/men.png',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _filteredCategories = widget.categories; // Initialize with all categories
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        setState(() {
          // Trigger subtle pop effect
        });
      }
    });
    _searchController.addListener(_filterCategories);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterCategories() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCategories = widget.categories.where((category) {
        final title = category['title'].toLowerCase();
        return title.contains(query);
      }).toList();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text('Filter by Price', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All', style: TextStyle(color: Colors.white70)),
              onTap: () {
                setState(() => _selectedPriceFilter = 'All');
                Navigator.pop(context);
              },
              selected: _selectedPriceFilter == 'All',
              selectedTileColor: Colors.white10,
            ),
            ListTile(
              title: const Text('Under 2000 Rs', style: TextStyle(color: Colors.white70)),
              onTap: () {
                setState(() => _selectedPriceFilter = 'Under 2000 Rs');
                Navigator.pop(context);
              },
              selected: _selectedPriceFilter == 'Under 2000 Rs',
              selectedTileColor: Colors.white10,
            ),
            ListTile(
              title: const Text('Under 4000 Rs', style: TextStyle(color: Colors.white70)),
              onTap: () {
                setState(() => _selectedPriceFilter = 'Under 4000 Rs');
                Navigator.pop(context);
              },
              selected: _selectedPriceFilter == 'Under 4000 Rs',
              selectedTileColor: Colors.white10,
            ),
            ListTile(
              title: const Text('Under 6000 Rs', style: TextStyle(color: Colors.white70)),
              onTap: () {
                setState(() => _selectedPriceFilter = 'Under 6000 Rs');
                Navigator.pop(context);
              },
              selected: _selectedPriceFilter == 'Under 6000 Rs',
              selectedTileColor: Colors.white10,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Color(0xFF7DA7FF))),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index != _selectedIndex && Navigator.canPop(context)) {
      Navigator.pushNamed(context, '/${['home', 'categories', 'cart', 'profile'][index]}');
    }
    // print('Navigated to ${_navItems[_selectedIndex]['label']}');
  }

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFF7DA7FF);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // App Bar
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, left: 16, right: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent.withOpacity(0.45), Colors.black87],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54.withOpacity(0.4),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 30),
                  onPressed: () => Navigator.maybePop(context),
                ),
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white, size: 30),
                  onPressed: _showFilterDialog,
                ),
              ],
            ),
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 18),
                  const Icon(Icons.search, color: Colors.tealAccent, size: 26),
                  const SizedBox(width: 14),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Search categories...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white60, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Category List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                controller: _scrollController,
                children: List.generate(_filteredCategories.length, (index) {
                  final category = _filteredCategories[index];
                  final imagePath = _categoryImages[index % _categoryImages.length];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/watches/${category['title'].replaceAll(' ', '_')}');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Navigating to ${category['title']} Watches')),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Container(
                          height: 130,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(imagePath),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.35),
                                BlendMode.darken,
                              ),
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.18),
                                Colors.black.withOpacity(0.65),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26.withOpacity(0.45),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              category['title'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                                letterSpacing: 1.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.8),
                                    offset: const Offset(0, 4),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          // Use the reusable BottomNavBar widget from widgets/bottom_navigation_bar.dart
          BottomNavBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        ],
      ),
    );
  }
}