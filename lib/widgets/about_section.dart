import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  final Color accent;

  const AboutSection({super.key, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title outside the box, similar to "Contact Us"
          Text(
            'About Us',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white, // Changed to accent for theme consistency
            ),
          ),
          const SizedBox(height: 16), // Increased spacing for better separation
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.08), Colors.black.withOpacity(0.4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20), // Increased padding for better content spacing
              child: Text(
                'Welcome to WatchEase, your premier destination for luxury and smartwatches. Founded with a passion for timeless craftsmanship and cutting-edge technology, we bring you the finest selection from top brands worldwide. Our mission is to help you find the perfect timepiece that suits your style and needs.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.6, // Slightly increased line height for readability
                ),
                textAlign: TextAlign.justify, // Added justification for better text flow
              ),
            ),
          ),
        ],
      ),
    );
  }
}
