import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/animation.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final AnimationController? animationController; // Optional for external animation control

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.animationController,
  });

  final List<Map<String, dynamic>> _navItems = const [
    {'icon': Icons.home, 'label': 'Home', 'route': '/home'},
    {'icon': Icons.category, 'label': 'Categories', 'route': '/categories'},
    {'icon': Icons.shopping_cart, 'label': 'Cart', 'route': '/cart'},
    {'icon': Icons.person, 'label': 'Profile', 'route': '/profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 62,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.1), Colors.black.withOpacity(0.3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    onItemTapped(index);
                    if (Navigator.canPop(context) && index != selectedIndex) {
                      Navigator.pushNamed(context, item['route']);
                    }
                  },
                  child: AnimatedBuilder(
                    animation: (animationController ?? AnimationController(
                      vsync: Navigator.of(context),
                      duration: const Duration(milliseconds: 200),
                    )..forward()),
                    builder: (context, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.lightBlueAccent.withOpacity(0.2) : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Transform.scale(
                              scale: isSelected ? 1.1 : 1.0,
                              child: Icon(
                                item['icon'],
                                color: isSelected ? Colors.lightBlueAccent : Colors.white70,
                                size: 28,
                              ),
                            ),
                          ),
                          if (isSelected)
                            AnimatedOpacity(
                              opacity: animationController?.value ?? 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                item['label'],
                                style: TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}